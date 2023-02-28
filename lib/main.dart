import 'package:flutter/material.dart';

void main() => runApp(NoteApp());

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      home: NoteList(),
    );
  }
}

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  List<String> notes = [];

  void addNote() async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditor()),
    );
    if (result != null) {
      setState(() {
        notes.add(result);
      });
    }
  }

  Widget buildNoteList() {
    if (notes.isEmpty) {
      return Center(
        child: Text(
          'No notes yet',
          style: TextStyle(fontSize: 24.0),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(notes[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditor(initialText: notes[index]),
                ),
              ).then((result) {
                if (result != null) {
                  setState(() {
                    notes[index] = result;
                  });
                }
              });
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  notes.removeAt(index);
                });
              },
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: buildNoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: addNote,
        child: Icon(Icons.add),
      ),
    );
  }
}

class NoteEditor extends StatefulWidget {
  final String initialText;

  NoteEditor({this.initialText});

  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Editor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: controller,
          autofocus: true,
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Enter your note',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, controller.text);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
