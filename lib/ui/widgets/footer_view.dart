import 'package:flutter/material.dart';

class FooterView extends StatelessWidget {
  const FooterView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall,
            TextSpan(
              children: <InlineSpan>[
                TextSpan(text: "© 2025 "),
                TextSpan(
                  text: "NAMIDrc",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: " ∙ #GemmaHackathon"),
              ],
            ),
          ),
          Text.rich(
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall,
            TextSpan(
              children: <InlineSpan>[
                TextSpan(text: "Powered by "),
                TextSpan(
                  text: "NAMI®",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
