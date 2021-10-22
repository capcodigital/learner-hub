import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/features/todo/presentation/bloc/todo_bloc.dart';
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
            appBar: AppBar(
                toolbarHeight: 24,
                backgroundColor: Colors.black,
                bottom: TabBar(
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
                )),
            body: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: TabBarView(children: [
                _createTodoList(inProgress: true),
                _createTodoList(inProgress: false),
              ]),
            )));
  }

  BlocBuilder<TodoBloc, TodoState> _createTodoList({required bool inProgress}) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoadedSuccess) {
          final todos =
              inProgress ? state.inProgressTodos : state.completedTodos;
          return ListView.separated(
            itemBuilder: (context, index) {
              return SwipeableTodoItem(
                todo: todos[index],
                onDismiss: (direction) =>
                    onDismiss(todos: todos, index: index, direction: direction),
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
          );
        }
        return Text(state.toString());
      },
    );
  }

  onDismiss(
      {required List<MockTodo> todos,
      required int index,
      required DismissDirection direction}) {
    if (direction == DismissDirection.startToEnd) {
      BlocProvider.of<TodoBloc>(context)
          .add(UpdateTodoEvent(todo: todos[index]));
    } else if (direction == DismissDirection.endToStart) {
      setState(() {
        todos.removeAt(index);
      });
    }
  }
}
