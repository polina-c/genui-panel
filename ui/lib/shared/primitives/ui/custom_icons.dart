import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'colors.dart';

class LogoIcon extends StatelessWidget {
  const LogoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/logo.svg',
      colorFilter:
          ColorFilter.mode(AppColors.primary(context), BlendMode.srcIn),
      semanticsLabel: 'GenUI logo',
    );
  }
}

class LeafsIcon extends StatelessWidget {
  const LeafsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        child: FittedBox(
            child: SvgPicture.asset('assets/leaf.svg',
                semanticsLabel: 'green leafs')),
        width: 20,
        height: 20,
      ),
    );
  }
}
