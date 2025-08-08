import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AppIcons {
  // Social Media Icons
  static HugeIcon linkedIn(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedLinkedin02,
    color: Theme.of(context).colorScheme.inverseSurface,
  );

  static HugeIcon xTwitter(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedNewTwitter,
    color: Theme.of(context).colorScheme.inverseSurface,
  );

  static HugeIcon gitHub(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedGithub,
    color: Theme.of(context).colorScheme.inverseSurface,
  );

  //OTHERS
  static HugeIcon add(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedAdd01,
    color: Theme.of(context).colorScheme.inverseSurface,
  );
  static HugeIcon home(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedHome01,
    color: Theme.of(context).colorScheme.inverseSurface,
  );
  static HugeIcon history(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedClock01,
    color: Theme.of(context).colorScheme.inverseSurface,
  );
  static HugeIcon peoples(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedUserGroup,
    color: Theme.of(context).colorScheme.inverseSurface,
  );
  static HugeIcon user(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedUser,
    color: Theme.of(context).colorScheme.inverseSurface,
  );
  static HugeIcon consultation(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedTestTube,
    color: Theme.of(context).colorScheme.inverseSurface,
  );
  static HugeIcon other(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedMore,
    color: Theme.of(context).colorScheme.inverseSurface,
  );
  static HugeIcon notification(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedNotification01,
    color: Theme.of(context).colorScheme.inverseSurface,
  );
  static HugeIcon cancel(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedCancel01,
    color: Theme.of(context).colorScheme.inverseSurface,
  );
  static HugeIcon arrowRight(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedArrowRight01,
    color: Theme.of(context).colorScheme.inverseSurface,
  );
  static HugeIcon arrowDown(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedArrowDown01,
    color: Theme.of(context).colorScheme.inverseSurface,
  );
  static HugeIcon deleteBin(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedDelete01,
    color: Theme.of(context).colorScheme.inverseSurface,
  );
  static HugeIcon empty(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedUserBlock01,
    color: Theme.of(context).colorScheme.inverseSurface,
  );
  static HugeIcon edit(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedEdit02,
    color: Theme.of(context).colorScheme.inverseSurface,
  );

  //Anamnèse Icons
  static HugeIcon audio(BuildContext context, {bool isEnable = false}) =>
      HugeIcon(
        icon: isEnable
            ? HugeIcons.strokeRoundedMic01
            : HugeIcons.strokeRoundedMicOff01,
        color: isEnable ? Colors.green : Theme.of(context).colorScheme.error,
      );
  static HugeIcon photo(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedImageAdd01,
    color: Theme.of(context).colorScheme.inverseSurface,
  );
  static HugeIcon aiAssistance(BuildContext context, {bool isEnable = false}) =>
      HugeIcon(
        icon: HugeIcons.strokeRoundedAiMic,
        color: isEnable ? Colors.green : Theme.of(context).colorScheme.error,
      );
  static HugeIcon aiTranlate(BuildContext context, {bool isEnable = false}) =>
      HugeIcon(
        icon: HugeIcons.strokeRoundedAiAudio,
        color: isEnable ? Colors.green : Theme.of(context).colorScheme.error,
      );

  static HugeIcon exit(BuildContext context) => HugeIcon(
    icon: HugeIcons.strokeRoundedCallOutgoing01,
    color: Theme.of(context).colorScheme.inverseSurface,
  );
}
