import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_calculator/colors.dart';
import 'package:riverpod_calculator/riverpod.dart';
import 'package:riverpod_calculator/widgets/button_widget.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: MyColors.background1,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          margin: const EdgeInsets.only(left: 8),
          child: Text(widget.title),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: buildResult()),
            Expanded(flex: 2, child: buildButtons()),
          ],
        ),
      ),
    );
  }

  Widget buildResult() {
    final calculatorState = ref.watch(calculatorProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            calculatorState.equation,
            overflow: TextOverflow.ellipsis,
            style:
                const TextStyle(color: Colors.white, fontSize: 36, height: 1),
          ),
          const SizedBox(height: 24),
          Text(
            calculatorState.result,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey, fontSize: 18, height: 1),
          ),
        ],
      ),
    );
  }

  Widget buildButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: MyColors.background2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: <Widget>[
          buildButtonRow('AC', '<', '', '÷'),
          buildButtonRow('7', '8', '9', '⨯'),
          buildButtonRow('4', '5', '6', '-'),
          buildButtonRow('1', '2', '3', '+'),
          buildButtonRow('0', '.', '', '='),
        ],
      ),
    );
  }

  Widget buildButtonRow(
    String first,
    String second,
    String third,
    String fourth,
  ) {
    final row = [first, second, third, fourth];

    return Expanded(
      child: Row(
        children: row
            .map((text) => ButtonWidget(
                  text: text,
                  onClicked: () => onClickedButton(text),
                  onClickedLong: () => onLongClickedButton(text),
                ))
            .toList(),
      ),
    );
  }

  void onClickedButton(String buttonText) {
    final calculator = ref.read(calculatorProvider.notifier);
    switch (buttonText) {
      case 'AC':
        calculator.reset();
        break;
      case '<':
        calculator.delete();
        break;
      case '=':
        calculator.equals();
        break;
      default:
        calculator.append(buttonText);
        break;
    }
  }

  void onLongClickedButton(String text) {
    final calculator = ref.read(calculatorProvider.notifier);
    if (text == '<') calculator.reset();
  }
}
