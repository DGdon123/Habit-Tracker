import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendSearchedPage extends StatelessWidget {
  final List<QueryDocumentSnapshot> searchResults;
  const FriendSearchedPage({super.key, required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          var data = searchResults[index].data() as Map<String, dynamic>;
          return ListTile(
            leading: data["photoUrl"].isEmpty
                ? CircleAvatar(
                    child: Text(data['name'][0]),
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(data['photoUrl']),
                  ),
            title: Text(data['name']),
            subtitle: Text(data['email']),
            trailing: Icon(Icons.person_add),
          );
        },
      )),
    );
  }
}
