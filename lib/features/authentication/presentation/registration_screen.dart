import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:study_mesh/services/auth_service.dart';
import 'package:study_mesh/shared/widgets/bottom_navigation.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isHidden = true;
  bool isConfirmHidden = true;
  bool isLoading = false;

  Future<void> _register() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog('Please fill in all fields.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      _showErrorDialog('Passwords do not match.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final userCredential = await _authService.signUp(email, password);
      if (userCredential != null) {
        _navigateToHome();
      } else {
        _showErrorDialog('Registration failed. Please try again.');
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog('Registration failed: ${e.message}');
    } catch (e) {
      _showErrorDialog('An error occurred: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const BottomNavigation()),
      (Route<dynamic> route) => false,
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: SvgPicture.asset(
                  'assets/images/signup.svg',
                  width: w * 0.7,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 18, top: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: GoogleFonts.ubuntuCondensed(
                        fontSize: 32.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 18, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please fill in the form to continue',
                      style: GoogleFonts.ubuntuCondensed(
                          fontSize: 20.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        hintText: "Email address",
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    TextFormField(
                      controller: passwordController,
                      style: const TextStyle(color: Colors.white),
                      obscureText: isHidden,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () => setState(() => isHidden = !isHidden),
                          child: Icon(
                              isHidden ? IconlyBold.hide : IconlyBold.show),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        hintText: "Password",
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    TextFormField(
                      controller: confirmPasswordController,
                      style: const TextStyle(color: Colors.white),
                      obscureText: isConfirmHidden,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () => setState(
                              () => isConfirmHidden = !isConfirmHidden),
                          child: Icon(isConfirmHidden
                              ? IconlyBold.hide
                              : IconlyBold.show),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        hintText: "Confirm Password",
                      ),
                    ),
                    SizedBox(height: h * 0.03),
                    InkWell(
                      onTap: isLoading ? null : _register,
                      child: Container(
                        height: h * 0.06,
                        width: w * 0.3,
                        decoration: BoxDecoration(
                          color: isLoading ? Colors.grey : Colors.blue,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "REGISTER",
                                  style: GoogleFonts.ubuntu(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.025),
                    Text(
                      'Already have an account?',
                      style: GoogleFonts.lato(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: GoogleFonts.lato(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
