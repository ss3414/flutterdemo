package com.example.flutterdemo

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import android.content.Intent

class MainActivity : FlutterActivity() {
    companion object {
        private const val ENGINE_CHANNEL = "com.example.app/engine"
        private const val MEMORY_CHANNEL = "com.example.app/memory"
        private const val ENGINE_ID = "second_engine"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        /* 注册引擎通道 */
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ENGINE_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "launchNewEngine") {
                    launchNewFlutterEngine()
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }

        /* 注册内存数据通道 */
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MEMORY_CHANNEL)
            .setMethodCallHandler { call, result ->
                MemoryDataBridge.handleMethodCall(call, result)
            }
    }

    private fun launchNewFlutterEngine() {
        /* 创建新FlutterEngine */
        val secondEngine = FlutterEngine(this)
        secondEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        /* 为新引擎注册内存数据通道 */
        MethodChannel(secondEngine.dartExecutor.binaryMessenger, MEMORY_CHANNEL)
            .setMethodCallHandler { call, result ->
                MemoryDataBridge.handleMethodCall(call, result)
            }

        /* 缓存引擎 */
        FlutterEngineCache.getInstance().put(ENGINE_ID, secondEngine)

        /* 启动新Activity */
        val intent = Intent(this, SecondFlutterActivity::class.java)
        startActivity(intent)
    }
}
