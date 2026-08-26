package com.techsmartpro360.smartremote

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent { SmartRemoteApp() }
    }
}

@Composable
fun SmartRemoteApp() {
    var status by remember { mutableStateOf("Not connected") }
    MaterialTheme {
        Surface(Modifier.fillMaxSize()) {
            Column(Modifier.fillMaxSize().padding(20.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                Text("Smart Remote", style = MaterialTheme.typography.headlineMedium)
                Text(status, modifier = Modifier.padding(8.dp))
                Button(onClick = { status = "TV discovery coming next" }) { Text("Find TV") }
                Spacer(Modifier.height(24.dp))
                Row { Button(onClick = {}) { Text("◀") }; Spacer(Modifier.width(12.dp)); Button(onClick = {}) { Text("OK") }; Spacer(Modifier.width(12.dp)); Button(onClick = {}) { Text("▶") } }
                Row { Button(onClick = {}) { Text("▲") }; Spacer(Modifier.width(12.dp)); Button(onClick = {}) { Text("▼") } }
                Spacer(Modifier.height(12.dp))
                Row { Button(onClick = {}) { Text("BACK") }; Spacer(Modifier.width(12.dp)); Button(onClick = {}) { Text("HOME") } }
                Spacer(Modifier.height(12.dp))
                Row { Button(onClick = {}) { Text("VOL −") }; Spacer(Modifier.width(12.dp)); Button(onClick = {}) { Text("MUTE") }; Spacer(Modifier.width(12.dp)); Button(onClick = {}) { Text("VOL +") } }
            }
        }
    }
}
