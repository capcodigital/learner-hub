import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/layout_constants.dart';
import 'package:flutter_confluence/core/utils/media_util.dart';
import 'package:flutter_confluence/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:flutter_confluence/features/todo/presentation/widgets/circular_todo_icon.dart';

class SwipeableTodoItem extends StatefulWidget {
  const SwipeableTodoItem({
    Key? key,
    required this.todo,
    required this.onDismiss,
    required this.onTodoPressed,
  }) : super(key: key);
  final MockTodo todo;
  final Function(DismissDirection)? onDismiss;
  final VoidCallback onTodoPressed;

  @override
  _SwipeableTodoItemState createState() => _SwipeableTodoItemState();
}

class _SwipeableTodoItemState extends State<SwipeableTodoItem> {
  @override
  Widget build(BuildContext context) {
    final MediaQueriesImpl mediaQueries =
        MediaQueriesImpl(buildContext: context);
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      onDismissed: widget.onDismiss,
      secondaryBackground: Container(
        color: Colors.red,
        child: Row(
          children: [
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                ),
                Text('Delete', style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(
              width:
                  mediaQueries.applyWidth(context, LayoutConstants.SMALL_SCALE),
            ),
          ],
        ),
      ),
      background: Container(
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width:
                  mediaQueries.applyWidth(context, LayoutConstants.SMALL_SCALE),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(
                  Icons.done_rounded,
                  color: Colors.red,
                ),
                Text('Done', style: TextStyle(color: Colors.red)),
              ],
            ),
          ],
        ),
      ),
      child: ListTile(
        leading: const CircularTodoIcon(
          backgroundColor: Colors.black,
          iconColor: Colors.white,
        ),
        onTap: widget.onTodoPressed,
        title: Text(
          widget.todo.title,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'FuturaPT',
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
