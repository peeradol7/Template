namespace Template.Application.Common.Models;

public class PaginationRequest
{
    public int PageNumber { get; init; } = 1;

    private int _pageSize = 10;
    private const int MaxPageSize = 100;

    public int PageSize
    {
        get => _pageSize;
        init => _pageSize = (value > MaxPageSize) ? MaxPageSize : value;
    }
}
