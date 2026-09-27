package com.app.nia_hrms

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.Process

/** A real process restart lets Shorebird load its already downloaded patch. */
class PatchRestartActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val sourcePid = intent.getIntExtra("sourcePid", -1)
        if (sourcePid <= 0 || sourcePid == Process.myPid()) {
            finish()
            return
        }
        // This non-exported Activity runs in :patch_restart. Tracking preferences
        // stay persisted; initializeBackgroundServices restores active tracking.
        Process.killProcess(sourcePid)
        startActivity(Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
        })
        finish()
        Process.killProcess(Process.myPid())
    }
}
