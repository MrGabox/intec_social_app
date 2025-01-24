import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar usuarios...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                // Actualizar resultados según el input
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Número de resultados de búsqueda
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150'), // Imagen del usuario
                  ),
                  title: Text('Usuario $index'),
                  subtitle: Text('user$index@example.com'),
                  onTap: () {
                    // Ir al perfil del usuario seleccionado
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
