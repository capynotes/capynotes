import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:star_menu/star_menu.dart';

import '../../constants/colors.dart';
import '../widgets/custom_widgets/custom_drawer.dart';

@RoutePage()
class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Folder Name"),
        backgroundColor: ColorConstants.primaryColor,
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: Center(),
      floatingActionButton: StarMenu(
        onItemTapped: (index, controller) {
          if (index != 1) controller.closeMenu!();
        },
        params: const StarMenuParameters(
          shape: MenuShape.linear,
          linearShapeParams: LinearShapeParams(
              angle: 270, space: 10, alignment: LinearAlignment.center),
        ),
        items: [
          FloatingActionButton.extended(
              onPressed: () {}, label: const Text("Add Note")),
          FloatingActionButton.extended(
            onPressed: () {},
            label: const Text("Add Folder"),
          ),
          const SizedBox(height: 70),
        ],
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
