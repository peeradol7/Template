using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace Template.Application.Features;

[ApiController]
public abstract class ApiControllerBase<T> : ControllerBase
{
    private ISender? _mediator;
    private ILogger<T>? _logger;

    protected ISender Mediator =>
        _mediator ??= HttpContext.RequestServices.GetRequiredService<ISender>();

    protected ILogger<T> Logger =>
        _logger ??= HttpContext.RequestServices.GetRequiredService<ILogger<T>>();
}
