import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/app/home/jobs/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>>? snapshot;
  final ItemWidgetBuilder<T>? itemBuilder;

  const ListItemsBuilder(
      {Key? key, required this.snapshot, required this.itemBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot!.hasData) {
      final List<T>? items = snapshot!.data;
      if (items!.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot!.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: "Can't load items right",
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              height: 0.5,
            ),
        itemCount: items.length + 2,
        itemBuilder: (context, index) {
          if (index == 0 || index == items.length + 1) {
            return Container();
          }
          return itemBuilder!(context, items[index - 1]);
        });
  }
}
