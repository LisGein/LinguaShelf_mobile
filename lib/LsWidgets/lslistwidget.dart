import 'package:batut_de/LsWidgets/lstext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LsListWidget extends StatelessWidget {
  LsListWidget({required this.data, required this.routeName, this.divThickness = 5.0});
  List<dynamic> data;
  double divThickness;
  String routeName;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            print("/" + routeName + "/" + data[index].keys.first);
            Navigator.pushNamed(context, "/" + routeName + "/" + data[index].keys.first);
          },
          child: SizedBox(
              height: 150,
              child: Center(
                child: LsWhiteText(data[index].values.first),
              )),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
      Divider(thickness: divThickness),

    );
  }


}