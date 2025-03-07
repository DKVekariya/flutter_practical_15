import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/api_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_screen_view_model.freezed.dart';


final homeViewStateNotifier =
StateNotifierProvider.autoDispose<HomeViewStateNotifier, HomeViewState>(
        (ref) {
      final notifier = HomeViewStateNotifier(
        ref.read(apiServiceProvider),
      );
      return notifier;
    });


class HomeViewStateNotifier extends StateNotifier<HomeViewState> {
  final ApiService _apiService;
  HomeViewStateNotifier(this._apiService) : super(HomeViewState()) {
    //fetchUniversities();
  }

  // Getters

  // Set selected country and fetch universities
  void setSelectedCountry(String country) {
    state = state.copyWith(selectedCountry: country);
    fetchUniversities(state.selectedCountry);
  }

  // Fetch universities from API
  Future<void> fetchUniversities(String selectedCountry) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
       final universities = await _apiService.fetchUniversitiesByCountry(selectedCountry);
      state = state.copyWith(universities: universities);
      state = state.copyWith(filteredUniversities: universities); // Default filtered
      // list = List.from(_universities); // Default filtered list
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      if (kDebugMode) {
        print('Error: $e');
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Search universities
  void searchUniversities(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredUniversities: state.universities);
    } else {
      var uni = state.universities
          .where((uni) => uni['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
      state = state.copyWith(filteredUniversities: uni);
    }
  }
}

@freezed
abstract class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
  @Default([]) List<dynamic> universities,
  @Default([]) List<dynamic> filteredUniversities,
  @Default('United States') String selectedCountry, // Default country
  @Default(false) bool isLoading,
  String? errorMessage,
  }) = _HomeViewState;
}

