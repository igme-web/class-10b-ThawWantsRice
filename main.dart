import 'package:flutter/material.dart';

// 1) You need to install this so it works 'flutter pub add http'
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

//This is where we will fetch some sample JSON (have a look at it please)
final String postURL = "https://jsonplaceholder.typicode.com/posts";

// 2) ADD your JItem class below (we'll do in class or grab from 10b notes)

void main() {
  runApp(const MainApp());
}

class JItem {
  final int id;
  final String title;

  JItem({required this.id, required this.title});
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  // At the top of your State class
  final String postURL = 'https://jsonplaceholder.typicode.com/posts';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JItemsProvider(),
      child: const MaterialApp(home: DemoPage()),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  //3 Add better type checking here use the <JList> we created
  List<JItem> data = [];
  final String postURL = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<JItem>> getData() async {
    List<JItem> posts = [];
    var response = await http.get(Uri.parse(postURL));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var item in data) {
        posts.add(JItem(id: item['id'], title: item['title']));
      }
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Example'), backgroundColor: Colors.orange),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<JItemsProvider>().getData();
                  },
                  child: Text('Get Data'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<JItemsProvider>().clear();
                  },
                  child: Text('Clear Data'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                // Replace: itemCount: data.length,
                // With:
                itemCount: context.watch<JItemsProvider>().items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      // Replace: data[index].id.toString()
                      // With:
                      context
                          .watch<JItemsProvider>()
                          .items[index]
                          .id
                          .toString(),
                    ),
                    subtitle: Text(
                      // Replace: data[index].title
                      // With:
                      context.watch<JItemsProvider>().items[index].title,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JItemsProvider extends ChangeNotifier {
  List<JItem> items = [];
  final String postURL = "https://jsonplaceholder.typicode.com/posts";

  Future<void> getData() async {
    var response = await http.get(Uri.parse(postURL));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      for (var item in data) {
        items.add(JItem(id: item['id'], title: item['title']));
      }
    }

    notifyListeners(); // We'll fix this next
  }

  void clear() {
    items.clear();
    notifyListeners();
  }
}

//4) Create the getData Function here!
