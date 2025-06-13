import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool _isObscured =
      true.obs; // Variable réactive pour l'état de visibilité du mot de passe

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: AppTheme.primaryColor, // Marron foncé
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_ism.png', height: 300),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              // Champ de mot de passe avec bouton de visibilité
              Obx(
                () => TextField(
                  controller: passwordController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    // Ajout d'une icône de bascule pour la visibilité du mot de passe
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _isObscured.toggle(); // Bascule entre visible et masqué
                      },
                    ),
                  ),
                  obscureText: _isObscured.value, // Utilise la valeur réactive
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () =>
                    controller.errorMessage.value.isNotEmpty
                        ? Text(
                          controller.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                        )
                        : const SizedBox(),
              ),
              const SizedBox(height: 20),

              // Bouton de connexion
              Obx(
                () => SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : () => controller.login(
                              emailController.text,
                              passwordController.text,
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF422613), // Marron foncé
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child:
                        controller.isLoading.value
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Se connecter',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
