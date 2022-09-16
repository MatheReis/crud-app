import 'package:app_crud_/pages/update_user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListUser extends StatefulWidget {
  const ListUser({Key? key}) : super(key: key);

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  /* Deletar usuário */
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> deleteUser(id) {
    return users
        .doc(id)
        .delete()
        .then((value) => debugPrint("Usuário deletado"))
        .catchError((error) => debugPrint("Falha ao deletar usuário: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          /* Atribuindo as informações do banco a uma variável */
          final List storeDocs = [];
          (snapshot.data!.docs as dynamic).map((DocumentSnapshot doc) {
            Map map = doc.data() as Map<String, dynamic>;
            storeDocs.add(map);
            map['id'] = doc.id;
          }).toList();

          /* Se tiver error */
          if (snapshot.hasError) {
            debugPrint('Error: ${snapshot.error}');
          }
          /* Se tiver conectando */
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          /* Se tudo der certo! */
          return ListView.builder(
            itemCount: storeDocs.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    storeDocs[index]['name'] ?? '',
                  ),
                  subtitle: Text(storeDocs[index]['email'] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpadateUser(
                                id: storeDocs[index]['id'],
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          deleteUser(storeDocs[index]['id']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
