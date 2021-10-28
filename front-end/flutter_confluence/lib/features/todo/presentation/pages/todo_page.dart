import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/shared_ui/primary_button.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:flutter_confluence/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:flutter_confluence/features/todo/presentation/pages/todo_detail_page.dart';
import 'package:flutter_confluence/features/todo/presentation/widgets/swipeable_todo_item.dart';

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
            preferredSize: const Size.fromHeight(64),
            child: SizedBox(
              height: 64,
              child: TabBar(
                labelStyle: const TextStyle(fontSize: 18, fontFamily: 'Lato'),
                unselectedLabelColor: Colors.pink[200],
                indicatorWeight: 4,
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
                  height: 32,
                ),
                Expanded(child: _createTodoList(inProgress: true)),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: PrimaryButton(
                        text: 'Add new',
                        color: Colors.transparent,
                        borderColor: Colors.white,
                        onPressed: () => onAddNewButtonPressed(null),
                      ),
                    ))
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  height: 32,
                ),
                Expanded(child: _createTodoList(inProgress: false)),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ]),
        ));
  }

  onAddNewButtonPressed(Todo? todo) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TodoDetailPage(
            todo: todo,
          ),
        )).then((value) {
      setState(() {});
    });
  }

  BlocBuilder<TodoBloc, TodoState> _createTodoList({required bool inProgress}) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoadedSuccess) {
          final todos =
              inProgress ? state.inProgressTodos : state.completedTodos;
          return RefreshIndicator(
            color: Colors.pink,
            backgroundColor: Colors.transparent,
            onRefresh: () async =>
                BlocProvider.of<TodoBloc>(context).add(GetTodosEvent()),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return SwipeableTodoItem(
                  todo: todos[index],
                  onDismiss: (direction) => onDismiss(
                      todos: todos, index: index, direction: direction),
                  onTodoPressed: () => onAddNewButtonPressed(todos[index]),
                );
              },
              itemCount: todos.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  color: Colors.white,
                  endIndent: 32,
                  indent: 32,
                  height: 32,
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
