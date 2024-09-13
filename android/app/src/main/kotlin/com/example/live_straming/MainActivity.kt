package com.example.live_straming

import android.app.PictureInPictureParams
import android.content.res.Configuration
import android.os.Build
import android.util.Rational
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.app/pip"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "enterPiP") {
                enterPiPMode()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        // Automatically enter PiP mode when the app is minimized (backgrounded)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            enterPiPMode()
        }
    }
    override fun onStop() {
        super.onStop()
        // Enter PiP mode when the app is stopped (backgrounded or closed)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && !isInPictureInPictureMode) {
            enterPiPMode()
        }
    }
private fun enterPiPMode() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        val aspectRatio = Rational(16, 9)
        val pipBuilder = PictureInPictureParams.Builder()
        pipBuilder.setAspectRatio(aspectRatio)
        enterPictureInPictureMode(pipBuilder.build())
        // Notify Flutter to update the UI
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, CHANNEL).invokeMethod("onPiPEnter", null)
        }
    }
}
    // Notify Flutter when PiP mode changes
    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration?
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        if (!isInPictureInPictureMode) {
            flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                MethodChannel(messenger, CHANNEL).invokeMethod("onPiPExit", null)
            }
        }
    }
}