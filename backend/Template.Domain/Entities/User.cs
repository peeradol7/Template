using Template.Shared.Entities;
using System;
using Template.Domain.Entities;

namespace Template.Domain.Entities;

public class User : BaseEntity<Guid>
{
    public sealed override Guid Id { get; init; }
    public string Username { get; private set; } = null!;
    public string Email { get; private set; } = null!;
    public string PasswordHash { get; private set; } = null!;

    protected User()
    {
    }

    public User(string username, string email, string passwordHash)
    {
        Id = Guid.NewGuid();
        Username = username;
        Email = email;
        PasswordHash = passwordHash;
    }

    public void Update(string username, string email)
    {
        Username = username;
        Email = email;
    }

    public void UpdatePassword(string passwordHash)
    {
        PasswordHash = passwordHash;
    }
}
