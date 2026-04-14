using Template.Shared.Entities;
using System;
using System.Security.Cryptography;

namespace Template.Domain.Entities;

public class RefreshToken : BaseEntity<Guid>
{
    public sealed override Guid Id { get; init; }
    public Guid UserId { get; private set; }
    public string Token { get; private set; }
    public DateTime Expires { get; private set; }
    public bool IsExpired => DateTime.UtcNow >= Expires;
    public bool IsActive => !IsExpired;

    protected RefreshToken() { Token = string.Empty; }

    public RefreshToken(Guid userId, int durationDays = 7)
    {
        Id = Guid.NewGuid();
        UserId = userId;
        Token = Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));
        Expires = DateTime.UtcNow.AddDays(durationDays);
    }
}
