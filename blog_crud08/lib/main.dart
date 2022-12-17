import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "",
          authDomain: "",
          databaseURL:
              "",
          projectId: "",
          storageBucket: "",
          messagingSenderId: "",
          appId: "",
          measurementId: "));
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

  passData(DocumentSnapshot snap) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostDetails(
              snapshot: snap,
            )));
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
                        child: Text(
                          documentSnapshot['todo'],
                          style: TextStyle(fontSize: 22.0, color: Colors.red),
                          maxLines: 1,
                        ),
                        onTap: () {
                          passData(documentSnapshot);
                        },
                      ),
                      subtitle: Text(
                        documentSnapshot['content'].toString(),
                        maxLines: 4,
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
      ),
    );
  }
}

///////////////////////////////
class PostDetails extends StatefulWidget {
  DocumentSnapshot snapshot;

  PostDetails({required this.snapshot});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final CollectionReference _todos =
      FirebaseFirestore.instance.collection('todo');

  passData(DocumentSnapshot snap) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SubPostDetails(
              snapshot: snap,
            )));
  }

  @override
  Widget build(BuildContext context) {
    var _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        backgroundColor: Colors.red,
      ),
      body: Card(
          elevation: 10.0,
          margin: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                          child: Text(widget.snapshot.get('todo'),
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.red,
                              ))),
                    ],
                  )),
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  widget.snapshot.get('content'),
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: _screenSize.width,
                height: _screenSize.height / 2,
                child: StreamBuilder(
                  stream: _todos
                      .doc(widget.snapshot.id)
                      .collection('SubCollection')
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
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
                                child: Text(
                                  documentSnapshot['todo2'],
                                  style: TextStyle(
                                      fontSize: 22.0, color: Colors.red),
                                  maxLines: 1,
                                ),
                                onTap: () {
                                  passData(documentSnapshot);
                                },
                              ),
                              subtitle: Text(
                                documentSnapshot['content2'].toString(),
                                maxLines: 4,
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
              ),
            ],
          )),
    );
  }

  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
}

///////////////////////////////
class SubPostDetails extends StatefulWidget {
  DocumentSnapshot snapshot;

  SubPostDetails({required this.snapshot});

  @override
  State<SubPostDetails> createState() => _SubPostDetailsState();
}

class _SubPostDetailsState extends State<SubPostDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SubDetails"),
        backgroundColor: Colors.red,
      ),
      body: Card(
          elevation: 10.0,
          margin: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                          child: Text(widget.snapshot.get('todo2'),
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.red,
                              ))),
                    ],
                  )),
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  widget.snapshot.get('content2'),
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ],
          )),
    );
  }
}
