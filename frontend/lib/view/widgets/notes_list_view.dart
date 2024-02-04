import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../model/note_model.dart';
import '../../translations/locale_keys.g.dart';
import '../../utility/utils.dart';

class NoteListView extends StatelessWidget {
  const NoteListView({
    super.key,
    required this.noteList,
  });
  final List<NoteModel> noteList;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              // TODO: Navigate to that note's screen
              context.router.pushNamed("/note/${noteList[index].id}");
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            tileColor: ColorConstants.primaryColor,
            // title: Text(noteList[index].name ?? "No Name"),
            leading: Text(
              "${index + 1}",
              style: TextStyle(
                  fontSize: 24,
                  color: ColorConstants.lightBlue,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.my_library_books,
              color: ColorConstants.lightBlue,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "" // "${LocaleKeys.labels_uploaded_at.tr()} ${Utils.dateToString(noteList[index].uploadTime!)}",
                    ),
                RichText(
                    text: TextSpan(
                        text: LocaleKeys.labels_status.tr(),
                        style: TextStyle(
                            color: ColorConstants.lightBlue,
                            fontWeight: FontWeight.bold),
                        children: [
                      // TextSpan(
                      //     text: noteList[index].status!.name,
                      //     style: TextStyle(
                      //         color: noteList[index].status ==
                      //                 noteStatus.PENDING
                      //             ? ColorConstants.lightBlue
                      //             : noteList[index].status == noteStatus.DONE
                      //                 ? const Color.fromARGB(255, 0, 255, 8)
                      //                 : Colors.red,
                      //         fontWeight: FontWeight.normal))
                    ])),
                Row(
                  children: [
                    TextButton(
                        child: Text("Transcription"),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(
                                        LocaleKeys.labels_transcription.tr()),
                                    // content: SingleChildScrollView(
                                    //   child: Text(
                                    //       noteList[index].transcription ??
                                    //           "No transcription available yet"),
                                    // ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("OK"))
                                    ],
                                  ));
                        }),
                    TextButton(
                        child: Text("Summary"),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("Summary"),
                                    // content: SingleChildScrollView(
                                    //   child: Text(noteList[index].summary ??
                                    //       "No summary available yet"),
                                    // ),
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
        itemCount: noteList.length);
  }
}
