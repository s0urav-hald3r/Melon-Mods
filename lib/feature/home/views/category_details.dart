import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mod_game/common/models/mod.dart';
import 'package:mod_game/common/widgets/custom_appbar_back.dart';
import 'package:mod_game/common/widgets/no_data.dart';
import 'package:mod_game/utils/constants/sizes.dart';

import '../../../common/widgets/loader.dart';
import '../../../common/widgets/trending_card.dart';
import '../controllers/home_controller.dart';

class CategoryDetailsView extends StatefulWidget {
  const CategoryDetailsView({super.key});

  @override
  State<CategoryDetailsView> createState() => _CategoryDetailsViewState();
}

class _CategoryDetailsViewState extends State<CategoryDetailsView> {
  late HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _homeController = HomeController.instance;
    _homeController.getCategoryMods();
  }

  @override
  void dispose() {
    super.dispose();
    _homeController.categoryMods = <Mod>[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarBack(
          title: _homeController.selectedModType.toUpperCase()),
      body: Obx(
        () => _homeController.isPostCategoryLoading
            ? const LoadingWidget()
            : _homeController.categoryMods.isEmpty
                ? const NoData()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        if (_homeController.categoryMods.isNotEmpty) ...[
                          Gap(XSize.spaceBtwSections.h),
                          Column(
                            children: _homeController.categoryMods
                                .map((e) => TrendingCard(mod: e))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
      ),
    );
  }
}
