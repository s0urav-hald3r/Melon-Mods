import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:mod_game/common/controllers/network_controller.dart';
import 'package:mod_game/common/models/mod.dart';
import 'package:mod_game/common/widgets/snackbar.dart';
import 'package:mod_game/data/repositorys/home_repo.dart';
import 'package:mod_game/utils/constants/enums.dart';
import 'package:mod_game/utils/constants/storage_constants.dart';
import 'package:mod_game/utils/local_storage/local_storage.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  @override
  void onReady() {
    super.onReady();
    _retrieveFavMods();
  }

  // Function to retrieve favorite mods from local storage
  Future<void> _retrieveFavMods() async {
    final String storeData =
        XLocalStorage.getData(XStorageConstant.favMods, KeyType.STR);
    if (storeData.isNotEmpty) {
      // Split the storeData string by commas to get individual JSON strings
      final List<String> jsonStrings = storeData.split('|');

      // Create a list to store decoded Mod objects
      List<Mod> decodedMods = [];

      // Decode each JSON string and add the corresponding Mod object to the list
      for (String jsonString in jsonStrings) {
        Mod mod = Mod.fromJson(json.decode(jsonString));
        decodedMods.add(mod);
      }

      // Update favMods with the decoded Mod objects
      favMods = decodedMods;
    }
  }

  //  ---------------------------------* Variable Start *------------------------------

  final RxList<Mod> _mostTrendingMods = <Mod>[].obs;
  final RxList<Mod> _categoryMods = <Mod>[].obs;
  final RxList<Mod> _recommendedMods = <Mod>[].obs;

  final RxList<Mod> _favMods = <Mod>[].obs;

  final RxBool _isTrendingLoading = false.obs;
  final RxBool _isCategoryLoading = false.obs;
  final RxBool _isRecommendedLoading = false.obs;

  final Rx<ModType> _selectedModType = ModType.SLASHING.obs;

  //  ---------------------------------* Variable End *--------------------------------

  //  ---------------------------------------------------------------------------------

  //  ---------------------------------* Getter Start *--------------------------------

  List<Mod> get mostTrendingMods => _mostTrendingMods;
  List<Mod> get categoryMods => _categoryMods;
  List<Mod> get recommendedMods => _recommendedMods;

  List<Mod> get favMods => _favMods;

  bool get isTrendingLoading => _isTrendingLoading.value;
  bool get isCategoryLoading => _isCategoryLoading.value;
  bool get isRecommendedLoading => _isRecommendedLoading.value;

  ModType get selectedModType => _selectedModType.value;

  //  ---------------------------------* Getter End *----------------------------------

  //  ---------------------------------------------------------------------------------

  //  ---------------------------------* Setter Start *--------------------------------

  set mostTrendingMods(mods) => _mostTrendingMods.value = mods;
  set categoryMods(mods) => _categoryMods.value = mods;
  set recommendedMods(mods) => _recommendedMods.value = mods;

  set favMods(mods) => _favMods.value = mods;

  set isTrendingLoading(loading) => _isTrendingLoading.value = loading;
  set isCategoryLoading(loading) => _isCategoryLoading.value = loading;
  set isRecommendedLoading(loading) => _isRecommendedLoading.value = loading;

  set selectedModType(modType) => _selectedModType.value = modType;

  //  ---------------------------------* Setter End *----------------------------------

  //  ---------------------------------------------------------------------------------

  //  ---------------------------------* Function Start *------------------------------

  // Function to update favorite mods in local storage
  Future<void> _updateFavMods() async {
    // Encode each Mod object to JSON string
    List<String> jsonModStrings =
        favMods.map((mod) => json.encode(mod.toJson())).toList();

    // Join JSON strings with comma to form a single string
    String joinedJson = jsonModStrings.join('|');

    // Save the joined JSON string to local storage
    await XLocalStorage.addData(XStorageConstant.favMods, joinedJson);
  }

  // Function to toggle a mod as favorite
  void toggleFavorite(Mod mod) {
    int index = favMods.indexWhere((e) => e.id == mod.id);
    if (index != -1) {
      favMods.removeWhere((e) => e.id == mod.id);
    } else {
      favMods.add(mod);
    }
    _updateFavMods();
  }

  // Fetch most trending mods
  Future<void> getMostTrendingMods() async {
    // Start Loader
    isTrendingLoading = true;

    // Check internet connection
    final isConnected = await NetworkController.instance.isConnected();
    if (!isConnected) {
      isTrendingLoading = false;
      XSnackBar.show('Error', 'No internet available', 2);
      return;
    }

    // API call
    mostTrendingMods = await HomeRepo.instance
        .getMods(FormData.fromMap({'category': ModType.TRENDING.title}));

    // Stop Loader
    isTrendingLoading = false;
  }

  // Fetch recommended mods
  Future<void> getRecommendedMods() async {
    // Start Loader
    isRecommendedLoading = true;

    // Check internet connection
    final isConnected = await NetworkController.instance.isConnected();
    if (!isConnected) {
      isRecommendedLoading = false;
      XSnackBar.show('Error', 'No internet available', 2);
      return;
    }

    // API call
    recommendedMods = await HomeRepo.instance
        .getMods(FormData.fromMap({'category': ModType.RECOMMENDED.title}));

    // Stop Loader
    isRecommendedLoading = false;
  }

  // Fetch category wise mods
  Future<void> getCategoryMods(ModType modType) async {
    // Start Loader
    isCategoryLoading = true;

    // Check internet connection
    final isConnected = await NetworkController.instance.isConnected();
    if (!isConnected) {
      isCategoryLoading = false;
      XSnackBar.show('Error', 'No internet available', 2);
      return;
    }

    // API call
    categoryMods = await HomeRepo.instance
        .getMods(FormData.fromMap({'category': modType.title}));

    // Stop Loader
    isCategoryLoading = false;
  }

  //  ---------------------------------* Function End *--------------------------------
}
