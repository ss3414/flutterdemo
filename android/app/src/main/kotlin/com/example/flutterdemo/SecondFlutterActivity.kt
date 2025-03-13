package com.example.flutterdemo

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class SecondFlutterActivity : FlutterActivity() {
    companion object {
        private const val MEMORY_CHANNEL = "com.example.app/memory"
        private const val ENGINE_ID = "second_engine"
    }

    override fun getCachedEngineId(): String {
        return ENGINE_ID
    }

    override fun shouldDestroyEngineWithHost(): Boolean = true

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MEMORY_CHANNEL)
            .setMethodCallHandler { call, result ->
                MemoryDataBridge.handleMethodCall(call, result)
            }
    }
}
