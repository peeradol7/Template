using Dunet;
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
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> DeleteAsync(
        Guid id,
        CancellationToken cancellationToken)
    {
        var result = await Mediator.Send(
            new DeleteUserCommand(id), cancellationToken);

        return result.Match<IActionResult>(
            success: _ => NoContent(),
            notFound: _ => NotFound()
        );
    }
}

[Union]
public partial record DeleteUserResult
{
    public partial record Success();
    public partial record NotFound();
}

public sealed record DeleteUserCommand(Guid Id) : IRequest<DeleteUserResult>;

internal class DeleteUserHandler : IRequestHandler<DeleteUserCommand, DeleteUserResult>
{
    private readonly IAppDbContext _dbContext;

    public DeleteUserHandler(IAppDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<DeleteUserResult> Handle(DeleteUserCommand command, CancellationToken cancellationToken)
    {
        var user = await _dbContext.Users.SingleOrDefaultAsync(x => x.Id == command.Id, cancellationToken);
        
        if (user is null)
        {
            return new DeleteUserResult.NotFound();
        }

        _dbContext.Users.Remove(user);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return new DeleteUserResult.Success();
    }
}
