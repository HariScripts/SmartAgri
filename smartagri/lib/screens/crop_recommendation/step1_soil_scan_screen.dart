import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_router.dart';
import '../../../widgets/custom_button.dart';

class Step1SoilScanScreen extends StatefulWidget {
  const Step1SoilScanScreen({super.key});

  @override
  State<Step1SoilScanScreen> createState() => _Step1SoilScanScreenState();
}

class _Step1SoilScanScreenState extends State<Step1SoilScanScreen> {
  File? _imageFile;
  XFile? _xFile;
  final ImagePicker _picker = ImagePicker();
  String? _selectedSoilType;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _xFile = pickedFile;
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error picking image')),
        );
      }
    }
  }



  void _analyzeSoil() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    String predictedSoil = _selectedSoilType != null ? '${_selectedSoilType!} Soil' : 'Black Soil';

    try {
      if (_imageFile != null) {
        var request = http.MultipartRequest('POST', Uri.parse('${AppStrings.apiBaseUrl}/api/predict-soil'));
        request.headers['Bypass-Tunnel-Reminder'] = 'true';
        if (kIsWeb && _xFile != null) {
           final bytes = await _xFile!.readAsBytes();
           request.files.add(http.MultipartFile.fromBytes('image', bytes, filename: _xFile!.name));
        } else if (!kIsWeb) {
           request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
        }
        var response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var data = json.decode(responseData);
          if (data['success'] == true) {
            predictedSoil = '${data['soil_type']} Soil';
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error predicting soil: $e');
      }
    }

    if (!mounted) return;
    Navigator.pop(context); // close dialog

    Navigator.of(context).pushNamed(
      AppRouter.cropRecommendationStep2, 
      arguments: predictedSoil,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.soilClassification),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            heroTag: 'homeBtnSoil',
            onPressed: () => Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.home),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.home, color: Colors.white),
            label: const Text('Home', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            heroTag: 'chatBtnSoil',
            onPressed: () => Navigator.of(context).pushNamed(AppRouter.chatbot, arguments: 'soil classification'),
            backgroundColor: AppColors.blue,
            icon: const Icon(Icons.chat, color: Colors.white),
            label: const Text('Chat', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepDot(true, 'Step 1'),
                _buildLine(),
                _buildStepDot(false, 'Step 2'),
                _buildLine(),
                _buildStepDot(false, 'Step 3'),
              ],
            ),
            const SizedBox(height: 24),
            
            Text(
              'Upload or scan a soil photo to begin',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Upload Area
            Container(
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryLight,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: _imageFile != null
                  ? GestureDetector(
                      onTap: () => _pickImage(ImageSource.gallery),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            kIsWeb ? Image.network(
                              _imageFile!.path,
                              fit: BoxFit.cover,
                            ) : Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.photo_library, color: Colors.white, size: 40),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap to change image',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.science, size: 80, color: AppColors.primary.withValues(alpha: 0.7)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                          label: const Text('Take Photo', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library, color: AppColors.primary),
                          label: const Text('Gallery', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
            ),
            
            if (_imageFile != null) ...[
              const SizedBox(height: 8),
              Text(
                _imageFile!.path.split('/').last,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],

            const SizedBox(height: 32),

            // Soil Type Reference Cards
            Text(
              'Soil Type Reference',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildReferenceCard('Alluvial', const Color(0xFFD2B48C), 'Fertile, found near rivers'),
                  _buildReferenceCard('Black', const Color(0xFF2C2C2C), 'Rich in minerals, retains moisture'),
                  _buildReferenceCard('Red', const Color(0xFF8B0000), 'Iron-rich, good for drought'),
                  _buildReferenceCard('Clay', const Color(0xFF708090), 'High water retention, dense'),
                  _buildReferenceCard('Loamy', const Color(0xFF8B4513), 'Best agricultural soil'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            CustomButton(
              text: 'Analyse Soil',
              onPressed: (_imageFile != null || _selectedSoilType != null) ? _analyzeSoil : () {},
              color: (_imageFile != null || _selectedSoilType != null) ? AppColors.primary : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepDot(bool isActive, String label) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : Colors.grey.shade300,
          ),
          child: isActive 
              ? const Icon(Icons.check, size: 16, color: Colors.white) 
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? AppColors.primary : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildLine() {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20), // offset for the label
      color: Colors.grey.shade300,
    );
  }

  Widget _buildReferenceCard(String name, Color color, String desc) {
    final isSelected = _selectedSoilType == name;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSoilType = name;
        });
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
          elevation: isSelected ? 4 : 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 30,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primary : Colors.black,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 10),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
