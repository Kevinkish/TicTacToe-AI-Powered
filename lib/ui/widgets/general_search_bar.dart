import 'package:flutter/material.dart';

import '/domain/domain.dart';
import '/ui/ui.dart';

class GeneralSearchBar extends StatelessWidget {
  final TextEditingController searchBarController;
  final Function(String)? onChanged;
  const GeneralSearchBar({
    super.key,
    required this.searchBarController,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      trailing: [
        IconButton(
          onPressed: () {
            searchBarController.clear();
            onChanged?.call("");
          },
          icon: AppIcons.cancel(context),
        ),
      ],
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      onChanged: onChanged,
      controller: searchBarController,
      hintText: 'Search...',
      textStyle: WidgetStatePropertyAll(
        ThemeUtil.txtTheme(context).labelMedium!.copyWith(
          color: ThemeUtil.colorScheme(context).onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      hintStyle: WidgetStatePropertyAll(
        ThemeUtil.txtTheme(context).labelMedium!.copyWith(
          color: AppColors.grey.withAlpha(128),
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: WidgetStatePropertyAll(
        ThemeUtil.colorScheme(context).surface,
      ),
      elevation: const WidgetStatePropertyAll(0.0),
      side: WidgetStatePropertyAll(
        BorderSide(color: ThemeUtil.colorScheme(context).onSurface),
      ),
    );
  }
}
