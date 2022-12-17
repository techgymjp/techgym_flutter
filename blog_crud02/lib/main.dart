import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ToDo App',
      home: ToDoPage(),
    );
  }
}

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);
  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _add_or_update() async {
    String mode = 'addition';

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _todoController,
                  decoration: const InputDecoration(labelText: 'ToDo'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Content'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(mode == 'addition' ? 'Add' : 'Update'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () async {
                    final String? todo = _todoController.text;
                    final String? content = _contentController.text;
                    if (todo != null && content != null) {
                        // Show the snack bar for the add
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'Added ${todo}!',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white),
                            )));
                      }
                      if (mode == 'update') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  'Updated Content!',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                      backgroundColor: Colors.red),
                                )));
                      }
                      _todoController.text = '';
                      _contentController.text = '';

                      Navigator.of(context).pop();
                    }
                )
              ],
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ToDo App'),
          backgroundColor: Colors.red,
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () => _add_or_update(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
