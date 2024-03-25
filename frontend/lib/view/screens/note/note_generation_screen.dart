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
          ? _buildVerticalSrcOptions(context)
          : _buildHorizontalSrcOptions(context),
    );
  }

  SingleChildScrollView _buildVerticalSrcOptions(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SourceLottieCard(
              lottiePath: AssetPaths.youtubeLottie,
              sourceScreenPath: "/note-generation-details/youtube",
              height: MediaQuery.of(context).size.height / 3.5,
              // width: MediaQuery.of(context).size.width / 1.5,
            ),
            SourceLottieCard(
              lottiePath: AssetPaths.browseFolderLottie,
              sourceScreenPath: "/note-generation-details/audio",
              height: MediaQuery.of(context).size.height / 3.5,
              // width: MediaQuery.of(context).size.width / 1.5,
            ),
            SourceLottieCard(
              lottiePath: AssetPaths.microphoneLottie,
              sourceScreenPath: "/note-generation-details/recording",
              height: MediaQuery.of(context).size.height / 3.5,
              // width: MediaQuery.of(context).size.width / 1.5,
            ),
          ],
        ),
      ),
    );
  }

  Center _buildHorizontalSrcOptions(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SourceLottieCard(
            lottiePath: AssetPaths.youtubeLottie,
            sourceScreenPath: "/note-generation-details/youtube",
            otherDetails: const Text("Generate Note from a Youtube Video",
                style: TextStyle(color: Colors.white)),
            height: null,
            width: MediaQuery.of(context).size.width / 4,
          ),
          SourceLottieCard(
            lottiePath: AssetPaths.browseFolderLottie,
            sourceScreenPath: "/note-generation-details/audio",
            otherDetails: const Text("Generate Note from a Audio File",
                style: TextStyle(color: Colors.white)),
            height: null,
            width: MediaQuery.of(context).size.width / 4,
          ),
          SourceLottieCard(
            lottiePath: AssetPaths.microphoneLottie,
            sourceScreenPath: "/note-generation-details/recording",
            otherDetails: const Text("Record instantly and Generate Note",
                style: TextStyle(color: Colors.white)),
            height: null,
            width: MediaQuery.of(context).size.width / 4,
          ),
        ],
      ),
    );
  }
}

class SourceLottieCard extends StatelessWidget {
  const SourceLottieCard(
      {super.key,
      required this.lottiePath,
      required this.sourceScreenPath,
      this.otherDetails,
      this.height,
      this.width});
  final String lottiePath;
  final String sourceScreenPath;
  final Widget? otherDetails;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.pushNamed(sourceScreenPath);
      },
      child: SizedBox(
        child: Card(
          color: Colors.grey[700],
          elevation: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DefaultLottie(path: lottiePath, height: height, width: width),
              otherDetails != null ? otherDetails! : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
