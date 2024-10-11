import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";

/* 应用入口 */
void main() {
  runApp(const MyApp());
}

/*
* ①继承StatelessWidget代表应用本身是个Widget
* ②Flutter中大多数组件都是Widget
* */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      /* 首页路由 */
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /* Scaffold：material中的页面脚手架 */
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      /* Center组件居中 */
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            /* 页面跳转 */
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DemoPage()),
            );
          },
          child: Text("DemoPage"),
        ),
      ),
    );
  }
}

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DemoPage"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            /* Toast提示 */
            Fluttertoast.showToast(
              msg: "Toast",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          },
          child: Text("Button"),
        ),
      ),
    );
  }
}
