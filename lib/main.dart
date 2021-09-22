// https://pub.dev/packages/easy_localization
// このページの内容を参考に進める。

// 各言語の設定ファイルの変更は Hot Reload ではなく、Hot Restart を使わないと反映されない。
// また、言語の変更も同様（変数を用いない場合はHot Reloadで反映される）

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  // Needs to be called so that we can await for EasyLocalization.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      // List of supported locales.
      supportedLocales: const [Locale('en', ''), Locale('ja', 'JP')],
      // Path to your folder with localization files.
      path:
          'assets/translations', // <-- change the path of the translation files
      // 	Returns the locale when the locale is not in the list supportedLocales.(Not required)
      fallbackLocale: const Locale('en', ''),
      // Place for your main page widget.
      child: const MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // .tr()メソッドなどを使う場合はBuildContextを更新したほうが無難
    // そうしないと微妙にINFOが出る
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    const _gender = false;
    int money = 1000000;
    return Scaffold(
      appBar: AppBar(
        title: Text('home_title'.tr()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'pushed_times',
            ).plural(_counter),
            // args
            const Text('msg').tr(args: ['Easy localization', 'Dart']),
            // namedArgs
            const Text('msg_named').tr(namedArgs: {'lang': 'Dart'}),
            // args and namedArgs
            const Text('msg_mixed').tr(args: ['Easy localization'], namedArgs: {'lang': 'Dart'}),
            // gender
            const Text('gender').tr(gender: _gender ? "female" : "male", args: ['西']),

            // plural
            // Text widget with format
            Column(children: [
              TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                onChanged: (String s){
                  var parse;
                  try{
                    parse = int.parse(s);
                  }catch(e){
                    parse = 0;
                  }
                  print(parse);
                  setState((){money = parse;});
                }),
            ]),
            Text(money.toString()),
            Text('money').plural(money, format: NumberFormat.compact(locale: context.locale.toString())), // output: You have 1M dollars
            // String
            // print('day'.plural(21)); // output: 21 день
            Text('day'.plural(21)), // output: 21 день
            //Static function
            // var money = plural('money', 10.23) // output: You have 10.23 dollars
            Text(plural('money', 10.23)), // output: You have 10.23 dollars
            //Static function with arguments
            // var money = plural('money_args', 10.23, args: ['John', '10.23'])  // output: John has 10.23 dollars
            Text(plural('money_args', 10.23, args: ['John', '10.23'])),  // output: John has 10.23 dollars
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
