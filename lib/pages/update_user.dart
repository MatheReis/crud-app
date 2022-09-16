import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpadateUser extends StatefulWidget {
  final String id;
  const UpadateUser({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<UpadateUser> createState() => _UpadateUserState();
}

class _UpadateUserState extends State<UpadateUser> {
  final formKey = GlobalKey<FormState>();

  /* Alterando as informações */
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> updateUsers(id, name, email) {
    return users
        .doc(id)
        .update({'name': name, 'email': email})
        .then((value) => debugPrint("Usuário Atualizado"))
        .catchError(
            (error) => debugPrint("Falha ao atualizar usuário: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          /* Chamada para o nosso id */
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.id)
              .get(),
          builder: (context, snapshot) {
            /* Se tiver erro */
            if (snapshot.hasError) {
              debugPrint('Error: ${snapshot.error}');
            }
            /* Se estiver carregando */
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var data = snapshot.data!.data();
            var name = data!['name'];
            var email = data['email'];

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextFormField(
                    initialValue: name,
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextFormField(
                    initialValue: email,
                    onChanged: (value) => email = value,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: const Text('Update'),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          updateUsers(widget.id, name, email);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Reset'),
                      onPressed: () => {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
