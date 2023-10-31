import 'package:capynotes/viewmodel/flashcard_cubit/flashcard_cubit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CarouselController controller = CarouselController();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Scheduling Algorithms"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<FlashcardCubit, FlashcardState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 8,
                      child: CarouselSlider(
                        items: context.read<FlashcardCubit>().allFlashcardList,
                        carouselController: controller,
                        options: CarouselOptions(
                            autoPlay: false,
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                            viewportFraction: 1),
                      )),
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 3,
                    child: _buildButtonsRow(context, controller),
                  )
                ],
              );
            },
          ),
        ));
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
          child: const Text("Wrong"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {
            controller.nextPage();
          },
          child: const Text("Pass"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            controller.nextPage();
          },
          child: const Text("Correct"),
        ),
      ],
    );
  }
}
