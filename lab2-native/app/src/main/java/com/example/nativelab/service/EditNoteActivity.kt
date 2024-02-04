package com.example.nativelab.service

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.Window
import android.widget.Button
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.example.nativelab.R
import com.example.nativelab.model.FoodStory
import kotlinx.android.synthetic.main.edit_note.*
class EditNoteActivity : AppCompatActivity() {

    lateinit var id: Number;
    private lateinit var initialStory: FoodStory;

    private lateinit var cancelButton: Button;
    private lateinit var saveButton: Button;

    override fun onCreate(savedInstanceState: Bundle?) {

        val str = "EDIT NOTE ACTIVITY"
        Log.i(str, "Am intrat in edit note")

        super.onCreate(savedInstanceState)

        setContentView(R.layout.edit_note)

        supportActionBar?.hide()


        val window: Window = this@EditNoteActivity.window
        window.statusBarColor = ContextCompat.getColor(this@EditNoteActivity, R.color.black)


        val bundle = intent.getBundleExtra("storyBundle")
        if(bundle != null) {
            val story = bundle.getParcelable<FoodStory>("story")
            if (story != null) {
                initialStory = story
                id = story.id
            }
        }

        initializeInputs()

        saveButton = saveButtonUpdate
        cancelButton = cancelButtonUpdate

        saveButton.setOnClickListener(){
            editStory()
        }

        cancelButton.setOnClickListener(){
            goBack()
        }

    }

    private fun editStory() {
        if(checkInputs()){


            initialStory.date = dateInputUpdate.text.toString()
            initialStory.foodItems = foodItemsInputUpdate.text.toString()
            initialStory.calories = caloriesInputUpdate.text.toString().toInt()
            initialStory.sugarQuantity = sugarQuantityInputUpdate.text.toString().toInt()
            initialStory.additionalInfo = textInputUpdate.text.toString()

            val bundle = Bundle()
            bundle.putParcelable("story", initialStory)
            intent.putExtra("storyBundle", bundle)
            intent.putExtra("id", id)
            setResult(RESULT_OK, intent)
            finish()
        } else
        {
            Toast.makeText(this, "All fields must be completed!", Toast.LENGTH_LONG).show();
        }
    }

    private fun goBack(){
        intent = Intent()
        finish()
    }

    private fun checkInputs(): Boolean {
        if(foodItemsInputUpdate.text.isEmpty() or caloriesInputUpdate.text.isEmpty() or sugarQuantityInputUpdate.text.isEmpty() or dateInputUpdate.text.isEmpty() or textInputUpdate.text.isEmpty()){
            return false
        }

        return true
    }

    private fun initializeInputs(){

        idInputUpdate.setText(id.toString());
        idInputUpdate.isEnabled = false
        dateInputUpdate.setText(initialStory.date)
        foodItemsInputUpdate.setText(initialStory.foodItems)
        caloriesInputUpdate.setText(initialStory.calories.toString())
        sugarQuantityInputUpdate.setText(initialStory.sugarQuantity.toString())
        textInputUpdate.setText(initialStory.additionalInfo)

    }
}