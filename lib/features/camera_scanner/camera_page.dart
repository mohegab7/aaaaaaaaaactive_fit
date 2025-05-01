import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Camera_Page extends StatefulWidget {
  const Camera_Page({super.key});

  @override
  State<Camera_Page> createState() => _FoodRecognitionScreenState();
}

class _FoodRecognitionScreenState extends State<Camera_Page> {
  File? _image;
  String? _foodName;
  Map<String, dynamic>? _nutritionInfo;
  bool _isLoading = false;
  String _errorMessage = '';

  final ImagePicker _picker = ImagePicker();
  final String clarifaiApiKey = "44d2af4b2fd948c0b9f8d229360bd45d";
  final String edamamAppId = "67d045a0";
  final String edamamAppKey = "bc7f8881c24b194298de52ca0668165b";

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _foodName = null;
          _nutritionInfo = null;
          _isLoading = true;
          _errorMessage = '';
        });

        await _recognizeFood(_image!);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'An error occurred while selecting the image:${e.toString()}';
      });
    }
  }

  Future<void> _recognizeFood(File image) async {
    try {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(
          "https://api.clarifai.com/v2/users/clarifai/apps/main/models/food-item-recognition/versions/1d5fd481e0cf4826aa72ec3ff049e044/outputs",
        ),
        headers: {
          "Authorization": "Key $clarifaiApiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "inputs": [
            {
              "data": {
                "image": {"base64": base64Image},
              },
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final concepts = data["outputs"][0]["data"]["concepts"];

        if (concepts != null && concepts.isNotEmpty) {
          final foodName = concepts[0]["name"];
          setState(() {
            _foodName = foodName;
          });
          await _getNutritionInfo(foodName);
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'No food detected in the image';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error in food recognition: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'An error occurred while recognizing the food: ${e.toString()}';
      });
    }
  }

  Future<void> _getNutritionInfo(String foodName) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://api.edamam.com/api/food-database/v2/parser?ingr=${Uri.encodeComponent(foodName)}&app_id=$edamamAppId&app_key=$edamamAppKey",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["hints"] != null && data["hints"].isNotEmpty) {
          // Take the first result
          final firstResult = data["hints"][0];
          final food = firstResult["food"];

          // Extract nutrition information
          final nutrients = food["nutrients"];

          setState(() {
            _nutritionInfo = {
              "calories": nutrients["ENERC_KCAL"]?.round() ?? 0,
              "fat": nutrients["FAT"]?.round() ?? 0,
              "carbs": nutrients["CHOCDF"]?.round() ?? 0,
              "protein": nutrients["PROCNT"]?.round() ?? 0,
            };
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'No information available for$foodName';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Error retrieving nutrition information: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'An error occurred while fetching the nutrition information:${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_image != null)
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.file(_image!, fit: BoxFit.cover),
              )
            else
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.fastfood, size: 80, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Analyzing the image..."),
                ],
              ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_foodName != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Recognized: $_foodName",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            if (_nutritionInfo != null) ...[
              const SizedBox(height: 20),
              const Text(
                "Nutrition facts:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildNutritionCard(),
            ],
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("The camera"),
                  onPressed: () => _pickImage(ImageSource.camera),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: const Text("The gallery"),
                  onPressed: () => _pickImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNutritionRow(
              "Calories",
              "${_nutritionInfo!["calories"]} kcal",
            ),
            const Divider(),
            _buildNutritionRow("Fats", "${_nutritionInfo!["fat"]} g"),
            const Divider(),
            _buildNutritionRow(
                "Carbohydrates", "${_nutritionInfo!["carbs"]} g"),
            const Divider(),
            _buildNutritionRow("Protein", "${_nutritionInfo!["protein"]} g"),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
