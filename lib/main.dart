import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:qr_code_dart_scan/qr_code_dart_scan.dart";

import "service/memory_service.dart";
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
  /* 存储数据的Map */
  static Map<String, dynamic>? memoryData;

  /* 创建方法通道 */
  static const platform = MethodChannel("com.example.app/engine");

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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  /* 调用原生方法启动新引擎 */
                  final result = await platform.invokeMethod("launchNewEngine");
                  print("引擎启动结果：$result");

                  /* 引擎启动成功后导航到结果页面 */
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewEnginePage()),
                  );
                } catch (e) {
                  print("启动新引擎失败：$e");
                  Fluttertoast.showToast(
                    msg: "启动新引擎失败：$e",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              child: Text("启动新引擎"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                memoryData = {
                  "name": "测试数据",
                  "value": 100,
                  "isValid": true,
                  "items": ["item1", "item2", "item3"]
                };

                /* 同时保存到原生层以支持跨引擎共享 */
                await MemoryService.saveData(memoryData!);

                Fluttertoast.showToast(
                  msg: "数据写入成功",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );
              },
              child: Text("内存写入"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (memoryData != null) {
                  Fluttertoast.showToast(
                    msg: "读取的数据：${memoryData.toString()}",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "数据不存在",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              child: Text("内存读取"),
            ),
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

class NewEnginePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NewEnginePage"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            SizedBox(height: 20),
            Text(
              "引擎启动成功！",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("返回"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final data = {
                  "name": "测试数据",
                  "value": 100,
                  "isValid": true,
                  "items": ["item1", "item2", "item3"]
                };

                /* 通过原生层保存数据 */
                await MemoryService.saveData(data);

                Fluttertoast.showToast(
                  msg: "数据写入成功",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );
              },
              child: Text("内存写入"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                /* 从原生层读取数据 */
                final data = await MemoryService.getData();

                if (data != null) {
                  Fluttertoast.showToast(
                    msg: "读取的数据：${data.toString()}",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "数据不存在",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              child: Text("内存读取"),
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
