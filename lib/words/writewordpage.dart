import 'package:async/async.dart';
import 'package:batut_de/lslistwidget.dart';
import 'package:batut_de/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

enum InputState { NotSubmited, Wrong, Right }

class WriteWordWidget extends StatefulWidget {
  WriteWordWidget({required this.words, required this.translations});

  int wordIndex = 0;
  List<String> words;
  List<String> translations;
  InputState state = InputState.NotSubmited;

  void inputCallback(String inputWord) {
    if (inputWord != words[wordIndex]) {
      state = InputState.Wrong;
    } else {
      state = InputState.Right;
    }
  }

  @override
  _WriteWordState createState() => _WriteWordState();
}

class _WriteWordState extends State<WriteWordWidget> {
  final _controller = TextEditingController();
  RestartableTimer? timer;

  void handleTimeout() {
    ++widget.wordIndex;
    widget.state = InputState.NotSubmited;
    setState(() {});
  }

  Widget _inputWord() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(widget.translations[widget.wordIndex],
            style: Styles.getTextStyle()),
        TextFormField(
            controller: _controller,
            decoration:
                const InputDecoration(hintText: 'Введите слово на немецком'),
            onEditingComplete: () {
              widget.inputCallback(_controller.text);
              setState(() {});
            }),
        ElevatedButton(
            onPressed: () {
              widget.inputCallback(_controller.text);
              setState(() {});
            },
            child: const Text('Проверить'))
      ]),
    );
  }

  Widget _showRightAnswer() {
    timer ??= RestartableTimer(const Duration(seconds: 1), handleTimeout);
    if (!timer!.isActive) {
      timer!.reset();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.state == InputState.Wrong)
          Text("Неправильно", style: Styles.getTextStyle()),
        if (widget.state == InputState.Right)
          Text("Верно", style: Styles.getTextStyle()),
        Text(
            widget.words[widget.wordIndex] +
                " - " +
                widget.translations[widget.wordIndex],
            style: Styles.getTextStyle()),
      ],
    );
  }

  Widget _showAllWords() {
    return ListView.separated(
      itemCount: widget.translations.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: SizedBox(
              height: 50,
              child: Center(
                child: Text(
                    widget.words[index] + " - " + widget.translations[index],
                    style: Styles.getTextStyle(color: Colors.white)),
              )),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(thickness: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state == InputState.NotSubmited) {
      if (widget.wordIndex < widget.translations.length &&
          widget.wordIndex < widget.words.length) {
        return _inputWord();
      } else {
        return _showAllWords();
      }
    } else {
      return _showRightAnswer();
    }
  }
}
