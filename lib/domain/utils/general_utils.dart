import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../domain.dart';
import '/ui/ui.dart';

class GeneralUtils {
  Material generalButton({
    Color? backColor = Colors.transparent,
    Widget? child,
    double? radius,
    EdgeInsets? padding,
    VoidCallback? tapAction,
    void Function()? doubleTapAction,
    Color borderColor = Colors.transparent,
    void Function()? longPressAction,
  }) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 15),
        side: BorderSide(color: borderColor, width: 1),
      ),
      elevation: 0.0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      color: backColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius ?? 15),

        // autofocus: true,
        hoverColor: AppColors.grey.withValues(alpha: 0.3),
        splashColor: Colors.grey,
        onTap: tapAction,
        onDoubleTap: doubleTapAction,
        onLongPress: longPressAction,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 15),
          side: BorderSide(color: borderColor, width: 1),
        ),
        child: Padding(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: child,
        ),
      ),
    );
  }

  CupertinoActivityIndicator loadingContinious({
    required dynamic context,
    Color? color,
  }) {
    return CupertinoActivityIndicator(
      color: color ?? ThemeUtil.colorScheme(context).onSurface,
    );
  }

  Future<dynamic> confirmationDialog(
    dynamic context, {
    bool barrierDismissible = true,
    required String text,
    required IconData icon,
    required Function()? onConfirm,
    String? confirmLabel,
    String? unConfirmLabel,
    Color? confirmColor,
    Color? unConfirmColor,
  }) {
    bool isLoading = false;
    return showCupertinoDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        final consultationProvider = Provider.of<GeneralProvider>(context);

        return AlertDialog(
          icon: Icon(icon, color: AppColors.red),
          content: Text(
            textAlign: TextAlign.center,
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Row(
              spacing: 10,
              // runSpacing: 10,
              // runAlignment: WrapAlignment.center,
              // crossAxisAlignment: WrapCrossAlignment.center,
              // alignment: WrapAlignment.center,
              children: [
                Expanded(
                  child: generalButton(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    borderColor: unConfirmColor ?? AppColors.grey,
                    tapAction: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        unConfirmLabel ?? "Annuler",
                        style: TextStyle(
                          color: unConfirmColor ?? AppColors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: generalButton(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    backColor:
                        confirmColor?.withValues(alpha: 0.1) ??
                        AppColors.red.withValues(alpha: 1),
                    tapAction: isLoading
                        ? null
                        : () async {
                            consultationProvider.recharge(isLoading = true);
                            await onConfirm?.call();
                            consultationProvider.recharge(isLoading = false);
                          },
                    child: isLoading
                        ? loadingContinious(
                            context: context,
                            color: confirmColor ?? AppColors.white0,
                          )
                        : Center(
                            child: Text(
                              confirmLabel ?? "Supprimer",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: confirmColor ?? AppColors.white0,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  TextFormField generalTextInput(
    BuildContext context, {
    required TextEditingController textEditingController,
    bool onlyNumber = false,
    String? hintText,
    bool centerText = false,
    void Function()? onCleared,
  }) {
    return TextFormField(
      inputFormatters: onlyNumber
          ? [FilteringTextInputFormatter.digitsOnly]
          : [],
      keyboardType: onlyNumber ? TextInputType.number : TextInputType.text,
      controller: textEditingController,
      textAlign: centerText ? TextAlign.center : TextAlign.start,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: IconButton(
          onPressed: () {
            textEditingController.clear();
            onCleared?.call();
          },
          icon: AppIcons.cancel(context),
        ),
      ),
    );
  }
}
