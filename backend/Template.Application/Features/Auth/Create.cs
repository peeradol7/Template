using Dunet;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using System;
using System.Threading;
using System.Threading.Tasks;
using Template.Domain.Entities;
using Template.Application.Common.Interfaces;

namespace Template.Application.Features.Auth;

public partial class AuthController
{
    [HttpPost]
    [ProducesResponseType(typeof(CreateUserResult.Success), StatusCodes.Status200OK)]
    public async Task<IActionResult> CreateAsync(
        [FromBody] CreateUserRequest request,
        CancellationToken cancellationToken)
    {
        var result = await Mediator.Send(
            new CreateUserCommand(request), cancellationToken);

        return result.Match<IActionResult>(
            success: s => Ok(s),
            error: e => BadRequest(e.Message)
        );
    }
}

public sealed record CreateUserRequest(string Username, string Email, string Password);

public sealed class CreateUserRequestValidator : AbstractValidator<CreateUserRequest>
{
    public CreateUserRequestValidator()
    {
        RuleFor(x => x.Username).NotEmpty();
        RuleFor(x => x.Email).NotEmpty().EmailAddress();
        RuleFor(x => x.Password).NotEmpty().MinimumLength(6);
    }
}

[Union]
public partial record CreateUserResult
{
    public partial record Success(Guid Id);
    public partial record Error(string Message);
}

public sealed record CreateUserCommand(CreateUserRequest Request) : IRequest<CreateUserResult>;

internal class CreateUserHandler : IRequestHandler<CreateUserCommand, CreateUserResult>
{
    private readonly IAppDbContext _dbContext;

    public CreateUserHandler(IAppDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<CreateUserResult> Handle(CreateUserCommand command, CancellationToken cancellationToken)
    {
        var user = new User(command.Request.Username, command.Request.Email, command.Request.Password);
        
        _dbContext.Users.Add(user);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return new CreateUserResult.Success(user.Id);
    }
}
