import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../router/app_routes.dart';
import 'auth_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AuthController controller = Get.find<AuthController>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final user = userController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();
    if (user.isEmpty || password.isEmpty || confirm.isEmpty) {
      Get.snackbar('提示', '请完整填写注册信息');
      return;
    }
    if (password != confirm) {
      Get.snackbar('提示', '两次密码输入不一致');
      return;
    }
    await controller.register(user: user, password: password);
    Get.snackbar('提示', '注册成功，请登录');
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0F1217),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -140,
              right: -80,
              child: _GlowCircle(
                size: 300,
                color: const Color(0xFFB08D32).withOpacity(0.2),
              ),
            ),
            Positioned(
              bottom: -160,
              left: -60,
              child: _GlowCircle(
                size: 320,
                color: const Color(0xFF1E6A5A).withOpacity(0.2),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    '创建账号',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFFD6B25E),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '开启你的商务对局',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 36),
                  _GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '账号注册',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _InputField(
                          controller: userController,
                          label: '账号',
                          hintText: '设置账号',
                        ),
                        const SizedBox(height: 16),
                        _InputField(
                          controller: passwordController,
                          label: '密码',
                          hintText: '设置密码',
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        _InputField(
                          controller: confirmController,
                          label: '确认密码',
                          hintText: '再次输入密码',
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        Obx(() => FilledButton(
                              onPressed: controller.isSubmitting.value
                                  ? null
                                  : _submit,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFB08D32),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: controller.isSubmitting.value
                                  ? const Text('注册中...')
                                  : const Text('完成注册'),
                            )),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Get.offAllNamed(AppRoutes.login),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white70,
                          ),
                          child: const Text('已有账号？返回登录'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '注册即代表你已了解并同意平台规则',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF161A20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool obscureText;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: const Color(0xFF101318),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 120,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }
}
