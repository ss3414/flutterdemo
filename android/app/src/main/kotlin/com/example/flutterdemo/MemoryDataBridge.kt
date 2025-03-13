package com.example.flutterdemo

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/* 数据桥接类，用于在不同引擎间共享数据 */
object MemoryDataBridge {
    /* 用于存储共享数据的静态Map */
    private val memoryDataMap = HashMap<String, Any?>()

    /* 处理来自Flutter的方法调用 */
    fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "saveData" -> {
                val key = call.argument<String>("key") ?: "default"
                val data = call.argument<Any>("data")
                memoryDataMap[key] = data
                result.success(true)
            }

            "getData" -> {
                val key = call.argument<String>("key") ?: "default"
                result.success(memoryDataMap[key])
            }

            "removeData" -> {
                val key = call.argument<String>("key") ?: "default"
                memoryDataMap.remove(key)
                result.success(true)
            }

            "clearAllData" -> {
                memoryDataMap.clear()
                result.success(true)
            }

            else -> {
                result.notImplemented()
            }
        }
    }
}
