import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart'; // Import your DashboardScreen
import 'staff.dart'; // Import StaffPage

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true; // Toggle between login and sign-up
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Sign in with Firebase Authentication
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Fetch user data from Firestore
      final userDoc = await _firestore.collection('user').doc(userCredential.user!.uid).get();

      if (userDoc.exists) {
        final userRole = userDoc['userRole'];
        if (userRole == 'User') {
          // Fetch the user data
          final userData = userDoc.data() as Map<String, dynamic>;

          // Navigate to the DashboardScreen on successful login with user data
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(userData: userData),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Access denied. Only users can log in.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User document does not exist.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed. Please try again.')),
      );
      print('FirebaseAuthException: ${e.message}');
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred. Please try again.')),
      );
      print('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _staffLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Sign in with Firebase Authentication
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Fetch staff data from Firestore (staff collection)
      final staffQuery = await _firestore
          .collection('staff')
          .where('Email', isEqualTo: _emailController.text.trim())
          .where('Password', isEqualTo: _passwordController.text.trim())
          .get();

      if (staffQuery.docs.isNotEmpty) {
        final staffDoc = staffQuery.docs.first;
        final staffData = staffDoc.data();

        // Navigate to the StaffPage for staff members with staff data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StaffPage(staffData: staffData),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Staff document does not exist.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed. Please try again.')),
      );
      print('FirebaseAuthException: ${e.message}');
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred. Please try again.')),
      );
      print('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E2A46),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Image.asset('img/logo.png', height: 80),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Toggle between Staff and User
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = true),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isLogin ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    'User Login',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = false),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: !isLogin ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    'Staff Login',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Display the login or sign-up form based on the isLogin state
                    isLogin ? _buildLoginForm() : _buildStaffLoginForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      key: ValueKey('UserLoginForm'),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildTextField('User Email', controller: _emailController),
          SizedBox(height: 10),
          _buildTextField('Password', obscureText: true, controller: _passwordController),
          SizedBox(height: 20),
          _isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E2A46),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: _login,
            child: Text(
              'Log in',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffLoginForm() {
    return Container(
      key: ValueKey('StaffLoginForm'),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildTextField('Staff Email', controller: _emailController),
          SizedBox(height: 10),
          _buildTextField('Password', obscureText: true, controller: _passwordController),
          SizedBox(height: 20),
          _isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E2A46),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: _staffLogin,
            child: Text(
              'Log in',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, {bool obscureText = false, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}