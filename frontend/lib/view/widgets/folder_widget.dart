import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';

class FolderWidget extends StatelessWidget {
  const FolderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AssetPaths.folderImage))),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Text("Folder Name"),
            Text("5 notes"),
          ],
        ),
      ),
    );
  }
}
