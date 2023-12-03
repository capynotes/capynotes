import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../constants/asset_paths.dart';

class LoadingLottie extends StatelessWidget {
  const LoadingLottie({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(AssetPaths.loadingLottie),
    );
  }
}
