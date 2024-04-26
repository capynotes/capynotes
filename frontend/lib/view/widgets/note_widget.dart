import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({super.key, required this.noteItemModel});
  final noteItemModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.replaceNamed("/note/${noteItemModel["noteID"]}");
      },
      child: Container(
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage(AssetPaths.notebookImage))),
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
      ),
    );
  }
}
