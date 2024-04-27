import 'package:auto_route/auto_route.dart';
import 'package:capynotes/constants/asset_paths.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/custom_widgets/custom_drawer.dart';
import '../widgets/folder_widget.dart';
import '../widgets/note_widget.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: ColorConstants.primaryColor,
        centerTitle: true,
      ),
      endDrawer: CustomDrawer(),
      body: Center(
        child: Row(
          children: [],
        ),
      ),
    );
  }
}
