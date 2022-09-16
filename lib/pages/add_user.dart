import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final formKey = GlobalKey<FormState>();

  var name = "";
  var email = "";

  /* Create controller */
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  clearText() {
    nameController.clear();
    emailController.clear();
  }

  /* Adicionar dados */
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() {
    return users.add({'name': name, 'email': email}).then((value) {
      debugPrint("Usuário adicionado");

      // ignore: invalid_return_type_for_catch_error
    }).catchError((error) => debugPrint("Falha ao adicionar usuário: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicione um novo usuário"),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um email';
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um email';
                  } else if (!value.contains('@')) {
                    return 'Por favor, insira um email válido';
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
              child: ElevatedButton(
                child: const Text('Criar usuário'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      name = nameController.text;
                      email = emailController.text;
                      addUser();
                      clearText();
                      Navigator.pop(context);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
