package com.example.prayer

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    
    private val CHANNEL = "com.example.prayer/native" // Define your custom channel name here

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            // Handle the method calls from Flutter here
            when (call.method) {
                "exampleMethod" -> {
                    // Example: If the method name from Flutter is "exampleMethod"
                    val data = exampleMethod()
                    result.success(data) // Send result back to Flutter
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    // Example of a native method to be called from Flutter
    private fun exampleMethod(): String {
        return "Hello from Android!"
    }
}
