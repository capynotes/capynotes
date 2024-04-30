import 'package:capynotes/model/folder/folder_with_count_model.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../constants/asset_paths.dart';

class FolderWidget extends StatelessWidget {
  const FolderWidget({super.key, required this.folderWithCount});
  final FolderWithCountModel folderWithCount;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.replaceNamed("/folder/${folderWithCount.id}");
      },
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(AssetPaths.folderImage))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(folderWithCount.title ?? "No Title"),
                Text("${folderWithCount.noteCount} notes"),
                Text("${folderWithCount.folderCount} folders"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
