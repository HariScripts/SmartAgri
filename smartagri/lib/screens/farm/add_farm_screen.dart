import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/farm_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/crop_provider.dart';

class AddFarmScreen extends StatefulWidget {
  const AddFarmScreen({super.key});

  @override
  State<AddFarmScreen> createState() => _AddFarmScreenState();
}

class _AddFarmScreenState extends State<AddFarmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _addFarm() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final farmProvider = Provider.of<FarmProvider>(context, listen: false);
      
      final success = await farmProvider.addFarm(
        _nameController.text.trim(),
        _locationController.text.trim(),
        authProvider.user!.uid,
      );

      if (success && mounted) {
        final activeFarm = farmProvider.activeFarm;
        if (activeFarm != null) {
          Provider.of<CropProvider>(context, listen: false).loadActiveCrop(activeFarm.id);
        }
        Navigator.pop(context); // Go back to Home
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addFarm),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.agriculture, size: 64, color: Colors.grey),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: AppStrings.farmName,
                    controller: _nameController,
                    prefixIcon: Icons.edit,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a farm name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: AppStrings.farmLocation,
                    controller: _locationController,
                    prefixIcon: Icons.location_on,
                    hint: 'e.g., Pune, Maharashtra',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  Consumer<FarmProvider>(
                    builder: (context, farmProvider, child) {
                      return CustomButton(
                        text: AppStrings.addFarm,
                        isLoading: farmProvider.isLoading,
                        onPressed: _addFarm,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
