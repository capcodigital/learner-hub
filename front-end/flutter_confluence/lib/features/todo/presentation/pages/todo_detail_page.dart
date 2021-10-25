import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/shared_ui/primary_button.dart';
import 'package:flutter_confluence/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:flutter_confluence/features/todo/presentation/widgets/circular_todo_icon.dart';

class TodoDetailPage extends StatefulWidget {
  const TodoDetailPage({Key? key, this.todo}) : super(key: key);

  final MockTodo? todo;

  @override
  _TodoDetailPageState createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _isInEditingMode = true;
    } else {
      _isInEditingMode = false;
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
              padding: const EdgeInsets.only(top: 32),
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
                      hintText: 'Add your title here'),
                  maxLength: 50,
                  controller: _titleController,
                  onSubmitted: (value) {
                    _initialTitleText = value;
                    save();
                  },
                  onChanged: (value) {
                    _initialTitleText = value;
                    save();
                  },
                ),
              )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
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
                  hintText: 'Add your notes here'),
              controller: _contentController,
              onSubmitted: (value) {
                _initialContentText = value;
                save();
              },
              onChanged: (value) {
                _initialContentText = value;
                save();
              },
            ),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32, left: 32, right: 32),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(
                    height: 24,
                  ),
                  PrimaryButton(
                      text: 'Add',
                      onPressed: (_titleController.text.isNotEmpty &&
                              _contentController.text.isNotEmpty)
                          ? save
                          : null,
                      color: Constants.ACCENT_COLOR),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void save() {
    print(_initialTitleText);
    print(_initialContentText);
  }
}
