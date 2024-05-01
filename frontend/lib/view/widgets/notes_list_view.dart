import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../enums/note_status_enum.dart';
import '../../model/note_model.dart';
import '../../translations/locale_keys.g.dart';
import '../../utility/utils.dart';

class NoteListView extends StatelessWidget {
  const NoteListView({
    super.key,
    required this.noteList,
  });
  final List<Note> noteList;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
              onTap: () {
                if (noteList[index].status == NoteStatus.DONE) {
                  context.router.navigateNamed("/note/${noteList[index].id}");
                }
                // TODO: show message that the note is not ready yet
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              tileColor: ColorConstants.primaryColor,
              title: Text(noteList[index].title ?? "No Name"),
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
                    "${LocaleKeys.labels_uploaded_at.tr()} ${Utils.dateToString(DateTime.parse(noteList[index].creationTime!))}",
                  ),
                  RichText(
                      text: TextSpan(
                          text: LocaleKeys.labels_status.tr(),
                          style: TextStyle(
                              color: ColorConstants.lightBlue,
                              fontWeight: FontWeight.bold),
                          children: [
                        TextSpan(
                            text: noteList[index].status!.name,
                            style: TextStyle(
                                color: noteList[index].status ==
                                            NoteStatus.TRANSCRIBING ||
                                        noteList[index].status ==
                                            NoteStatus.SUMMARIZING
                                    ? ColorConstants.lightBlue
                                    : noteList[index].status == NoteStatus.DONE
                                        ? const Color.fromARGB(255, 0, 255, 8)
                                        : Colors.red,
                                fontWeight: FontWeight.normal))
                      ])),
                ],
              ));
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: noteList.length);
  }
}
