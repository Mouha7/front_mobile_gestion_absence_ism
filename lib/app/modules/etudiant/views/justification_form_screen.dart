import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/justification_controller.dart';
import 'package:get/get.dart';

class JustificationFormView extends StatelessWidget {
  final JustificationController controller = Get.put(JustificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Soumettre une justification')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Description"),
                onChanged: (value) => controller.description.value = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: "ID Absence (facultatif)"),
                onChanged: (value) => controller.absenceId.value = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: "ID Admin (facultatif)"),
                onChanged: (value) => controller.adminId.value = value,
              ),
              Obx(() => Text(
                controller.selectedFile.value != null
                    ? 'Fichier : ${controller.selectedFile.value!.path.split('/').last}'
                    : 'Aucun fichier sélectionné',
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: controller.pickFromCamera,
                    child: Text("Photo"),
                  ),
                  ElevatedButton(
                    onPressed: controller.pickFromDevice,
                    child: Text("Document"),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.send),
                onPressed: controller.envoyerJustification,
                label: Text("Envoyer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
