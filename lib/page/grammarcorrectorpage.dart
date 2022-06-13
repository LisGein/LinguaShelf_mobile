import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../widgets/grammarcorrectorwidget.dart';
import '/page/basepage.dart';

class GrammarCorrectorPage extends BasePage {
  const GrammarCorrectorPage({Key? key}) : super(key: key);

  @override
  Widget buildBody(BuildContext context) {
    return const GrammarCorrectorWidget();
  }

}