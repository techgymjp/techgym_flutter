import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

  final CollectionReference _todos =
  FirebaseFirestore.instance.collection('todo');
  // Functions used for adding and editing
  Future<void> _add_or_update([DocumentSnapshot? documentSnapshot]) async {
    String mode = 'addition';
    // if (documentSnapshot != null) {
    //   mode = 'update';
    //   _todoController.text = documentSnapshot['todo'];
    //   _contentController.text = documentSnapshot['content'].toString();
    // }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
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
                  child: Text(mode== 'addition' ? 'Add' : 'Update'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // エラー時は"primary: Colors.red,"に変更
                  ),
                  onPressed: () async {
                    final String? todo = _todoController.text;
                    final String? content = _contentController.text;
                    // Addiing process
                    if (todo != null && content != null) {
                      if (mode == 'addition') {
                        // Persist a new product to Firestore
                        await _todos.add({"todo": todo, "content": content, "time":DateTime.now()});

                        // Show the snack bar for the add
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'Added ${todo}!',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                            )));
                      }

                      // Clear the text fields
                      _todoController.text = '';
                      _contentController.text = '';

                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
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
        // StreamBuilder to pass Firestore values to ListView.builder
        body: StreamBuilder(
          stream: _todos.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              // Display FireStore values in list format
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  // View documents in the card widget
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: InkWell(
                        child:  Text(documentSnapshot['todo'],
                          style: TextStyle(fontSize: 22.0, color: Colors.red),
                          maxLines: 1,
                        ),
                        onTap: (){
                          // passData(documentSnapshot);
                        },
                      ), // ToDo
                      subtitle: Text(documentSnapshot['content'].toString(),
                        maxLines: 4,
                      ), // Content
                      trailing: SizedBox(
                        width: 100,

                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        // Add Button
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () => _add_or_update(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
