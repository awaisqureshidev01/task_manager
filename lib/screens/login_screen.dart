import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/screens/task_list_screen.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Padding(
        padding:const EdgeInsets.all(16.0),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Welcome Back!',style: TextStyle(color: Colors.white,fontSize: 22),),
              const SizedBox(height: 30,),
              Container(
                padding:const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), // Set text form field container color
                  borderRadius: BorderRadius.circular(10), // Add border radius
                ),
                child: TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white), // Set text color to white
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                    border: InputBorder.none, // Remove border
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), // Set text form field container color
                  borderRadius: BorderRadius.circular(10), // Add border radius
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !authProvider.isPasswordVisible,
                  style: const TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle:const TextStyle(color: Colors.white), // Set label text color to white
                    suffixIcon: IconButton(
                      icon: Icon(
                        authProvider.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white, // Set icon color to white
                      ),
                      onPressed: () {
                        authProvider.togglePasswordVisibility();
                      },
                    ),
                    border: InputBorder.none, // Remove border
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () => _login(context, authProvider),
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: authProvider.isLoading
                      ? const SizedBox(
                    width: 20,
                        height: 20,
                        child:  CircularProgressIndicator(
                                            strokeWidth: 5,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white),
                                          ),
                      )
                      : const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white, // Set text color to white
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context, AuthProvider authProvider) async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final user = await authProvider.login(username, password);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login Successful!'),
            backgroundColor: Colors.green.withOpacity(0.8),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => TaskListScreen()));
        print('Login Successful! Token: ${user.token}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
            const Text('Login Failed! Please check your credentials.'),
            backgroundColor: Colors.red.withOpacity(0.8),
            duration: const Duration(seconds: 2),
          ),
        );
        print('Login Failed!');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red.withOpacity(0.8),
          duration: const Duration(seconds: 2),
        ),
      );
      print('Error: $error');
    }
  }
}
