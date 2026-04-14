using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Template.Domain.Entities;
using Template.Application.Common.Interfaces;

namespace Template.Application.Middlewares;

public class ErrorHandlingMiddleware : IMiddleware
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<ErrorHandlingMiddleware> _logger;

    public ErrorHandlingMiddleware(
        IServiceProvider serviceProvider,
        ILogger<ErrorHandlingMiddleware> logger)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context, RequestDelegate next)
    {
        try
        {
            await next(context);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, ex.Message);

            Guid? adminId = null;
            Guid? storeOwnerId = null;
            Guid? customerId = null;

            var error = new L_Error(
                adminId,
                storeOwnerId,
                customerId,
                ex.Message,
                ex.InnerException?.ToString(),
                ex.StackTrace
            );

            using var scope = _serviceProvider.CreateScope();
            var dbContext = scope.ServiceProvider.GetRequiredService<IAppDbContext>();

            dbContext.Error.Add(error);
            await dbContext.SaveChangesAsync(CancellationToken.None);

            // Re-throw the exception to let standard AspNetCore error handling return a 500
            // Or return a custom JSON payload here instead.
            throw;
        }
    }
}
