import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:qr_code_dart_scan/qr_code_dart_scan.dart";

import "service/untitled.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                /* 页面跳转 */
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InputPage()),
                );
              },
              child: Text("InputPage"),
            ),
            /* 按钮之间的间距 */
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanPage()),
                );
              },
              child: Text("ScanPage"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print(test());
              },
              child: Text("Untitled"),
            ),
          ],
        ),
      ),
    );
  }
}

class InputPage extends StatelessWidget {
  /* 文本输入框控制器 */
  final TextEditingController _controller = TextEditingController(text: "1234");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("InputPage"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              /* 绑定控制器以获取输入的文本 */
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Input",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                /* Toast提示 */
                Fluttertoast.showToast(
                  msg: _controller.text,
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
          ],
        ),
      ),
    );
  }
}

class ScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRCodeDartScanView(
        scanInvertedQRCode: true,
        typeScan: TypeScan.live,
        onCapture: (Result result) {
          print(result.text);
        },
      ),
    );
  }
}
