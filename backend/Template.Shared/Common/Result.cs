namespace Template.Shared.Common;

public class Result<T>
{
    public bool IsSuccess { get; }
    public T? Value { get; }
    public ErrorCode? Error { get; }

    protected Result(bool isSuccess, T? value, ErrorCode? error)
    {
        IsSuccess = isSuccess;
        Value = value;
        Error = error;
    }

    public static Result<T> Success(T value) => new(true, value, null);
    public static Result<T> Failure(ErrorCode error) => new(false, default, error);
}

public class ErrorCode
{
    public string Code { get; }
    public string Message { get; }

    public ErrorCode(string code, string message)
    {
        Code = code;
        Message = message;
    }

    public static readonly ErrorCode NotFound = new("Error.NotFound", "The requested resource was not found.");
    public static readonly ErrorCode Unauthorized = new("Error.Unauthorized", "Unauthorized access.");
    public static readonly ErrorCode ServerError = new("Error.Server", "An unexpected server error occurred.");
}
