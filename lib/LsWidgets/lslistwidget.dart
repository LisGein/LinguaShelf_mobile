import 'package:batut_de/LsWidgets/lstext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pair.dart';

class LsListWidget extends StatelessWidget {
  LsListWidget({required this.data, required this.routeName, this.divThickness = 5.0});
  List<Pair> data;
  double divThickness;
  String routeName;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            print("/" + routeName + "/" + data[index].left);
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