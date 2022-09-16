import 'package:app_crud_/pages/pages.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleAppBar = 'CRUD App';
    Color color = Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titleAppBar,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: const ListUser(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddUser(),
            ),
          );
        },
      ),
    );
  }
}
