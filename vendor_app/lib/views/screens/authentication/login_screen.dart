import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:vendor_app/controllers/vendor_auth_controller.dart";
import "package:vendor_app/views/screens/authentication/register_screen.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VendorAuthController _vendorAuthController = VendorAuthController();
  late String email;
  late String password;
  bool isLoading = false;

  loginUser() async {
    setState(() {
      isLoading = true;
    });
    await _vendorAuthController
        .signInVendor(context: context, email: email, password: password)
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Login title Text
                Text(
                  "Login Your Account",
                  style: GoogleFonts.getFont('Lato',
                      color: const Color(0xFF0d120E),
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2),
                ),

                // Login subtitle Text
                Text(
                  "To explore the world exclusives",
                  style: GoogleFonts.getFont(
                    'Lato',
                    color: const Color(0xFF0d120E),
                    letterSpacing: 0.2,
                    fontSize: 14,
                  ),
                ),

                // Login logo image
                Image.asset(
                  "assets/images/Illustration.png",
                  width: 200,
                  height: 200,
                ),

                // Email text
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Email",
                    style: GoogleFonts.getFont('Nunito Sans',
                        fontWeight: FontWeight.bold, letterSpacing: 0.2),
                  ),
                ),

                // Email Text Form Field
                TextFormField(
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email!';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      labelText: "Enter your email",
                      labelStyle: GoogleFonts.getFont("Nunito Sans",
                          fontSize: 14, letterSpacing: 0.1),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/icons/email.png",
                          width: 20,
                          height: 20,
                        ),
                      )),
                ),

                const SizedBox(
                  height: 20,
                ),

                // Password text
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Password",
                    style: GoogleFonts.getFont('Nunito Sans',
                        fontWeight: FontWeight.bold, letterSpacing: 0.2),
                  ),
                ),

                // Password text form field
                TextFormField(
                  onChanged: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password!';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      labelText: "Enter your password",
                      labelStyle: GoogleFonts.getFont("Nunito Sans",
                          fontSize: 14, letterSpacing: 0.1),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/icons/password.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                      suffixIcon: const Icon(Icons.visibility)),
                ),

                const SizedBox(
                  height: 20,
                ),

                // Sign in Button
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      loginUser();
                    } else {}
                  },
                  child: Container(
                    width: 319,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          colors: [Color(0xFF102DE1), Color(0xCC0D6EFF)]),
                    ),
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Sign In",
                              style: GoogleFonts.getFont(
                                "Lato",
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // Sign up Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Need an account? ",
                      style: GoogleFonts.getFont(
                        "Roboto",
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (page) => const RegisterScreen()));
                      },
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.getFont(
                          "Roboto",
                          color: const Color(0xCC0D6EFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
