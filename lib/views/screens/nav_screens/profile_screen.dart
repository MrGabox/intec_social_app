import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intec_social_app/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  String? _name;
  String? _bio;
  String? _phone;
  String? _profileImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_currentUser == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Cambiar para acceder a la colección 'UserModel' y usar el uid como documento
      final userDoc = await _firestore
          .collection('UserModel')  // Usamos la colección UserModel
          .doc(_currentUser!.uid)  // El documento tiene el mismo ID que el UID del usuario
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          setState(() {
            _name = data['username'] ?? 'Sin nombre';
            _bio = data['bio'] ?? 'Sin biografía';
            _phone = data['phoneNumber'] ?? 'Sin teléfono';
            _profileImageUrl = data['profilePicture'];
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : null,
                child: _profileImageUrl == null
                    ? Icon(Icons.person, size: 50)
                    : null,
              ),
              SizedBox(height: 16),
              Text(
                _name ?? 'Nombre no disponible',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _bio ?? 'Biografía no disponible',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                _phone ?? 'Teléfono no disponible',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        currentName: _name,
                        currentBio: _bio,
                        currentPhone: _phone,
                        currentProfileImageUrl: _profileImageUrl,
                      ),
                    ),
                  ).then((_) => _loadUserData()); // Recargar datos después de editar
                },
                child: Text('Editar perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}