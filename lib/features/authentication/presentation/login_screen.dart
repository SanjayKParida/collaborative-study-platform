import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:study_mesh/features/authentication/presentation/registration_screen.dart';
import 'package:study_mesh/services/auth_service.dart';
import 'package:study_mesh/shared/widgets/bottom_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool isHidden = true;
  bool isLoading = false;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please enter both email and password.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final userCredential = await _authService.signIn(email, password);
      if (userCredential != null) {
        // Login successful
        _navigateToHome();
      } else {
        // Login failed
        _showErrorDialog('Login failed. Please check your credentials.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
              //LOGIN
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: SvgPicture.asset(
                  'assets/images/login.svg',
                  width: w * 0.7,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 18, top: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome !',
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
                      'Enter your details to login...',
                      style: GoogleFonts.ubuntuCondensed(
                          fontSize: 20.0, color: Colors.white),
                    ),
                  ],
                ),
              ),

              //REGISTRATION
              Padding(
                  padding:
                      const EdgeInsets.only(right: 10.0, left: 18, top: 10),
                  child: Row(
                    children: [
                      Text(
                        'Or',
                        style:
                            GoogleFonts.lato(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(
                        width: w * 0.008,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationScreen()));
                          },
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.lato(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ))
                    ],
                  )),
              SizedBox(
                height: h * 0.04,
              ),

              //TEXTFIELDS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.blue)),
                          hintText: "Email address"),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    TextFormField(
                      controller: passwordController,
                      style: const TextStyle(color: Colors.white),
                      obscureText: isHidden,
                      decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: _changeIsHidden,
                            child: isHidden
                                ? const Icon(IconlyBold.hide)
                                : const Icon(IconlyBold.show),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.blue)),
                          hintText: "Password"),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),

                    //LOGIN BUTTON
                    InkWell(
                      onTap: isLoading ? null : _login,
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
                                  "Login",
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
                      'Or continue with',
                      style: GoogleFonts.lato(color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.2),
                                    offset: const Offset(0.0, 2.0),
                                    blurRadius: 4.0,
                                  )
                                ]),
                            height: h * 0.12,
                            width: w * 0.12,
                            child: Image.asset(
                              'assets/icons/google.png',
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _changeIsHidden() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const BottomNavigation()),
      (Route<dynamic> route) => false,
    );
  }
}
