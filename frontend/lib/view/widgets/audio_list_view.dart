import 'package:capynotes/view/widgets/custom_widgets/custom_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../enums/audio_status_enum.dart';
import '../../model/audio_model.dart';
import '../../translations/locale_keys.g.dart';
import '../../utils.dart';

class AudioListView extends StatelessWidget {
  const AudioListView({
    super.key,
    required this.audioList,
  });
  final List<AudioModel> audioList;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text(LocaleKeys.labels_transcription.tr()),
                        content: SingleChildScrollView(
                          child: Text(audioList[index].transcription ??
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
            title: Text(audioList[index].name ?? "No Name"),
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
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${LocaleKeys.labels_uploaded_at.tr()} ${Utils.dateToString(audioList[index].uploadTime!)}",
                ),
                RichText(
                    text: TextSpan(
                        text: LocaleKeys.labels_status.tr(),
                        style: TextStyle(
                            color: ColorConstants.lightBlue,
                            fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          text: audioList[index].status!.name,
                          style: TextStyle(
                              color: audioList[index].status ==
                                      AudioStatus.PENDING
                                  ? ColorConstants.lightBlue
                                  : audioList[index].status == AudioStatus.DONE
                                      ? const Color.fromARGB(255, 0, 255, 8)
                                      : Colors.red,
                              fontWeight: FontWeight.normal))
                    ])),
                Row(
                  children: [
                    CustomElevatedButton(
                        child: Text("See Transcription"),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(
                                        LocaleKeys.labels_transcription.tr()),
                                    content: SingleChildScrollView(
                                      child: Text(
                                          audioList[index].transcription ??
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
                        }),
                    CustomElevatedButton(
                        child: Text("See Summary"),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("Summary"),
                                    content: SingleChildScrollView(
                                      child: Text(audioList[index].summary ??
                                          "No summary available yet"),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("OK"))
                                    ],
                                  ));
                        })
                  ],
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: audioList.length);
  }
}
