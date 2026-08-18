package com.skinsyncaiinc.skinsyncai

import android.view.KeyEvent
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
    private val EVENT_CHANNEL = "com.skinsyncai/volume_buttons"
    private val METHOD_CHANNEL = "com.skinsyncai/volume_buttons_method"
    private var eventSink: EventChannel.EventSink? = null
    private var isInterceptionEnabled = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            }
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "enableInterception" -> {
                    isInterceptionEnabled = true
                    result.success(null)
                }
                "disableInterception" -> {
                    isInterceptionEnabled = false
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        if (isInterceptionEnabled) {
            if (event.repeatCount == 0) {
                if (keyCode == KeyEvent.KEYCODE_VOLUME_UP) {
                    eventSink?.success("volumeUp")
                    return true
                } else if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {
                    eventSink?.success("volumeDown")
                    return true
                }
            }
            if (keyCode == KeyEvent.KEYCODE_VOLUME_UP || keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {
                return true
            }
        }
        return super.onKeyDown(keyCode, event)
    }

    override fun onKeyUp(keyCode: Int, event: KeyEvent): Boolean {
        if (isInterceptionEnabled) {
            if (keyCode == KeyEvent.KEYCODE_VOLUME_UP || keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {
                return true
            }
        }
        return super.onKeyUp(keyCode, event)
    }
}
