import 'package:auto_route/auto_route.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_dialogs.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_snackbars.dart';
import 'package:capynotes/view/widgets/lotties/default_lottie_widget.dart';
import 'package:capynotes/view/widgets/note_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:star_menu/star_menu.dart';

import '../../constants/asset_paths.dart';
import '../../constants/colors.dart';
import '../../model/folder/folder_with_count_model.dart';
import '../../navigation/app_router.dart';
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
          final GlobalKey<ScaffoldState> _key = GlobalKey();
          return Scaffold(
            key: _key,
            appBar: AppBar(
              title: Text("${state.allFolderContents.title}"),
              backgroundColor: ColorConstants.primaryColor,
              centerTitle: true,
              actions: [
                SearchBarAnimation(
                  durationInMilliSeconds: 500,
                  searchBoxWidth: MediaQuery.of(context).size.width * 0.2,
                  textEditingController: TextEditingController(),
                  isOriginalAnimation: true,
                  enableKeyboardFocus: true,
                  onChanged: (value) {
                    context.read<FolderCubit>().searchFolder(value);
                  },
                  onExpansionComplete: () {
                    debugPrint('do something just after searchbox is opened.');
                  },
                  onCollapseComplete: () {
                    debugPrint('do something just after searchbox is closed.');
                  },
                  onPressButton: (isSearchBarOpens) {
                    debugPrint(
                        'do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation');
                  },
                  trailingWidget: const Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.black,
                  ),
                  secondaryButtonWidget: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.black,
                  ),
                  buttonWidget: const Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    _key.currentState?.openEndDrawer();
                  },
                )
              ],
            ),
            endDrawer: CustomDrawer(),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GridView.extent(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: state.tempFolderContents.items!.isNotEmpty
                          ? state.tempFolderContents.items!.map((item) {
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
                    onPressed: () {
                      context.router.replace(
                          NoteGenerationRoute(folderID: widget.folderID));
                    },
                    label: const Text("Add Note")),
                FloatingActionButton.extended(
                  onPressed: () {
                    final formKey = GlobalKey<FormState>();
                    CustomDialogs.showSinglePropFormDialog(
                      context: context,
                      formKey: formKey,
                      title: "Add Folder",
                      label: "Folder Name",
                      controller:
                          context.read<FolderCubit>().createFolderController,
                      onConfirm: () {
                        context
                            .read<FolderCubit>()
                            .createFolderInFolder(widget.folderID);
                      },
                    );
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
