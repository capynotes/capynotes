import 'package:auto_route/auto_route.dart';
import 'package:capynotes/constants/colors.dart';
import 'package:capynotes/view/widgets/loading_lottie_widget.dart';
import 'package:capynotes/viewmodel/audio_cubit/audio_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../translations/locale_keys.g.dart';
import '../../utils.dart';
import '../widgets/custom_widgets/custom_drawer.dart';

@RoutePage()
class MyAudiosScreen extends StatelessWidget {
  const MyAudiosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.appbars_titles_my_audios.tr()),
          backgroundColor: ColorConstants.primaryColor,
          centerTitle: true,
        ),
        endDrawer: CustomDrawer(),
        body: BlocConsumer<AudioCubit, AudioState>(
          bloc: context.read<AudioCubit>()..getMyAudios(),
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is AudioDisplay) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await context.read<AudioCubit>().getMyAudios();
                  },
                  child: Column(
                    children: [
                      ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text(LocaleKeys
                                              .labels_transcription
                                              .tr()),
                                          content: SingleChildScrollView(
                                            child: Text(state.myAudios[index]
                                                    .transcription ??
                                                "No transcription available yet"),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("OK"))
                                          ],
                                        ));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              tileColor: ColorConstants.primaryColor,
                              title:
                                  Text(state.myAudios[index].name ?? "No Name"),
                              leading: Text(
                                "${index + 1}",
                                style: TextStyle(
                                    fontSize: 24,
                                    color: ColorConstants.lightBlue,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(
                                Icons.multitrack_audio_outlined,
                                color: ColorConstants.lightBlue,
                              ),
                              subtitle: Text(
                                  "${LocaleKeys.labels_uploaded_at.tr()} ${Utils.dateToString(state.myAudios[index].uploadTime!)}"),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemCount: state.myAudios.length),
                    ],
                  ),
                ),
              );
            } else if (state is AudioLoading) {
              return const LoadingLottie();
            } else if (state is AudioNotFound) {
              return const Center(child: Text("No Audios Found"));
            } else {
              return const Center(
                  child: Text("An Error Occured While Fetching Audios"));
            }
          },
        ));
  }
}
