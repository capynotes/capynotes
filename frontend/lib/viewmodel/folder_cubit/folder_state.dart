part of 'folder_cubit.dart';

sealed class FolderState {}

final class FolderInitial extends FolderState {}

final class FolderLoading extends FolderState {}

final class FolderDisplay extends FolderState {
  FolderContentsModel allFolderContents;
  FolderContentsModel tempFolderContents;

  FolderDisplay(
      {required this.allFolderContents, required this.tempFolderContents});
}

final class FolderNotFound extends FolderState {}

final class FolderError extends FolderState {
  final String title;
  final String description;

  FolderError(this.title, this.description);
}

final class FolderSuccess extends FolderState {
  final String title;
  final String description;

  FolderSuccess(this.title, this.description);
}
