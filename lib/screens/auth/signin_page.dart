import 'package:flutter/material.dart';
import 'package:ecommerce/service/auth_service.dart';
import 'package:ecommerce/screens/auth/signup_page.dart';
import 'package:ecommerce/screens/home/homepage.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    ),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  // Helper to build Social Buttons
  Widget _socialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }

  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage("Please fill in all fields");
      return;
    }

    try {
      final success = await _authService.login(email, password);
      if (success != null) {
        // Navigate to HomePage on successful login
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        showMessage("Invalid email or password");
      }
    } catch (e) {
      showMessage("Login failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Center(
                  child: Icon(Icons.shopping_bag_outlined,
                      size: 80, color: Colors.blueAccent),
                ),
                const SizedBox(height: 30),
                const Text("Welcome Back",
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const Text("Sign in to continue your shopping",
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 30),

                // Email & Password Fields
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Forgot Password?"),
                  ),
                ),
                const SizedBox(height: 10),

                // Main Login Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Login",
                        style:
                            TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),

                const SizedBox(height: 30),

                // --- SOCIAL LOGIN SECTION START ---
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Or connect with",
                          style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(
                      icon: Icons.g_mobiledata_rounded,
                      color: Colors.red,
                      onTap: () => print("Google Login"),
                    ),
                    const SizedBox(width: 20),
                    _socialButton(
                      icon: Icons.apple,
                      color: Colors.black,
                      onTap: () => print("Apple Login"),
                    ),
                    const SizedBox(width: 20),
                    _socialButton(
                      icon: Icons.facebook,
                      color: Colors.blue.shade800,
                      onTap: () => print("Facebook Login"),
                    ),
                  ],
                ),
                // --- SOCIAL LOGIN SECTION END ---

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignupPage())),
                      child: const Text("Signup",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}