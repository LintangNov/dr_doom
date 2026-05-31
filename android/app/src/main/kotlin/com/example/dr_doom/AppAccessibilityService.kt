package com.example.dr_doom

import android.accessibilityservice.AccessibilityService
import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.view.accessibility.AccessibilityEvent
import io.flutter.plugin.common.EventChannel
import kotlin.math.abs

class AppAccessibilityService : AccessibilityService(), SensorEventListener {

    companion object {
        var instance: AppAccessibilityService? = null
        var drsListener: ((Double) -> Unit)? = null
    }

    private lateinit var sensorManager: SensorManager
    private var accelerometer: Sensor? = null

    private var zValue: Float = 0f
    private var yValue: Float = 0f

    private var swipeCount = 0
    private var tapCount = 0
    private var lastActivePackage = "com.example.doomapp"
    private var sessionStartTime = System.currentTimeMillis()

    override fun onCreate() {
        super.onCreate()
        instance = this
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        accelerometer?.let {
            sensorManager.registerListener(this, it, SensorManager.SENSOR_DELAY_NORMAL)
        }
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        // Track active application and reset session time if package changes
        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            val pkgName = event.packageName?.toString() ?: ""
            if (pkgName.isNotEmpty() && pkgName != lastActivePackage) {
                lastActivePackage = pkgName
                sessionStartTime = System.currentTimeMillis()
                swipeCount = 0
                tapCount = 0
            }
        }

        // Track user gesture/scrolling (accessibility feedback)
        if (event.eventType == AccessibilityEvent.TYPE_VIEW_SCROLLED) {
            swipeCount++
            calculateAndEmitDrs()
        }
        if (event.eventType == AccessibilityEvent.TYPE_VIEW_CLICKED) {
            tapCount++
            calculateAndEmitDrs()
        }
    }

    override fun onInterrupt() {}

    override fun onDestroy() {
        sensorManager.unregisterListener(this)
        instance = null
        super.onDestroy()
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null) return
        if (event.sensor.type == Sensor.TYPE_ACCELEROMETER) {
            yValue = event.values[1]
            zValue = event.values[2]

            // Only update/emit DRS periodically or when posture shifts
            calculateAndEmitDrs()
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    fun calculateAndEmitDrs() {
        val swipeToTapRatio = if (tapCount == 0) swipeCount.toDouble() * 20.0 else (swipeCount.toDouble() / tapCount.toDouble()) * 20.0
        val sessionMinutes = (System.currentTimeMillis() - sessionStartTime).toDouble() / 60000.0
        val isLyingDown = abs(zValue) > 8.0
        val isVeryStill = true
        val lux = 10.0 // Constant simulated lux
        val isLateNight = java.util.Calendar.getInstance().get(java.util.Calendar.HOUR_OF_DAY) > 22
        val isEvening = java.util.Calendar.getInstance().get(java.util.Calendar.HOUR_OF_DAY) > 18

        var score = 0.0
        if (swipeToTapRatio > 15.0) score += 25.0
        if (sessionMinutes > 10.0) score += 15.0 // rhythmic scroll estimation
        if (isLyingDown && isVeryStill) score += 20.0
        if (lux < 5.0 && isLateNight) {
            score += 20.0
        } else if (lux < 50.0 && isEvening) {
            score += 10.0
        }
        if (sessionMinutes > 45.0) {
            score += 30.0
        } else if (sessionMinutes > 20.0) {
            score += 15.0
        }
        if (isLyingDown && isLateNight && lux < 5.0) score += 15.0

        val clampedDrs = Math.max(0.0, Math.min(100.0, score))
        drsListener?.invoke(clampedDrs)
    }
}
