import 'package:auto_route/annotations.dart';
import 'package:capynotes/viewmodel/flashcard_cubit/flashcard_cubit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../constants/asset_paths.dart';
import '../../../constants/colors.dart';
import '../../widgets/lotties/default_lottie_widget.dart';

@RoutePage()
class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key, @PathParam('id') required this.setID});
  final int setID;
  @override
  Widget build(BuildContext context) {
    CarouselController controller = CarouselController();
    return BlocConsumer<FlashcardCubit, FlashcardState>(
      bloc: context.read<FlashcardCubit>()..getFlashcardSet(id: setID),
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is FlashcardDisplay) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(context.read<FlashcardCubit>().flashcards!.title ??
                    "Error Loading Flashcards"),
              ),
              body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 8,
                          child: CarouselSlider(
                            items:
                                context.read<FlashcardCubit>().allFlashcardList,
                            carouselController: controller,
                            options: CarouselOptions(
                                autoPlay: false,
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                viewportFraction: 1),
                          )),
                      const Spacer(flex: 1),
                      Expanded(
                        flex: 3,
                        child: _buildButtonsRow(context, controller),
                      )
                    ],
                  )));
        } else if (state is FlashcardLoading) {
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
              body: DefaultLottie(path: AssetPaths.loadingLottie));
        } else {
          return const Center(child: Text(""));
        }
      },
    );
  }

  Row _buildButtonsRow(BuildContext context, CarouselController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            controller.previousPage();
          },
          child: const Text(
            "Wrong",
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {
            controller.nextPage();
          },
          child: const Text(
            "Pass",
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            controller.nextPage();
          },
          child: const Text(
            "Correct",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
