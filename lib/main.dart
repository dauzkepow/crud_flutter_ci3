import 'package:crud_flutter_ci3/UserForm.dart';
import 'package:flutter/material.dart';
import 'package:crud_flutter_ci3/services/api_service.dart';
import 'package:crud_flutter_ci3/models/user.dart';

void main() {
  runApp(
    CrudApp(),
  );
}

class CrudApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD App',
      home: UserList(),
      routes: {
        '/add_user': (context) => UserForm(), // Define route to Add User page
      },
    );
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late ApiService apiService;
  late Future<List<User>> users;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    users = apiService.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: FutureBuilder<List<User>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          List<User> userList = snapshot.data!;

          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(userList[index].name),
                subtitle: Text(userList[index].email),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    apiService.deleteUser(userList[index].id).then((_) {
                      setState(() {
                        users = apiService.fetchUsers();
                      });
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          // Navigate to Add User Form
          Navigator.pushNamed(context, '/add_user');
        },
        child: Text('Add New User'),
      ),
    );
  }
}
