import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Paquete recomendado para imágenes

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  XFile? _mediaFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickMedia(bool isVideo) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      imageQuality: 80,
    );
    setState(() {
      _mediaFile = pickedFile;
    });
  }

  void _uploadPost() {
    if (_mediaFile != null) {
      // Lógica para subir la publicación a Firebase
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Publicación subida con éxito')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecciona una imagen o video')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Publicación'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickMedia(false),
              child: _mediaFile == null
                  ? Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.add_photo_alternate,
                  size: 50,
                  color: Colors.grey,
                ),
              )
                  : Image.network(
                _mediaFile!.path,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadPost,
              child: const Text('Subir Publicación'),
            ),
          ],
        ),
      ),
    );
  }
}
