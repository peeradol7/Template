using Microsoft.EntityFrameworkCore;
using Template.Application.Common.Interfaces;
using Template.Domain.Entities;

namespace Template.Infrastructure.Persistence;

public class AppDbContext : DbContext, IAppDbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    public DbSet<L_Error> Error { get; set; } = null!;
    public DbSet<User> Users { get; set; } = null!;
    public DbSet<RefreshToken> RefreshTokens { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        
        modelBuilder.Entity<L_Error>()
            .Property(e => e.Id)
            .ValueGeneratedNever();
            
        modelBuilder.Entity<User>()
            .Property(e => e.Id)
            .ValueGeneratedNever();

        modelBuilder.Entity<RefreshToken>()
            .Property(e => e.Id)
            .ValueGeneratedNever();
    }
}
