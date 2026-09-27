package com.app.nia_hrms

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.os.Process

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.app.nia_hrms/app_restart")
            .setMethodCallHandler { call, result ->
                if (call.method != "restart") {
                    result.notImplemented()
                } else {
                    try {
                        // A separate process must survive long enough to relaunch us.
                        startActivity(Intent(this, PatchRestartActivity::class.java).apply {
                            putExtra("sourcePid", Process.myPid())
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        })
                        result.success(null)
                    } catch (error: Exception) {
                        result.error("restart_failed", error.message, null)
                    }
                }
            }
    }
}
