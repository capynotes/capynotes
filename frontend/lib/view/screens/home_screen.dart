import 'package:auto_route/auto_route.dart';
import 'package:capynotes/constants/asset_paths.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_dialogs.dart';
import 'package:capynotes/view/widgets/lotties/default_lottie_widget.dart';
import 'package:capynotes/viewmodel/home_cubit/home_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_menu/star_menu.dart';

import '../../constants/colors.dart';
import '../../model/folder/folder_with_count_model.dart';
import '../../model/user/user_info_model.dart';
import '../../navigation/app_router.dart';
import '../../services/api.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/custom_widgets/custom_drawer.dart';
import '../widgets/custom_widgets/custom_snackbars.dart';
import '../widgets/folder_widget.dart';
import '../widgets/note_widget.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
        bloc: context.read<HomeCubit>()..getHomeContents(),
        listener: (context, state) {
          if (state is HomeSuccess) {
            CustomSnackbars.displaySuccessMotionToast(
                context, state.title, state.description, () {
              context.read<HomeCubit>().getHomeContents();
            });
          } else if (state is HomeError) {
            CustomSnackbars.displaySuccessMotionToast(
                context, state.title, state.description, () {
              context.read<HomeCubit>().getHomeContents();
            });
          }
        },
        builder: (context, state) {
          if (state is HomeDisplay) {
            return Scaffold(
              appBar: AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "Welcome, ${UserInfo.loggedUser?.name ?? "CapyNotes User"}!",
                        style: TextStyle(
                          color: ColorConstants.lightBlue,
                          fontSize: 16,
                        )),
                    RichText(
                        text: TextSpan(
                            text: "Capy",
                            style: TextStyle(
                                fontSize: 24,
                                color: ColorConstants.lightBlue,
                                fontWeight: FontWeight.w900,
                                fontFamily: "Nunito"),
                            children: const [
                          TextSpan(
                              text: "Notes",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: "Nunito"))
                        ]))
                  ],
                ),
              ),
              endDrawer: CustomDrawer(),
              body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: GridView.extent(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: state.allHomeContents.isNotEmpty
                          ? state.allHomeContents.map((item) {
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
                  )),
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
                        context.router.push(NoteGenerationRoute(folderID: 0));
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
                            context.read<HomeCubit>().createFolderController,
                        onConfirm: () {
                          context.read<HomeCubit>().createFolder();
                        },
                      );
                    },
                    label: const Text("Add Folder"),
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      final response = Api.instance.postAmplifyRequest("", "");
                    },
                    label: const Text("test gateway"),
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
            return Scaffold(
              appBar: AppBar(
                title: RichText(
                    text: TextSpan(
                        text: "Capy",
                        style: TextStyle(
                            fontSize: 24,
                            color: ColorConstants.lightBlue,
                            fontWeight: FontWeight.w900,
                            fontFamily: "Nunito"),
                        children: const [
                      TextSpan(
                          text: "Notes",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontFamily: "Nunito"))
                    ])),
              ),
              body: DefaultLottie(
                path: AssetPaths.loadingLottie,
              ),
            );
          }
        });
  }
}
