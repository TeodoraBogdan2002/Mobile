package com.example.nativelab.service

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.Window
import android.widget.Button
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.example.nativelab.R
import com.example.nativelab.model.FoodStory
import kotlinx.android.synthetic.main.add_note.*
class AddNoteActivity : AppCompatActivity() {

    lateinit var cancelButton: Button;
    lateinit var saveButton: Button;
    lateinit var id: String;


    override fun onCreate(savedInstanceState: Bundle?) {

        val str = "ADD NOTE ACTIVITY"
        Log.i(str, "Am intrat in add note")

        super.onCreate(savedInstanceState)
        setContentView(R.layout.add_note)

        supportActionBar?.hide()

        val window: Window = this@AddNoteActivity.window
        window.statusBarColor = ContextCompat.getColor(this@AddNoteActivity, R.color.black)


        idInputCreate.setText(FoodStory.currentId.toString())

        idInputCreate.isEnabled = false


        saveButton = findViewById(R.id.saveButtonCreate);
        cancelButton = findViewById(R.id.cancelButtonCreate);

        saveButton.setOnClickListener() {
            addStory()
        }

        cancelButton.setOnClickListener() {
            goBack();
        }

    }

    private fun addStory() {
        if (checkInputs()) {

            val story = FoodStory(
                dateInputCreate.text.toString(),
                FoodProductsInputCreate.text.toString(),
                caloriesInputCreate.text.toString().toInt(),
                sugarQuantityInputCreate.text.toString().toInt(),
                additionalInfoInputCreate.text.toString()
            )

            val bundle = Bundle()
            bundle.putParcelable("story", story);
            intent.putExtra("storyBundle", bundle)
            setResult(RESULT_OK, intent)
            finish()
        } else {
            Toast.makeText(
                this,
                "All fields must be completed!",
                Toast.LENGTH_LONG
            ).show();
        }
    }

    private fun checkInputs(): Boolean {
        if (FoodProductsInputCreate.text.isEmpty() or caloriesInputCreate.text.isEmpty() or sugarQuantityInputCreate.text.isEmpty() or dateInputCreate.text.isEmpty() or additionalInfoInputCreate.text.isEmpty()) {
            return false
        }
        return true
    }

    private fun goBack() {
        intent = Intent()
        finish()
    }


}