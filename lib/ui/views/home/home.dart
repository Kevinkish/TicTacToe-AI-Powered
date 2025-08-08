import 'package:flutter/material.dart';

import '/domain/domain.dart';
import '/ui/ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> menus = ["Consultation", "Patients", "Autres"];

    List<String> menusNbr = ["55", "30", ""];

    List<Widget> menusIcons = [
      AppIcons.consultation(context),
      AppIcons.peoples(context),
      AppIcons.other(context),
    ];

    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeUtil.colorScheme(context).primary,
              borderRadius: BorderRadius.circular(15),
            ),
            width: SizeUtil.sizeWidth(context),
            height: 250,
          ),
          SizeUtil.heightGap(10),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemCount: menus.length,
            itemBuilder: (context, index) {
              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      menusIcons[index],
                      SizeUtil.heightGap(10),
                      Flexible(
                        child: Text(
                          menus[index],
                          style: ThemeUtil.txtTheme(context).titleMedium,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          menusNbr[index],
                          style: ThemeUtil.txtTheme(context).titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
