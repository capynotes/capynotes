import 'package:auto_route/auto_route.dart';
import 'package:capynotes/model/folder/note_grid_model.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utility/utils.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({super.key, required this.noteItemModel});
  final NoteGridModel noteItemModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.replaceNamed("/note/${noteItemModel.id}");
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
              Text(noteItemModel.title ?? "No Title"),
              Text(noteItemModel.status ?? "No Status"),
              Text(Utils.dateToString(
                      DateTime.parse(noteItemModel.creationTime!)) ??
                  "No Creation Time"),
            ],
          ),
        ),
      ),
    );
  }
}
