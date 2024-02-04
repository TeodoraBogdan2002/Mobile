package com.example.nativelab.model

import android.os.Parcel
import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

@Parcelize
data class FoodStory(
    var date: String,
    var foodItems: String,
    var calories: Int,
    var sugarQuantity: Int,
    var additionalInfo: String,
    val id: Int
) : Parcelable {
    companion object {
        var currentId = 0
    }

    constructor(
        date: String,
        foodItems: String,
        calories: Int,
        sugarQuantity: Int,
        additionalInfo: String
    ) : this(date, foodItems, calories, sugarQuantity, additionalInfo, currentId++) {
        // Optionally add logging or other initialization logic here
    }
}
