using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Template.Domain.Entities;

namespace Template.Application.Common.Interfaces;

public interface IAppDbContext
{
    DbSet<L_Error> Error { get; }
    DbSet<User> Users { get; }
    DbSet<RefreshToken> RefreshTokens { get; }

    Task<int> SaveChangesAsync(CancellationToken cancellationToken);
}
