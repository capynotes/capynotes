import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/widgets/note_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:star_menu/star_menu.dart';

import '../../constants/colors.dart';
import '../widgets/custom_widgets/custom_drawer.dart';
import '../widgets/folder_widget.dart';

@RoutePage()
class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key, @PathParam('id') required this.folderID});
  final int folderID;
  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  final List<FolderWidget> folderItemList = [
    FolderWidget(folderItemModel: {"folderID": 1}),
    FolderWidget(folderItemModel: {"folderID": 1}),
    FolderWidget(folderItemModel: {"folderID": 1}),
    FolderWidget(folderItemModel: {"folderID": 1}),
    FolderWidget(folderItemModel: {"folderID": 1}),
    FolderWidget(folderItemModel: {"folderID": 1}),
    FolderWidget(folderItemModel: {"folderID": 1}),
    FolderWidget(folderItemModel: {"folderID": 1}),
    FolderWidget(folderItemModel: {"folderID": 1}),
    FolderWidget(folderItemModel: {"folderID": 1})
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Folder Name"),
        backgroundColor: ColorConstants.primaryColor,
        centerTitle: true,
      ),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Search Note",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {},
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GridView.extent(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    for (int i = 0; i < 10; i++) folderItemList[i],
                    NoteWidget(
                      noteItemModel: {"NoteID": 1},
                    ),
                    NoteWidget(
                      noteItemModel: {"NoteID": 1},
                    ),
                    NoteWidget(
                      noteItemModel: {"NoteID": 1},
                    ),
                    NoteWidget(
                      noteItemModel: {"NoteID": 1},
                    ),
                    NoteWidget(
                      noteItemModel: {"NoteID": 1},
                    ),
                    NoteWidget(
                      noteItemModel: {"NoteID": 1},
                    ),
                    NoteWidget(
                      noteItemModel: {"NoteID": 1},
                    ),
                  ]),
            ],
          ),
        ),
      ),
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
