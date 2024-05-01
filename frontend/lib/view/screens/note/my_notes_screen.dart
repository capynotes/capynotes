import 'package:auto_route/auto_route.dart';
import 'package:capynotes/constants/colors.dart';
import 'package:capynotes/navigation/app_router.dart';
import 'package:capynotes/view/widgets/custom_widgets/custom_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/asset_paths.dart';
import '../../../translations/locale_keys.g.dart';
import '../../../viewmodel/note_cubit/note_cubit.dart';
import '../../widgets/custom_widgets/custom_drawer.dart';
import '../../widgets/lotties/default_lottie_widget.dart';
import '../../widgets/notes_list_view.dart';

@RoutePage()
class MyNotesScreen extends StatelessWidget {
  const MyNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
              title: Text("My Notes"),
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
              context.read<NoteCubit>().getMyNotes();
            },
            child: const Icon(Icons.refresh),
          ),
          body: BlocBuilder<NoteCubit, NoteState>(
            bloc: context.read<NoteCubit>()..getMyNotes(),
            builder: (context, state) {
              if (state is NotesDisplay) {
                return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TabBarView(children: [
                      state.pendingNotes.isNotEmpty
                          ? NoteListView(noteList: state.pendingNotes)
                          : Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(LocaleKeys.labels_no_pending_audios.tr()),
                                const SizedBox(height: 16.0),
                                CustomElevatedButton(
                                    onPressed: () {
                                      context.router.replace(
                                          NoteGenerationRoute(folderID: 0));
                                    },
                                    child: Text(LocaleKeys
                                        .buttons_lets_generate_notes
                                        .tr()))
                              ],
                            )),
                      state.doneNotes.isNotEmpty
                          ? NoteListView(noteList: state.doneNotes)
                          : Text(LocaleKeys.labels_no_transcribed_audios.tr()),
                      state.allNotes.isNotEmpty
                          ? NoteListView(noteList: state.allNotes)
                          : Text(LocaleKeys.labels_no_audios_found.tr()),
                    ]));
              } else if (state is NoteLoading) {
                return DefaultLottie(path: AssetPaths.loadingLottie);
              } else if (state is NoteNotFound) {
                return const Center(
                    child: Text("No notes found, please generate notes first"));
              } else {
                return const Center(
                    child: Text("An Error Occured While Fetching Notes"));
              }
            },
          )),
    );
  }
}
