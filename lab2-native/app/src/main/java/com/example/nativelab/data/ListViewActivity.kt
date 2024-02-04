package com.example.nativelab.data

import android.app.Activity
import android.content.Intent
import android.os.Build
import android.os.Bundle
import com.example.nativelab.adapter.ItemAdapter
import androidx.recyclerview.widget.LinearLayoutManager
import android.util.Log
import android.view.Window
import android.widget.ImageView
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.example.nativelab.model.FoodStory
import com.example.nativelab.R
import com.example.nativelab.service.AddNoteActivity
import kotlinx.android.synthetic.main.activity_list_notes.*

class ListViewActivity: AppCompatActivity() {
    private val stories = mutableListOf<FoodStory>()
    lateinit var addButton: ImageView

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onCreate(savedInstanceState: Bundle?) {
        val str = "LIST ACTIVITY"
        Log.i(str, "In the list")

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_list_notes)

        supportActionBar?.hide()

        val window: Window = this@ListViewActivity.window
        window.statusBarColor = ContextCompat.getColor(this@ListViewActivity, R.color.black)

        initStories()

        recyclerView.layoutManager = LinearLayoutManager(this)
        recyclerView.adapter = ItemAdapter(this,stories)

        addButton = findViewById(R.id.addNoteButton)

        addButton.setOnClickListener{
            val intent = Intent(applicationContext, AddNoteActivity::class.java)
            startActivityForResult(intent, 3);
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?){
        super.onActivityResult(requestCode, resultCode, data)
        if(requestCode == 3){
            if(resultCode == Activity.RESULT_OK){
                if(data!=null)
                {
                    val bundle = data.getBundleExtra("storyBundle")
                    val story = bundle?.getParcelable<FoodStory>("story")
                    if (story!= null)
                    {
                        addStoryToList(story)
                    }
                }
                Toast.makeText(this,"Added!",Toast.LENGTH_SHORT).show()
                recyclerView.adapter?.notifyItemInserted(stories.size-1)
            }

        }else if (requestCode == 5)
        {
            if(resultCode==Activity.RESULT_OK){
                if(data!=null){
                    val bundle = data.getBundleExtra("storyBundle")
                    val story=bundle?.getParcelable<FoodStory>("story")
                    val id = data.getIntExtra("id",-1)
                    if(story!=null && id!=-1){
                        updateStory(story,id)
                    }
                }
            }
        }
    }
    private fun updateStory(story: FoodStory, id: Number){
        for(i in 0 until stories.size){
            if(stories[i].id == id)
            {
                stories[i] = story
                Toast.makeText(this, "Updated!", Toast.LENGTH_SHORT).show()
                recyclerView.adapter?.notifyItemChanged(i)
            }
        }
    }

    private fun addStoryToList(story: FoodStory) {
        stories.add(story);
    }

    fun getId(): Number{
        return stories.size + 1;
    }

    private fun initStories() {
        val food1 = FoodStory("20-10-2023","Two muffins, chicken soup, one chicken salad",1500,29,"")
        val food2 = FoodStory("21-10-2023","One cappuccino, 200 gr brownie, 150 gr tomatoes, 200 gr roast chicken", 1600, 20,"")
        val food3 = FoodStory("22-10-2023","One cappuccino, 300 gr porridge, one banana, 250 ml vegetables soup, 300 gr tomato salad, one piadina", 1650,23,"")
        stories.add(food1)
        stories.add(food2)
        stories.add(food3)
    }
}
