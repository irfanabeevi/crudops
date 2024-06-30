import "package:crudops/screens/homepage.dart";
import "package:crudops/services/userservice.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:uuid/uuid.dart";

import "../models/authmodel.dart";
import "../models/usermodel.dart";

class AddUserPage extends StatefulWidget {
  final UserModel? user;
  @override
  AddUserPage({Key? key, this.user}) : super(key: key);
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  UserService _userService = UserService();

  bool _edit = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  loadData() {
    if (widget.user != null)
      setState(() {
        _nameController.text = widget.user!.name!;
        _emailController.text = widget.user!.email!;
        _phoneController.text = widget.user!.phone!;
        _edit = true;
      });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _edit == true ? Text('Update User') : Text('Add User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Mobile'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a mobile number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_edit) {
                      UserModel _usermodel = UserModel(
                        id: widget.user?.id,
                        name: _nameController.text,
                        email: _emailController.text,
                        phone: _phoneController.text,
                        status: widget.user!.status,
                        createdAt: widget.user!.createdAt,
                      );
                      _userService
                          .updateUser(_usermodel)
                          .then((value) => Navigator.pop(context));
                    }else {
                      _addUser();
                    }
                  }
                },
                child: _edit == true ? Text('Update') : Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addUser() async {
    var id = Uuid().v1();
    UserModel _userModel = UserModel(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        id: id,
        status: 1,
        createdAt: DateTime.now());

    final user = await _userService.createUser(_userModel);
    if (user != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: _edit == true ? Text('User updated') : Text('Added new user'),
      ));
    }
  }
}
