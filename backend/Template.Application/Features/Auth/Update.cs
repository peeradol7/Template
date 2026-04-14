using Dunet;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading;
using System.Threading.Tasks;
using Template.Application.Common.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace Template.Application.Features.Auth;

public partial class AuthController
{
    [Authorize]
    [HttpPut("{id:guid}")]
    [ProducesResponseType(typeof(UpdateUserResult.Success), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateAsync(
        Guid id,
        [FromBody] UpdateUserRequest request,
        CancellationToken cancellationToken)
    {
        var result = await Mediator.Send(
            new UpdateUserCommand(id, request), cancellationToken);

        return result.Match<IActionResult>(
            success: s => Ok(s),
            notFound: _ => NotFound()
        );
    }
}

public sealed record UpdateUserRequest(string Username, string Email);

public sealed class UpdateUserRequestValidator : AbstractValidator<UpdateUserRequest>
{
    public UpdateUserRequestValidator()
    {
        RuleFor(x => x.Username).NotEmpty();
        RuleFor(x => x.Email).NotEmpty().EmailAddress();
    }
}

[Union]
public partial record UpdateUserResult
{
    public partial record Success(Guid Id);
    public partial record NotFound();
}

public sealed record UpdateUserCommand(Guid Id, UpdateUserRequest Request) : IRequest<UpdateUserResult>;

internal class UpdateUserHandler : IRequestHandler<UpdateUserCommand, UpdateUserResult>
{
    private readonly IAppDbContext _dbContext;

    public UpdateUserHandler(IAppDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<UpdateUserResult> Handle(UpdateUserCommand command, CancellationToken cancellationToken)
    {
        var user = await _dbContext.Users.SingleOrDefaultAsync(x => x.Id == command.Id, cancellationToken);
        
        if (user is null)
        {
            return new UpdateUserResult.NotFound();
        }

        user.Update(command.Request.Username, command.Request.Email);
        
        await _dbContext.SaveChangesAsync(cancellationToken);

        return new UpdateUserResult.Success(user.Id);
    }
}
