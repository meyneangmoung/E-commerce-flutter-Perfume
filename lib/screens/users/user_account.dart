import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../home/homepage.dart'; 

class UserAccountScreen extends StatefulWidget {
  final User user; // Current user passed from HomeScreen
  final Function(User updatedUser) onUserUpdated; // Callback when user updates

  const UserAccountScreen({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  late String name;
  late String email;
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    name = widget.user.name;
    email = "example@email.com"; // Optionally, extend User model to include email
  }

  // Pick profile image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      // Update user object and notify HomeScreen
      widget.user.profileImage = pickedFile.path;
      widget.onUserUpdated(widget.user);
    }
  }

  // Edit profile name
  void _editProfile() {
    TextEditingController nameController = TextEditingController(text: name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  widget.user.name = name; // update the User object
                });

                widget.onUserUpdated(widget.user); // notify HomeScreen
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out successfully")),
    );
  }

  void _goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("My Account"),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Profile section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (widget.user.profileImage.startsWith('assets/')
                            ? AssetImage(widget.user.profileImage)
                                as ImageProvider
                            : FileImage(File(widget.user.profileImage))),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: _editProfile,
                      child: const Text("Edit Profile"),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: const [
                AccountMenuItem(icon: Icons.favorite_border, title: "Wishlist"),
                AccountMenuItem(icon: Icons.settings_outlined, title: "Settings"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C2C2C),
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AccountMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const AccountMenuItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}