import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/colours.dart';
import 'package:flutter_confluence/core/layout_constants.dart';
import 'package:flutter_confluence/core/shared_ui/primary_button.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:flutter_confluence/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:flutter_confluence/features/todo/presentation/pages/todo_detail_page.dart';
import 'package:flutter_confluence/features/todo/presentation/widgets/swipeable_todo_item.dart';

/// Our root page of the todo flow.
/// This page is the beginning of our todo flow, where upon landing,
/// the user will be presented with their list of todos,
///  either `in progress` or `done`.
///
/// The options that are given to users on this page are:
/// 1. Add a new todo.
/// 2. Delete an existing todo.
/// 3. Update an exisitng todo.
/// 4. Mark a todo as `done`. (If on the `in progress` tab).
class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(LayoutConstants.BTN_WIDGET_HEIGHT),
            child: SizedBox(
              height: LayoutConstants.BTN_WIDGET_HEIGHT,
              child: TabBar(
                labelStyle: const TextStyle(fontSize: 18, fontFamily: 'Lato'),
                unselectedLabelColor: Colors.pink[200],
                indicatorWeight: LayoutConstants.EXTRA_EXTRA_SMALL_PADDING,
                indicatorColor: Colors.pink,
                tabs: const [
                  Tab(
                    text: 'TO DO',
                  ),
                  Tab(
                    text: 'DONE',
                  )
                ],
              ),
            ),
          ),
          body: TabBarView(children: [
            Column(
              children: [
                const SizedBox(
                  height: LayoutConstants.LARGE_PADDING,
                ),
                Expanded(child: _createTodoList(inProgress: true)),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(LayoutConstants.LARGE_PADDING),
                      child: PrimaryButton(
                        text: 'Add new',
                        color: Colors.transparent,
                        borderColor: Colors.white,
                        onPressed: () => onTodoSelected(null),
                      ),
                    ))
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  height: LayoutConstants.LARGE_PADDING,
                ),
                Expanded(child: _createTodoList(inProgress: false)),
                const SizedBox(
                  height: LayoutConstants.SMALL_PADDING,
                ),
              ],
            ),
          ]),
        ));
  }

  onTodoSelected(Todo? todo) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TodoDetailPage(
            todo: todo,
          ),
        ));
  }

  BlocBuilder<TodoBloc, TodoState> _createTodoList({required bool inProgress}) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoadedSuccess) {
          final todos =
              inProgress ? state.inProgressTodos : state.completedTodos;
          return RefreshIndicator(
            color: Colours.ACCENT_COLOR,
            backgroundColor: Colors.transparent,
            onRefresh: () async =>
                BlocProvider.of<TodoBloc>(context).add(GetTodosEvent()),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return SwipeableTodoItem(
                  todo: todos[index],
                  onDismiss: (direction) => onDismiss(
                      todos: todos, index: index, direction: direction),
                  onTodoPressed: () => onTodoSelected(todos[index]),
                );
              },
              itemCount: todos.length,
              separatorBuilder: (BuildContext context, _) {
                return const Divider(
                  color: Colors.white,
                  endIndent: LayoutConstants.LARGE_PADDING,
                  indent: LayoutConstants.LARGE_PADDING,
                  height: LayoutConstants.LARGE_PADDING,
                );
              },
            ),
          );
        } else if (state is TodoLoadedError) {
          return Center(
            child: Text(state.message,
                style: Theme.of(context).textTheme.bodyText1),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  onDismiss(
      {required List<Todo> todos,
      required int index,
      required DismissDirection direction}) {
    if (direction == DismissDirection.startToEnd) {
      final todo = Todo(
          id: todos[index].id,
          userId: todos[index].userId,
          title: todos[index].title,
          content: todos[index].content,
          isCompleted: true);
      BlocProvider.of<TodoBloc>(context).add(UpdateTodoEvent(todo: todo));
    } else if (direction == DismissDirection.endToStart) {
      BlocProvider.of<TodoBloc>(context)
          .add(DeleteTodoEvent(todo: todos[index]));
    }
  }
}
