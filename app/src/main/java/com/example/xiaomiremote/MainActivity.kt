package com.example.xiaomiremote

import android.app.Activity
import android.os.Bundle
import android.graphics.Color
import android.view.Gravity
import android.widget.*

class MainActivity : Activity() {
    private lateinit var status: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        buildUi()
    }

    private fun buildUi() {
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(28, 24, 28, 24)
            setBackgroundColor(Color.WHITE)
        }

        root.addView(TextView(this).apply {
            text = "Xiaomi Google Remote"
            textSize = 25f
            setTextColor(Color.BLACK)
            gravity = Gravity.CENTER
        }, LinearLayout.LayoutParams(-1, 70))

        status = TextView(this).apply {
            text = "Ready — connect your Xiaomi Google TV"
            textSize = 16f
            gravity = Gravity.CENTER
            setTextColor(Color.DKGRAY)
        }
        root.addView(status, LinearLayout.LayoutParams(-1, 60))

        root.addView(Button(this).apply {
            text = "CONNECT / DISCOVER TV"
            setOnClickListener {
                status.text = "Discovery module ready. TV must be on the same Wi-Fi."
            }
        })

        val grid = GridLayout(this).apply {
            columnCount = 3
            rowCount = 5
            setPadding(0, 20, 0, 0)
        }

        fun key(label: String) {
            val b = Button(this).apply {
                text = label
                textSize = 18f
                setOnClickListener { status.text = "Command: $label" }
            }
            val p = GridLayout.LayoutParams().apply {
                width = 0
                height = 70
                columnSpec = GridLayout.spec(GridLayout.UNDEFINED, 1f)
                setMargins(4, 4, 4, 4)
            }
            grid.addView(b, p)
        }

        key(""); key("▲"); key("")
        key("◀"); key("OK"); key("▶")
        key(""); key("▼"); key("")
        key("HOME"); key("BACK"); key("MUTE")
        key("VOL −"); key("POWER"); key("VOL +")

        root.addView(grid, LinearLayout.LayoutParams(-1, 0, 1f))
        root.addView(TextView(this).apply {
            text = "MVP 0.1 • Google TV Remote v2 foundation"
            gravity = Gravity.CENTER
            setTextColor(Color.GRAY)
        }, LinearLayout.LayoutParams(-1, 50))

        setContentView(root)
    }
}
