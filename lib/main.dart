import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  /*WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );*/
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskIt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String category = '';
  String priority = 'Low';
  bool _isLoading = false;

  // function to simulate saving to Firestore
  Future<void> _saveToFirestore() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2)); // simulate delay
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskIt'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Title',
                            prefixIcon: const Icon(Icons.title),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            title = value ?? '';
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Description',
                            prefixIcon: const Icon(Icons.description),
                          ),
                          onSaved: (value) {
                            description = value ?? '';
                          },
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: 'Category',
                            prefixIcon: const Icon(Icons.category),
                          ),
                          onChanged: (value) {
                            setState(() {
                              category = value ?? '';
                            });
                          },
                          onSaved: (value) {
                            category = value ?? '';
                          },
                          items: <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(
                              value: 'Work',
                              child: Text('Work'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Personal',
                              child: Text('Personal'),
                            ),
                          ],
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            prefixIcon: const Icon(Icons.priority_high),
                          ),
                          value: priority,
                          items: const <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(
                              value: 'Low',
                              child: Text('Low'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Medium',
                              child: Text('Medium'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'High',
                              child: Text('High'),
                            ),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              priority = newValue!;
                            });
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Submit'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              await _saveToFirestore();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Submitted!'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
