import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui.dart';

class SocialMediaView extends StatelessWidget {
  const SocialMediaView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> socialIcons = [
      AppIcons.linkedIn(context),
      AppIcons.xTwitter(context),
      AppIcons.gitHub(context),
    ];
    List<String> urls = [
      "https://linkedin.com/in/georgesbyona",
      "https://x.com/namidrc",
      "https://github.com/namidrc",
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        socialIcons.length,
        (index) => IconButton(
          onPressed: () => _launchUrl(urls[index]),
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          icon: socialIcons[index],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      debugPrint('Could not launch $url');
    }
  }
}
