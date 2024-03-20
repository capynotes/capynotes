import 'package:auto_route/auto_route.dart';
import 'package:capynotes/constants/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../constants/asset_paths.dart';
import '../../../translations/locale_keys.g.dart';
import '../../widgets/custom_widgets/custom_drawer.dart';
import '../../widgets/lotties/default_lottie_widget.dart';

@RoutePage()
class NoteGenerationScreen extends StatefulWidget {
  const NoteGenerationScreen({super.key});

  @override
  State<NoteGenerationScreen> createState() => _NoteGenerationScreenState();
}

class _NoteGenerationScreenState extends State<NoteGenerationScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryColor,
        title: Text(
          LocaleKeys.appbars_titles_note_generation.tr(),
        ),
        centerTitle: true,
      ),
      endDrawer: CustomDrawer(),
      body: MediaQuery.of(context).size.width < 600
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      color: Colors.grey[700],
                      elevation: 10,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: DefaultLottie(path: AssetPaths.youtubeLottie),
                      ),
                    ),
                    Card(
                      color: Colors.grey[700],
                      elevation: 10,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child:
                            DefaultLottie(path: AssetPaths.browseFolderLottie),
                      ),
                    ),
                    Card(
                      color: Colors.grey[700],
                      elevation: 10,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: DefaultLottie(path: AssetPaths.microphoneLottie),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.router
                              .pushNamed("/note-generation-details/youtube");
                        },
                        child: Card(
                          color: Colors.grey[700],
                          elevation: 10,
                          child: SizedBox(
                            // height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width / 4,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DefaultLottie(path: AssetPaths.youtubeLottie),
                                Text(
                                  "Generate Note from a Youtube Video",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        elevation: 10,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 4,
                          child: DefaultLottie(
                              path: AssetPaths.browseFolderLottie),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        elevation: 10,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 4,
                          child:
                              DefaultLottie(path: AssetPaths.microphoneLottie),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
