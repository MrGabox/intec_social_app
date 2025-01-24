import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final String? currentName;
  final String? currentBio;
  final String? currentPhone;
  final String? currentProfileImageUrl;

  EditProfileScreen({
    this.currentName,
    this.currentBio,
    this.currentPhone,
    this.currentProfileImageUrl,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _profileImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName ?? '';
    _bioController.text = widget.currentBio ?? '';
    _phoneController.text = widget.currentPhone ?? '';
    _profileImageUrl = widget.currentProfileImageUrl;
  }

  Future<void> _updateProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Actualiza el documento del usuario en la colección 'users'
      await _firestore.collection('users').doc(user.uid).update({
        'username': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'profilePicture': _profileImageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil actualizado exitosamente')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error actualizando el perfil')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }




  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);

      try {
        final user = _auth.currentUser;
        if (user == null) return;

        final ref = _storage
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');
        await ref.putFile(file);

        final imageUrl = await ref.getDownloadURL();
        setState(() {
          _profileImageUrl = imageUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error subiendo la imagen')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar perfil'),
        actions: [
          IconButton(
            onPressed: _updateProfile,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : null,
                child: _profileImageUrl == null
                    ? Icon(Icons.camera_alt, size: 50)
                    : null,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'Biografía',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
