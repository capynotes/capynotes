import 'package:auto_route/auto_route.dart';
import 'package:capynotes/constants/colors.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_elevated_button.dart';
import 'package:capynotes/viewmodel/audio_cubit/audio_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/asset_paths.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/audio_list_view.dart';
import '../widgets/custom_widgets/custom_drawer.dart';
import '../widgets/lotties/default_lottie_widget.dart';

@RoutePage()
class MyAudiosScreen extends StatelessWidget {
  const MyAudiosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
              title: Text(LocaleKeys.appbars_titles_my_audios.tr()),
              backgroundColor: ColorConstants.primaryColor,
              centerTitle: true,
              bottom: TabBar(tabs: [
                Tab(text: LocaleKeys.tabbars_my_audios_pending.tr()),
                Tab(text: LocaleKeys.tabbars_my_audios_done.tr()),
                Tab(text: LocaleKeys.tabbars_my_audios_all.tr()),
              ])),
          endDrawer: CustomDrawer(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.read<AudioCubit>().getMyAudios();
            },
            child: const Icon(Icons.refresh),
          ),
          body: BlocBuilder<AudioCubit, AudioState>(
            bloc: context.read<AudioCubit>()..getMyAudios(),
            builder: (context, state) {
              if (state is AudioDisplay) {
                return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TabBarView(children: [
                      state.pendingAudios.isNotEmpty
                          ? AudioListView(audioList: state.pendingAudios)
                          : Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(LocaleKeys.labels_no_pending_audios.tr()),
                                const SizedBox(height: 16.0),
                                CustomElevatedButton(
                                    onPressed: () {
                                      context.router
                                          .replaceNamed("/note-generation");
                                    },
                                    child: Text(LocaleKeys
                                        .buttons_lets_generate_notes
                                        .tr()))
                              ],
                            )),
                      state.doneAudios.isNotEmpty
                          ? AudioListView(audioList: state.doneAudios)
                          : Text(LocaleKeys.labels_no_transcribed_audios.tr()),
                      state.allAudios.isNotEmpty
                          ? AudioListView(audioList: state.allAudios)
                          : Text(LocaleKeys.labels_no_audios_found.tr()),
                    ]));
              } else if (state is AudioLoading) {
                return DefaultLottie(path: AssetPaths.loadingLottie);
              } else if (state is AudioNotFound) {
                return Center(
                    child: Text(LocaleKeys.labels_no_audios_found.tr()));
              } else {
                return const Center(
                    child: Text("An Error Occured While Fetching Audios"));
              }
            },
          )),
    );
  }
}
