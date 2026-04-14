using Dunet;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;
using Template.Application.Common.Interfaces;
using Template.Domain.Entities;

namespace Template.Application.Features.Auth;

public partial class AuthController
{
    [HttpPost("renew")]
    [ProducesResponseType(typeof(RenewResult.Success), StatusCodes.Status200OK)]
    public async Task<IActionResult> RenewAsync(
        [FromBody] RenewRequest request,
        CancellationToken cancellationToken)
    {
        var result = await Mediator.Send(new RenewCommand(request), cancellationToken);

        return result.Match<IActionResult>(
            success: s => Ok(new { accessToken = s.AccessToken, refreshToken = s.RefreshToken }),
            error: e => StatusCode(498, new { message = e.Message }) // 498 Token Expired matched Flutter Interceptor logic
        );
    }
}

public sealed record RenewRequest(string RefreshToken);

public sealed class RenewRequestValidator : AbstractValidator<RenewRequest>
{
    public RenewRequestValidator()
    {
        RuleFor(x => x.RefreshToken).NotEmpty();
    }
}

[Union]
public partial record RenewResult
{
    public partial record Success(string AccessToken, string RefreshToken);
    public partial record Error(string Message);
}

public sealed record RenewCommand(RenewRequest Request) : IRequest<RenewResult>;

internal class RenewHandler : IRequestHandler<RenewCommand, RenewResult>
{
    private readonly IAppDbContext _dbContext;
    private readonly IJwtTokenGenerator _jwtTokenGenerator;

    public RenewHandler(IAppDbContext dbContext, IJwtTokenGenerator jwtTokenGenerator)
    {
        _dbContext = dbContext;
        _jwtTokenGenerator = jwtTokenGenerator;
    }

    public async Task<RenewResult> Handle(RenewCommand command, CancellationToken cancellationToken)
    {
        var storedToken = await _dbContext.RefreshTokens
            .SingleOrDefaultAsync(x => x.Token == command.Request.RefreshToken, cancellationToken);

        if (storedToken == null || !storedToken.IsActive)
        {
            return new RenewResult.Error("Refresh token invalid or expired");
        }

        var user = await _dbContext.Users.SingleOrDefaultAsync(x => x.Id == storedToken.UserId, cancellationToken);
        if (user == null)
        {
            return new RenewResult.Error("User not found");
        }

        var newAccessToken = _jwtTokenGenerator.GenerateToken(user);
        var newRefreshToken = new RefreshToken(user.Id);

        _dbContext.RefreshTokens.Remove(storedToken); // revoke old
        _dbContext.RefreshTokens.Add(newRefreshToken); // save new
        
        await _dbContext.SaveChangesAsync(cancellationToken);

        return new RenewResult.Success(newAccessToken, newRefreshToken.Token);
    }
}
