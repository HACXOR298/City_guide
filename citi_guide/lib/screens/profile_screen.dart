import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabase = Supabase.instance.client;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = _supabase.auth.currentUser;
    _nameController.text = user?.userMetadata?['name'] ?? '';
  }

  void _updateProfile() async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(data: {'name': _nameController.text.trim()}),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _signOut() async {
    await _supabase.auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _updateProfile, child: Text('Update Profile')),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _signOut, child: Text('Sign Out')),
          ],
        ),
      ),
    );
  }
}
