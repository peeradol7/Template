using Template.Shared.Entities;
using System;

namespace Template.Domain.Entities;

public class L_Error : BaseEntity<Guid>
{
    public sealed override Guid Id { get; init; }

    public Guid? AdminId { get; init; }
    public Guid? StoreOwnerId { get; init; }
    public Guid? CustomerId { get; init; }

    public string Message { get; init; } = string.Empty;
    public string? InnerMessage { get; init; }
    public string? StackTrace { get; init; }

    public L_Error(
        Guid? adminId,
        Guid? storeOwnerId,
        Guid? customerId,
        string message,
        string? innerMessage,
        string? stackTrace)
    {
        Id = Guid.NewGuid();
        AdminId = adminId;
        StoreOwnerId = storeOwnerId;
        CustomerId = customerId;
        Message = message;
        InnerMessage = innerMessage;
        StackTrace = stackTrace;
    }

    public L_Error(
        string message,
        string? innerMessage,
        string? stackTrace)
    {
        Id = Guid.NewGuid();
        Message = message;
        InnerMessage = innerMessage;
        StackTrace = stackTrace;
    }

    public L_Error()
    {
    }
}
