import 'package:flutter/material.dart';

class BasePaginatedList<T> extends StatefulWidget {
  final List<T> items;
  final bool isLoading;
  final bool hasNextPage;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? emptyWidget;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  final EdgeInsetsGeometry? padding;

  const BasePaginatedList({
    Key? key,
    required this.items,
    required this.isLoading,
    required this.hasNextPage,
    required this.itemBuilder,
    required this.onRefresh,
    required this.onLoadMore,
    this.emptyWidget,
    this.padding,
  }) : super(key: key);

  @override
  State<BasePaginatedList<T>> createState() => _BasePaginatedListState<T>();
}

class _BasePaginatedListState<T> extends State<BasePaginatedList<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      if (!widget.isLoading && widget.hasNextPage) {
        widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty && widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.items.isEmpty && !widget.isLoading) {
      return RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: widget.emptyWidget ?? const Center(child: Text('No items found')),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: widget.padding,
        itemCount: widget.items.length + (widget.hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == widget.items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                ),
              ),
            );
          }
          return widget.itemBuilder(context, widget.items[index], index);
        },
      ),
    );
  }
}
