import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggingOut = false;
  bool _isLoading = false;

  Future<void> _updateUserName(String newName) async {
    setState(() {
      _isLoading = true;
    });

    final supabase = Supabase.instance.client;
    final response = await supabase.auth.updateUser(UserAttributes(
      data: {'name': newName},
    ));

    if (response.user != null) {
      print(
          "Name updated successfully: ${response.user!.userMetadata?['name']}");
    } else {
      print("Failed to update name");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      print('Error signing out: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final $user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: const Color(0xFF2C8C7B),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: const Color(0xFF2C8C7B),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: _isLoading
                          ? const SizedBox(
                              width: double.infinity,
                              height: 160,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2.0),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/me.jpg',
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 48),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        $user!.userMetadata?['name'] ??
                                            'John Doe',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              String tempName = '';
                                              return AlertDialog(
                                                title: const Text('Edit Name'),
                                                content: TextField(
                                                  onChanged: (value) =>
                                                      tempName = value,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Enter new name"),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      _updateUserName(tempName);

                                                      Future.delayed(
                                                          Duration(
                                                              milliseconds:
                                                                  1000), () {
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                      });
                                                    },
                                                    child: Text('Save'),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.edit,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  $user.email!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoggingOut = true;
                          });
                          Future.delayed(
                            Duration(milliseconds: 1000),
                            () {
                              _handleLogout(context);
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoggingOut
                            ? CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              )
                            : Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
