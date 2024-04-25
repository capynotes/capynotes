import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AssetPaths.notebookImage))),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Text("Note Name"),
            Text("Status"),
            Text("Creation Date"),
          ],
        ),
      ),
    );
  }
}
