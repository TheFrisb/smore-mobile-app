import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/app_bars/title_app_bar.dart';
import 'package:smore_mobile_app/components/decoration/brand_logo.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';
import 'package:smore_mobile_app/service/dio_client.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _ageChecked = false;
  bool _termsChecked = false;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final provider = context.read<UserProvider>();
      final dio = DioClient().dio;

      try {
        final response = await dio.post('/auth/register/', data: {
          'username': _usernameController.text,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'confirm_password': _confirmPasswordController.text,
        });

        if (response.statusCode == 204) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        }
      } on DioException catch (e) {
        final responseData = e.response?.data;
        final errorMessage = responseData != null &&
                responseData['errors'] != null &&
                (responseData['errors'] as List).isNotEmpty
            ? responseData['errors'][0]['detail'] ?? 'Registration failed'
            : responseData?['detail'] ?? 'Registration failed';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _passwordsMatch {
    return _passwordController.text == _confirmPasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e2f42),
      appBar: const TitleAppBar(title: 'Register'),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Center(
                  child: BrandLogo(fontSize: 32),
                ),
                const SizedBox(height: 40),

                // Username
                TextFormField(
                  controller: _usernameController,
                  decoration:
                      _inputDecoration('Username', Icons.person_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username required';
                    }
                    if (value.length < 4) return 'At least 4 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // First Name
                TextFormField(
                  controller: _firstNameController,
                  decoration:
                      _inputDecoration('First Name', Icons.badge_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First name required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Last Name
                TextFormField(
                  controller: _lastNameController,
                  decoration:
                      _inputDecoration('Last Name', Icons.badge_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last name required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('Email', Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email required';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _passwordDecoration('Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password required';
                    }
                    if (value.length < 8) return 'At least 8 characters';
                    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
                      return 'Requires letters and numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: _passwordDecoration('Confirm Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm password';
                    }
                    if (!_passwordsMatch) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Age Checkbox
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('I am 18+ years old',
                      style: TextStyle(color: Colors.white70)),
                  value: _ageChecked,
                  activeColor: const Color(0xFF10648C),
                  checkColor: Colors.white,
                  onChanged: (value) =>
                      setState(() => _ageChecked = value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                // Terms Checkbox
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                      'I agree to the Terms of Service and Privacy Policy',
                      style: TextStyle(color: Colors.white70)),
                  value: _termsChecked,
                  activeColor: const Color(0xFF10648C),
                  checkColor: Colors.white,
                  onChanged: (value) =>
                      setState(() => _termsChecked = value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 20),

                // Register Button
                FilledButton(
                  onPressed: (_ageChecked && _termsChecked && !_isLoading)
                      ? _submitForm
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),

                const SizedBox(height: 20),

                FilledButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      width: 1,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color(0xFF14202D),
                  ),
                  onPressed: () {},
                  child: Stack(
                    children: [
                      // Center the text in the button
                      const Center(
                        child: Text(
                          'Sign up with Google',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Align the image to the left, vertically centered
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/google_logo.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label:
                          const Text("Login", style: TextStyle(fontSize: 16)),
                      iconAlignment: IconAlignment.end,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF15212E),
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF223548)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF223548)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF10648C)),
      ),
    );
  }

  InputDecoration _passwordDecoration(String label) {
    return _inputDecoration(label, Icons.lock_outline).copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.white70,
        ),
        onPressed: () => setState(() {
          if (label == 'Password') {
            _obscurePassword = !_obscurePassword;
          } else {
            _obscureConfirmPassword = !_obscureConfirmPassword;
          }
        }),
      ),
    );
  }
}
