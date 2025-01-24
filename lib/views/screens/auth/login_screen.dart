import 'package:flutter/material.dart';
import 'package:intec_social_app/controllers/auth/auth_controller.dart';
import 'package:intec_social_app/views/screens/auth/forgot_password.dart';
import 'package:intec_social_app/views/screens/auth/register_screen.dart';
import 'package:intec_social_app/views/screens/nav_screens/home_screen.dart'; // Nueva pantalla principal

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor ingresa correo y contraseña')),
        );
        return;
      }

      final user = await _authController.loginWithEmailAndPassword(email, password);

      if (user != null) {
        // Navegar a la pantalla principal después de iniciar sesión
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio de sesión exitoso')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error en el inicio de sesión')),
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

  void loginWithGoogle() async {
    try {
      final user = await _authController.loginWithGoogle();
      if (user != null) {
        // Navegar a la pantalla principal después del inicio de sesión con Google
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio de sesión con Google exitoso')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error en inicio de sesión con Google')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Forgot Password
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                ),
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Divider with OR
              Row(
                children: [
                  const Expanded(child: Divider()),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'O',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              // Sign in with Google
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: loginWithGoogle,
                  icon: const Icon(Icons.login_outlined, color: Colors.black),
                  label: const Text(
                    'Inicia sesión con Google',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Sign Up Prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿No tienes una cuenta?'),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    ),
                    child: const Text(
                      'Regístrate',
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
