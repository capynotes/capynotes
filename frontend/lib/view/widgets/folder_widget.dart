import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../constants/asset_paths.dart';

class FolderWidget extends StatelessWidget {
  const FolderWidget({super.key, required this.folderItemModel});
  final folderItemModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.replaceNamed("/folder/${folderItemModel["folderID"]}");
      },
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(AssetPaths.folderImage))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Folder Name"),
                Text("5 notes"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
