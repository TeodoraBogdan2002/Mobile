package com.example.nativelab

import android.content.Intent
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.Window
import com.example.nativelab.R
import android.widget.Button
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import com.example.nativelab.data.ListViewActivity

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        supportActionBar?.hide()

        val window: Window = this@MainActivity.window
        window.statusBarColor = ContextCompat.getColor(this@MainActivity, R.color.black)

        val startButton = findViewById<Button>(R.id.startButton);
        startButton.setOnClickListener{
            goToList()
        }
    }

    private fun goToList(){
        val intent  = Intent(this, ListViewActivity::class.java)
        startActivity(intent);
    }

}