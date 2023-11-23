import 'package:auto_route/auto_route.dart';
import 'package:capynotes/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

@RoutePage()
class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      headerBackgroundColor: Colors.white,
      controllerColor: Color.fromARGB(255, 53, 193, 212),
      finishButtonText: "Let's Start!",
      onFinish: () {
        context.router.popAndPush(const RegisterRoute());
      },
      finishButtonStyle: const FinishButtonStyle(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        backgroundColor: Color.fromARGB(255, 53, 193, 212),
      ),
      background: [
        Image.asset('assets/icons/capynotes_logo.jpeg'),
        Image.asset('assets/icons/capynotes_logo.jpeg'),
      ],
      totalPage: 2,
      speed: 1.8,
      pageBodies: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Column(
            children: [
              SizedBox(
                height: 480,
              ),
              Text('Description Text 1'),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Column(
            children: [
              SizedBox(
                height: 480,
              ),
              Text('Description Text 2'),
            ],
          ),
        ),
      ],
    );
  }
}
