using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace Template.Application.Common.Models;

public static class PaginationExtensions
{
    public static async Task<PaginationResponse<T>> PaginateAsync<T>(
        this IQueryable<T> queryable,
        int pageNumber,
        int pageSize,
        CancellationToken cancellationToken = default)
    {
        var count = await queryable.CountAsync(cancellationToken);

        var items = await queryable
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken);

        return new PaginationResponse<T>(items, count, pageNumber, pageSize);
    }
    
    public static async Task<PaginationResponse<T>> PaginateAsync<T>(
        this IQueryable<T> queryable,
        PaginationRequest request,
        CancellationToken cancellationToken = default)
    {
        return await queryable.PaginateAsync(request.PageNumber, request.PageSize, cancellationToken);
    }
}
