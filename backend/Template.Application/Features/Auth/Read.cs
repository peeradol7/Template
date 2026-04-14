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
    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(ReadUserResult.Success), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> ReadAsync(
        Guid id,
        CancellationToken cancellationToken)
    {
        var result = await Mediator.Send(
            new ReadUserQuery(id), cancellationToken);

        return result.Match<IActionResult>(
            success: s => Ok(s),
            notFound: _ => NotFound()
        );
    }
}

[Union]
public partial record ReadUserResult
{
    public partial record Success(Guid Id, string Username, string Email);
    public partial record NotFound();
}

public sealed record ReadUserQuery(Guid Id) : IRequest<ReadUserResult>;

internal class ReadUserHandler : IRequestHandler<ReadUserQuery, ReadUserResult>
{
    private readonly IAppDbContext _dbContext;

    public ReadUserHandler(IAppDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<ReadUserResult> Handle(ReadUserQuery query, CancellationToken cancellationToken)
    {
        var user = await _dbContext.Users.SingleOrDefaultAsync(x => x.Id == query.Id, cancellationToken);
        
        if (user is null)
        {
            return new ReadUserResult.NotFound();
        }

        return new ReadUserResult.Success(user.Id, user.Username, user.Email);
    }
}
