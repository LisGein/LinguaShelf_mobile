import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import '../lswidgets/lstext.dart';
import '../pair.dart';

class LsListWidget extends StatelessWidget {
  const LsListWidget({Key? key, required this.data, required this.routeName, this.divThickness = 5.0}) : super(key: key);
  final List<Pair> data;
  final double divThickness;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            developer.log("/" + routeName + "/" + data[index].left);
            Navigator.pushNamed(context, "/" + routeName + "/" + data[index].left);
          },
          child: SizedBox(
              height: 75,
              child: Center(
                child: LsWhiteText.pair(data[index]),
              )),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
      Divider(thickness: divThickness),

    );
  }


}