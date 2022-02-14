import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/layout_constants.dart';
import 'package:flutter_confluence/core/shared_ui/primary_button.dart';
import 'package:flutter_confluence/features/todo/domain/entities/todo.dart';
import 'package:flutter_confluence/features/todo/domain/params/todo_params.dart';
import 'package:flutter_confluence/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:flutter_confluence/features/todo/presentation/widgets/circular_todo_icon.dart';

class TodoDetailPage extends StatefulWidget {
  const TodoDetailPage({Key? key, this.todo}) : super(key: key);

  final Todo? todo;

  @override
  _TodoDetailPageState createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _isInEditingMode = true;
      _isButtonDisabled = false;
    } else {
      _isInEditingMode = false;
      _isButtonDisabled = true;
    }
    _initialTitleText = _isInEditingMode ? widget.todo!.title : '';
    _initialContentText = _isInEditingMode ? widget.todo!.content : '';
    _titleController = TextEditingController(text: _initialTitleText);
    _contentController = TextEditingController(text: _initialContentText);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late bool _isInEditingMode;
  late String _initialTitleText;
  late String _initialContentText;
  late bool _isButtonDisabled;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My TODOs',
          style: Theme.of(context).textTheme.headline1,
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
              padding:
                  const EdgeInsets.only(top: LayoutConstants.LARGE_PADDING),
              child: ListTile(
                leading: const CircularTodoIcon(
                  backgroundColor: Colors.white,
                  iconColor: Colors.black,
                ),
                title: TextField(
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'FuturaPT',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      hintText: 'Add your title here..'),
                  maxLength: 50,
                  controller: _titleController,
                  onSubmitted: (value) {
                    save();
                  },
                  onChanged: (_) {
                    setState(() {
                      _isButtonDisabled = _contentController.text.isEmpty ||
                          _titleController.text.isEmpty;
                    });
                  },
                ),
              )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(
                top: LayoutConstants.LARGE_PADDING,
                left: LayoutConstants.LARGE_PADDING,
                right: LayoutConstants.LARGE_PADDING),
            child: TextField(
              maxLines: null,
              style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Lato',
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  hintText: 'Add your notes here..'),
              controller: _contentController,
              onSubmitted: (value) {
                save();
              },
              onChanged: (_) {
                setState(() {
                  _isButtonDisabled = _contentController.text.isEmpty &&
                      _titleController.text.isEmpty;
                });
              },
            ),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: LayoutConstants.LARGE_PADDING,
                  left: LayoutConstants.LARGE_PADDING,
                  right: LayoutConstants.LARGE_PADDING),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(
                    height: LayoutConstants.REGULAR_PADDING,
                  ),
                  PrimaryButton(
                    text: _isInEditingMode ? 'Update' : 'Add',
                    onPressed: _isButtonDisabled ? null : save,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void save() {
    if (_isInEditingMode) {
      final todo = Todo(
          id: widget.todo!.id,
          userId: widget.todo!.userId,
          title: _titleController.text,
          content: _contentController.text,
          isCompleted: widget.todo!.isCompleted);
      BlocProvider.of<TodoBloc>(context).add(UpdateTodoEvent(todo: todo));
    } else {
      final todo = TodoParams(
          title: _titleController.text,
          content: _contentController.text,
          isCompleted: false);
      BlocProvider.of<TodoBloc>(context).add(AddTodoEvent(todo: todo));
    }
    Navigator.pop(context);
  }
}
