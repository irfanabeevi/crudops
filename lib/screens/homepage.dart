import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudops/screens/loginpage.dart';
import 'package:flutter/material.dart';
import '../models/authmodel.dart';
import '../models/usermodel.dart';
import '../services/authservice.dart';
import '../services/userservice.dart';
import '../widgets/text.dart';
import 'adduser.dart';

class HomePage extends StatefulWidget {
  final AuthModel? user;

  HomePage({this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userName;
  String? _userImage;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.user!.id)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name'];
          _userImage = userDoc['imgurl'];
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomText(
            text: 'Hello ,${_userName ?? 'Loading...'}',
            fontsize: 20,
            fontWeight: FontWeight.bold),
        actions: [
          _userImage != null
              ? CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_userImage!),
                )
              : CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person),
                ),
          IconButton(
              onPressed: () async {
                await _authService.logOut();

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newUser = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserPage()),
          );
          if (newUser != null) {
            setState(() {});
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                text: 'Current Users',
                fontsize: 18,
                fontWeight: FontWeight.bold),
            SizedBox(
              height: 15,
            ),
            StreamBuilder<List<UserModel>>(
              stream: _userService.getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error.toString()}'));
                }
                if (snapshot.hasData && snapshot.data!.length == 0) {
                  return Center(child: Text('No new user added'));
                }
                if (snapshot.hasData && snapshot.data!.length != 0) {
                  List<UserModel> _users = snapshot.data ?? [];
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        print(user);
                        return Card(
                          elevation: 5.0,
                          color: Colors.grey[200],
                          child: ListTile(
                            title: Text('${user.name}'),
                            subtitle: Text('${user.email}'),
                            leading: CircleAvatar(
                              backgroundColor: Color(0xFFB6B6B6),
                              backgroundImage:
                                  AssetImage('assets/images/profile_img.png'),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddUserPage(user: user)));
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    _showDeleteConfirmationDialog(
                                        context, user.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String? userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are you sure you want to delete this user?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _userService.deleteUser(userId);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User deleted successfully')),
                );
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
