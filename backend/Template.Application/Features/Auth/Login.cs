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
    [HttpPost("login")]
    [ProducesResponseType(typeof(LoginResult.Success), StatusCodes.Status200OK)]
    public async Task<IActionResult> LoginAsync(
        [FromBody] LoginRequest request,
        CancellationToken cancellationToken)
    {
        var result = await Mediator.Send(new LoginCommand(request), cancellationToken);

        return result.Match<IActionResult>(
            success: s => Ok(new { accessToken = s.AccessToken, refreshToken = s.RefreshToken }),
            error: e => Unauthorized(new { message = e.Message })
        );
    }
}

public sealed record LoginRequest(string Email, string Password);

public sealed class LoginRequestValidator : AbstractValidator<LoginRequest>
{
    public LoginRequestValidator()
    {
        RuleFor(x => x.Email).NotEmpty().EmailAddress();
        RuleFor(x => x.Password).NotEmpty();
    }
}

[Union]
public partial record LoginResult
{
    public partial record Success(string AccessToken, string RefreshToken);
    public partial record Error(string Message);
}

public sealed record LoginCommand(LoginRequest Request) : IRequest<LoginResult>;

internal class LoginHandler : IRequestHandler<LoginCommand, LoginResult>
{
    private readonly IAppDbContext _dbContext;
    private readonly IJwtTokenGenerator _jwtTokenGenerator;

    public LoginHandler(IAppDbContext dbContext, IJwtTokenGenerator jwtTokenGenerator)
    {
        _dbContext = dbContext;
        _jwtTokenGenerator = jwtTokenGenerator;
    }

    public async Task<LoginResult> Handle(LoginCommand command, CancellationToken cancellationToken)
    {
        var user = await _dbContext.Users.SingleOrDefaultAsync(
            x => x.Email == command.Request.Email && x.PasswordHash == command.Request.Password, 
            cancellationToken);

        if (user == null)
            return new LoginResult.Error("Invalid credentials");

        var accessToken = _jwtTokenGenerator.GenerateToken(user);
        var refreshToken = new RefreshToken(user.Id);

        _dbContext.RefreshTokens.Add(refreshToken);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return new LoginResult.Success(accessToken, refreshToken.Token);
    }
}
