import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:active_fit/core/domain/entity/intake_type_entity.dart';
import 'package:active_fit/core/utils/navigation_options.dart';
import 'package:active_fit/features/add_meal/domain/entity/meal_entity.dart';
import 'package:active_fit/features/add_meal/domain/entity/meal_nutriments_entity.dart';
import 'package:active_fit/features/meal_detail/meal_detail_screen.dart';
import 'package:active_fit/features/add_meal/presentation/add_meal_type.dart';
import 'package:active_fit/generated/l10n.dart';

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
  DateTime _selectedDate = DateTime.now(); // إضافة تاريخ اليوم

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
          final firstResult = data["hints"][0];
          final food = firstResult["food"];
          final nutrients = food["nutrients"];

          setState(() {
            _nutritionInfo = {
              "energyKcal100": nutrients["ENERC_KCAL"]?.round() ?? 0,
              "carbohydrates100": nutrients["CHOCDF"]?.round() ?? 0,
              "fat100": nutrients["FAT"]?.round() ?? 0,
              "proteins100": nutrients["PROCNT"]?.round() ?? 0,
              "sugars100": nutrients["SUGAR"]?.round() ?? 0,
              "saturatedFat100": nutrients["FASAT"]?.round() ?? 0,
              "fiber100": nutrients["FIBTG"]?.round() ?? 0,
            };
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'No information available for $foodName';
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
            'An error occurred while fetching the nutrition information: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface.withOpacity(0.9),
        title: Text(
          'Food Scanner',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_image != null)
              Container(
                height: 300,
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: colorScheme.shadow.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2)
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(_image!, fit: BoxFit.cover),
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_enhance,
                      size: 80,
                      color: colorScheme.primary.withOpacity(0.7),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Scan Your Food',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Take a photo of your food or choose from gallery to get nutritional information instantly',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer
                                    .withOpacity(0.7),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: IconButton(
                                onPressed: () => _pickImage(ImageSource.camera),
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: colorScheme.onSecondaryContainer,
                                  size: 32,
                                ),
                              ),
                            ),
                            Text(
                              'Camera',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: colorScheme.onSurface),
                            ),
                          ],
                        ),
                        const SizedBox(width: 40),
                        Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: colorScheme.tertiaryContainer
                                    .withOpacity(0.7),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: IconButton(
                                onPressed: () =>
                                    _pickImage(ImageSource.gallery),
                                icon: Icon(
                                  Icons.photo_library,
                                  color: colorScheme.onTertiaryContainer,
                                  size: 32,
                                ),
                              ),
                            ),
                            Text(
                              'Gallery',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: colorScheme.onSurface),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Analyzing image...',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: colorScheme.onSurface),
                    )
                  ],
                ),
              ),
            if (_errorMessage.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: colorScheme.errorContainer.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: colorScheme.error.withOpacity(0.3))),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: colorScheme.error),
                      ),
                    )
                  ],
                ),
              ),
            if (_foodName != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: colorScheme.primary.withOpacity(0.2))),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recognized Food:',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: colorScheme.primary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _foodName!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (_nutritionInfo != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Card(
                  elevation: 4,
                  shadowColor: colorScheme.shadow.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Nutrition Facts',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildNutritionRow(
                          "Calories",
                          "${_nutritionInfo!["energyKcal100"]} kcal",
                          colorScheme,
                        ),
                        const Divider(),
                        _buildNutritionRow(
                          "Fats",
                          "${_nutritionInfo!["fat100"]} g",
                          colorScheme,
                        ),
                        const Divider(),
                        _buildNutritionRow(
                          "Carbohydrates",
                          "${_nutritionInfo!["carbohydrates100"]} g",
                          colorScheme,
                        ),
                        const Divider(),
                        _buildNutritionRow(
                          "Proteins",
                          "${_nutritionInfo!["proteins100"]} g",
                          colorScheme,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: _nutritionInfo != null
                      ? () => _addFoodToDiary(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2),
                  icon: const Icon(Icons.add),
                  label: Text(
                    "Add to Diary",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            if (_image != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.secondaryContainer,
                          foregroundColor: colorScheme.onSecondaryContainer,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Camera"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.tertiaryContainer,
                          foregroundColor: colorScheme.onTertiaryContainer,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.photo_library),
                        label: const Text("Gallery"),
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

  Widget _buildNutritionRow(
      String label, String value, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _addFoodToDiary(BuildContext context) {
    if (_foodName != null && _nutritionInfo != null) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  S.of(context).addItemLabel,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              ListTile(
                title: Text(
                  S.of(context).breakfastLabel,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                subtitle: Text(
                  S.of(context).breakfastExample,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),
                leading: SizedBox(
                  height: double.infinity,
                  child: Icon(IntakeTypeEntity.breakfast.getIconData()),
                ),
                onTap: () =>
                    _navigateToMealDetail(context, AddMealType.breakfastType),
              ),
              ListTile(
                title: Text(
                  S.of(context).lunchLabel,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                subtitle: Text(
                  S.of(context).lunchExample,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),
                leading: SizedBox(
                  height: double.infinity,
                  child: Icon(IntakeTypeEntity.lunch.getIconData()),
                ),
                onTap: () =>
                    _navigateToMealDetail(context, AddMealType.lunchType),
              ),
              ListTile(
                title: Text(
                  S.of(context).dinnerLabel,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                subtitle: Text(
                  S.of(context).dinnerExample,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),
                leading: SizedBox(
                  height: double.infinity,
                  child: Icon(IntakeTypeEntity.dinner.getIconData()),
                ),
                onTap: () =>
                    _navigateToMealDetail(context, AddMealType.dinnerType),
              ),
              ListTile(
                title: Text(
                  S.of(context).snackLabel,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                subtitle: Text(
                  S.of(context).snackExample,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),
                leading: SizedBox(
                  height: double.infinity,
                  child: Icon(IntakeTypeEntity.snack.getIconData()),
                ),
                onTap: () =>
                    _navigateToMealDetail(context, AddMealType.snackType),
              ),
            ],
          );
        },
      );
    }
  }

  void _navigateToMealDetail(BuildContext context, AddMealType mealType) {
    final mealEntity = MealEntity(
      code: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _foodName,
      url: null,
      mealQuantity: "100",
      mealUnit: "g",
      servingQuantity: 100,
      servingUnit: "g",
      servingSize: "100g",
      nutriments: MealNutrimentsEntity(
        energyKcal100: _nutritionInfo?["energyKcal100"]?.toDouble(),
        carbohydrates100: _nutritionInfo?["carbohydrates100"]?.toDouble(),
        fat100: _nutritionInfo?["fat100"]?.toDouble(),
        proteins100: _nutritionInfo?["proteins100"]?.toDouble(),
        sugars100: _nutritionInfo?["sugars100"]?.toDouble(),
        saturatedFat100: _nutritionInfo?["saturatedFat100"]?.toDouble(),
        fiber100: _nutritionInfo?["fiber100"]?.toDouble(),
      ),
      source: MealSourceEntity.custom,
    );

    Navigator.of(context).pop(); // Close bottom sheet
    Navigator.pushNamed(
      context,
      NavigationOptions.mealDetailRoute,
      arguments: MealDetailScreenArguments(
        mealEntity,
        mealType.getIntakeType(),
        _selectedDate,
        false,
      ),
    );
  }
}
