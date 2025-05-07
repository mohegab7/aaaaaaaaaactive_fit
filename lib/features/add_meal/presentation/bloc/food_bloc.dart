import 'package:active_fit/core/domain/usecase/get_config_usecase.dart';
import 'package:active_fit/features/add_meal/domain/entity/meal_entity.dart';
import 'package:active_fit/features/add_meal/domain/usecase/search_products_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

part 'food_event.dart';

part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final log = Logger('FoodBloc');

  final SearchProductsUseCase _searchProductUseCase;
  final GetConfigUsecase _getConfigUsecase;

  String _searchString = "";

  FoodBloc(this._searchProductUseCase, this._getConfigUsecase)
      : super(FoodInitial()) {
    on<LoadFoodEvent>((event, emit) async {
      _searchString = event.searchString;

      if (_searchString.isEmpty) {
        // Do not load food list if search string is empty
        emit(FoodInitial());
        return;
      }

      emit(FoodLoadingState());

      try {
        final result =
            await _searchProductUseCase.searchFoodByString(_searchString);
        if (result.isEmpty) {
          log.warning("No food items found for search: $_searchString");
        }
        final config = await _getConfigUsecase.getConfig();
        emit(FoodLoadedState(
            food: result, usesImperialUnits: config.usesImperialUnits));
      } catch (error) {
        log.severe("Error loading food: $error");
        emit(FoodFailedState());
      }
    });

    on<RefreshFoodEvent>((event, emit) async {
      emit(FoodLoadingState());
      try {
        final result =
            await _searchProductUseCase.searchFoodByString(_searchString);
        emit(FoodLoadedState(food: result));
      } catch (error) {
        log.severe(error);
        emit(FoodFailedState());
      }
    });
  }
}
