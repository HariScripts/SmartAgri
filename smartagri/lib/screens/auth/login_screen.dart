import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed(AppRouter.home);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error ?? AppStrings.errorGeneric)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return LoadingOverlay(
          isLoading: authProvider.isLoading,
          child: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 800;
                
                final rightSide = Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(48.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 450),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (!isDesktop) ...[
                              const Icon(Icons.eco, size: 64, color: AppColors.primary),
                              const SizedBox(height: 16),
                            ],
                            Text(
                              'Welcome back 👋',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Sign in to your SmartAgri account',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 32),
                            CustomTextField(
                              label: 'EMAIL / PHONE',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'PASSWORD',
                              controller: _passwordController,
                              isPassword: true,
                              prefixIcon: Icons.lock_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(AppStrings.forgotPassword, style: TextStyle(color: AppColors.primary)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              text: 'Login',
                              onPressed: _login,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('or', style: Theme.of(context).textTheme.bodySmall),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 24),
                            CustomButton(
                              text: 'Create New Account',
                              onPressed: () {
                                Navigator.of(context).pushNamed(AppRouter.register);
                              },
                              isOutlined: true,
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('🚀 Demo credentials filled — just click Login', style: TextStyle(color: Colors.brown, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );

                if (isDesktop) {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: const Color(0xFF2C4C3B), // Dark green theme
                          padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 48.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.eco, size: 64, color: AppColors.primary),
                              const SizedBox(height: 16),
                              const Text(
                                'SmartAgri',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'Smart Agriculture System',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 64),
                              _buildFeatureItem(Icons.waves, 'AI Soil Classification'),
                              const SizedBox(height: 24),
                              _buildFeatureItem(Icons.sensors, 'Live IoT Sensor Data'),
                              const SizedBox(height: 24),
                              _buildFeatureItem(Icons.energy_savings_leaf, 'Crop Recommendation'),
                              const SizedBox(height: 24),
                              _buildFeatureItem(Icons.science, 'Disease Detection'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: const Color(0xFFF8FAF9), // Light background for right
                          child: rightSide,
                        ),
                      ),
                    ],
                  );
                }

                // Mobile view
                return Container(
                  color: const Color(0xFFF8FAF9),
                  child: SafeArea(child: rightSide),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 28),
        const SizedBox(width: 16),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
