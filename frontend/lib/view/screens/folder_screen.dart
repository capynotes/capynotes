import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_snackbars.dart';
import 'package:capynotes/view/widgets/lotties/default_lottie_widget.dart';
import 'package:capynotes/view/widgets/note_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_menu/star_menu.dart';

import '../../constants/asset_paths.dart';
import '../../constants/colors.dart';
import '../../model/folder/folder_with_count_model.dart';
import '../../viewmodel/folder_cubit/folder_cubit.dart';
import '../widgets/custom_widgets/custom_drawer.dart';
import '../widgets/custom_widgets/custom_text_form_field.dart';
import '../widgets/folder_widget.dart';

@RoutePage()
class FolderScreen extends StatefulWidget {
  FolderScreen({super.key, @PathParam('id') required this.folderID});
  int folderID;

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FolderCubit, FolderState>(
      bloc: context.read<FolderCubit>()..getFolderContents(widget.folderID),
      listener: (context, state) {
        if (state is FolderSuccess) {
          CustomSnackbars.displaySuccessMotionToast(
              context, state.title, state.description, () {
            context.read<FolderCubit>().getFolderContents(widget.folderID);
          });
        } else if (state is FolderError) {
          CustomSnackbars.displaySuccessMotionToast(
              context, state.title, state.description, () {
            context.read<FolderCubit>().getFolderContents(widget.folderID);
          });
        }
      },
      builder: (context, state) {
        if (state is FolderDisplay) {
          return Scaffold(
            appBar: AppBar(
              title: Text("${widget.folderID}"),
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
                      children: state.tempFolderContents.isNotEmpty
                          ? state.tempFolderContents.map((item) {
                              if (item is FolderWithCountModel) {
                                return FolderWidget(
                                  folderWithCount: item,
                                );
                              } else {
                                return NoteWidget(noteItemModel: item);
                              }
                            }).toList()
                          : [],
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: StarMenu(
              onItemTapped: (index, controller) {
                if (index != 2) controller.closeMenu!();
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
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          final addFolderFormKey = GlobalKey<FormState>();
                          return AlertDialog(
                            title: const Text("Create Folder"),
                            content: Form(
                              key: addFolderFormKey,
                              child: CustomTextFormField(
                                controller: context
                                    .read<FolderCubit>()
                                    .createFolderController,
                                label: "Folder Name",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (addFolderFormKey.currentState!
                                      .validate()) {
                                    context
                                        .read<FolderCubit>()
                                        .createFolderInFolder(widget.folderID);
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text("Create Folder"),
                              ),
                            ],
                          );
                        });
                  },
                  label: const Text("Add Folder"),
                ),
                const SizedBox(height: 70),
              ],
              child: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
          );
        } else {
          return DefaultLottie(path: AssetPaths.loadingLottie);
        }
      },
    );
  }
}
