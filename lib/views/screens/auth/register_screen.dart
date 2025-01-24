import 'package:flutter/material.dart';
import 'package:intec_social_app/controllers/auth/auth_controller.dart';
import 'package:intec_social_app/views/screens/auth/login_screen.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      // Basic validation
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor completa todos los campos')),
        );
        return;
      }

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Las contraseñas no coinciden')),
        );
        return;
      }

      if (password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La contraseña debe tener al menos 6 caracteres')),
        );
        return;
      }

      final user = await _authController.registerWithEmailAndPassword(email, password);

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro exitoso')),
        );
        // Navigate to login or home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en el registro')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Crear Cuenta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              // Email Input
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Correo electrónico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              // Password Input
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              // Confirm Password Input
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Confirmar Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              // Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Registrarse',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              // Login Prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¿Ya tienes una cuenta?'),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ),
                    child: Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}