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
  num money1 = 1000000;
  num day = 21;
  num money2 = 10.23;
  num money3 = 10.23;
  num howMany = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    const _gender = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('home_title'.tr()),
      ),
      body: SingleChildScrollView(
        child: Center(
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
              Row(children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      onChanged: (String s){
                        try{
                          money1 = num.parse(s);
                        }catch(e){
                          money1 = 0;
                        }
                        setState((){});
                      }),
                ),
                const Text('money').plural(money1, format: NumberFormat.compact(locale: context.locale.toString())), // output: You have 1M dollars
              ]),
              // String
              // print('day'.plural(21)); // output: 21 день
              Row(children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      onChanged: (String s){
                        try{
                          day = num.parse(s);
                        }catch(e){
                          day = 0;
                        }
                        setState((){});
                      }),
                ),
                Text('day'.plural(day)), // output: 21 день
              ]),
              //Static function
              // var money = plural('money', 10.23) // output: You have 10.23 dollars
              Row(children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      onChanged: (String s){
                        try{
                          money2 = num.parse(s);
                        }catch(e){
                          money2 = 0;
                        }
                        setState((){});
                      }),
                ),
                Text('day'.plural(money2)), // output: 21 день
              ]),
              //Static function with arguments
              // var money = plural('money_args', 10.23, args: ['John', '10.23'])  // output: John has 10.23 dollars
              Row(children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      onChanged: (String s){
                        try{
                          money3 = num.parse(s);
                        }catch(e){
                          money3 = 0;
                        }
                        setState((){});
                      }),
                ),
                Text(plural('money_args', money3, args: ['John', '10.23'])),  // output: John has 10.23 dollars
              ]),
              // 以下の実験から、英語では次の通りに条件分岐されるっぽい
              // 0:zero
              // 四捨五入して1(日本語では1のみ）:one
              // 2:tow
              // そのほか:other
              // few, manyは使われないようだ
              // double.infinity,double.nanはエラー、他はその他
              Row(children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      onChanged: (String s){
                        try{
                          howMany = num.parse(s);
                        }catch(e){
                          howMany = 0;
                        }
                        setState((){});
                      }),
                ),
                const Text('how_many').plural(howMany),  // output: John has 10.23 dollars
              ]),

              // Linked translations
              // ほかの文言を使うことができる。
              // @:key
              const Text('example1.helloWorld').tr(), //Output: Hello World!
              // 引数もネストできる
              const Text('dateLogging').tr(namedArgs: {'currentDate': DateTime.now().toIso8601String()}), //Output: INFO: the date today is 2020-11-27T16:40:42.657.
              // 大文字小文字の区別がある言語なら変更できる
              // @.modifier:key
              //  -upper
              //  -lower
              //  -capitalize 最初だけ大文字
              const Text('example2.emptyNameError').tr(), //Output: Please fill in your full name
            ],
          ),
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