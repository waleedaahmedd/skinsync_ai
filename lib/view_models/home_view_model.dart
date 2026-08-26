import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/enums.dart';
import 'base_view_model.dart';

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(() {
  return HomeViewModel();
});

class HomeState {
  final List<HomeSection> sections;
  final bool isReorderMode;

  HomeState({required this.sections, this.isReorderMode = false});

  HomeState copyWith({List<HomeSection>? sections, bool? isReorderMode}) {
    return HomeState(
      sections: sections ?? this.sections,
      isReorderMode: isReorderMode ?? this.isReorderMode,
    );
  }
}

class HomeViewModel extends BaseViewModel<HomeState> {
  HomeViewModel() : super(initialState: HomeState(sections: HomeSection.values));

  static const String _storageKey = "home-sections-order";

  @override
  void init() {
    super.init();
    _loadOrder();
  }

  void toggleReorderMode() {
    state = state.copyWith(isReorderMode: !state.isReorderMode);
  }

  Future<void> _loadOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedOrder = prefs.getStringList(_storageKey);

    if (savedOrder != null) {
      final List<HomeSection> loadedSections = [];
      for (String sectionName in savedOrder) {
        try {
          loadedSections.add(HomeSection.values.firstWhere(
            (e) => e.name == sectionName,
          ));
        } catch (_) {}
      }
      
      for (var section in HomeSection.values) {
        if (!loadedSections.contains(section)) {
          loadedSections.add(section);
        }
      }
      
      state = state.copyWith(sections: loadedSections);
    }
  }

  Future<void> reorderSections(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final List<HomeSection> newList = List.from(state.sections);
    final HomeSection item = newList.removeAt(oldIndex);
    newList.insert(newIndex, item);
    state = state.copyWith(sections: newList);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, state.sections.map((e) => e.name).toList());
  }
}
