import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_preview_example/file_preview_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:file_preview/file_preview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isInit = false;
  String? version;

  @override
  void initState() {
    _tbsVersion();
    // _initTBS();
    super.initState();
  }

  void _initTBS() async {
    FilePreview.nativeMessageListener((res) async {
      var process = double.parse(res);
      print('res=>>>>>$process');
      if (process > 0 && process < 100) {
        // 下载内核中

      } else if (process == 200) {
        // 下载完成
      } else {
        print('下载失败，请手动下载');
        await FilePreview.tbsDebug();
      }
    });
    isInit = await FilePreview.initTBS();
    if (mounted) {
      print('isInit:$isInit');
      setState(() {});
    }
  }

  void _tbsVersion() async {
    version = await FilePreview.tbsVersion();
    isInit = await FilePreview.tbsHasInit();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Preview'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('TBS初始化 $isInit'),
            Text('TBS版本号 $version'),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text('初始化TBS'),
              onPressed: () async {
                _initTBS();
              },
            ),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text('TBS调试页面'),
              onPressed: () async {
                await FilePreview.tbsDebug();
              },
            ),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text('检测TBS是否初始化成功'),
              onPressed: () async {
                var hasInit = await FilePreview.tbsHasInit();
                print('hasInit:$hasInit');
                setState(() {});
              },
            ),
            MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text('清理本地缓存文件（android有效）'),
                onPressed: () async {
                  var delete = await FilePreview.deleteCache();
                  if (delete) {
                    print("缓存文件清理成功");
                  }
                }),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text('在线docx预览'),
              onPressed: () async {
                isInit = await FilePreview.tbsHasInit();
                setState(() {});
                if (!isInit) {
                  _initTBS();
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return const FilePreviewPage(
                        title: "docx预览",
                        path:
                            "http://116.62.204.86:7610/Resource/UploadFile/Upload/2022/8/26/APP-新加详情页KQ202200805-001_399227410968.docx",
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
