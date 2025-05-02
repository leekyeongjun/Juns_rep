using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class Reflection
{
    public string YourFeelings;
    public string TodayNeeds;
    public string TodayLearned;

    public List<float> ReflectionScores;

    public string YourPlans;

    public Reflection(int size){
        YourFeelings = "";
        TodayNeeds = "";
        TodayLearned = "";
        YourPlans = "";
        ReflectionScores = new List<float>(new float[size]);
    }
}

[System.Serializable]
public class ReflectionList
{
    public List<Reflection> reflections;

    public ReflectionList(){
        reflections = new List<Reflection>(new Reflection[5]);
        reflections[0] = new Reflection(1);
        reflections[1] = new Reflection(2);
        reflections[2] = new Reflection(2);
        reflections[3] = new Reflection(2);
        reflections[4] = new Reflection(1);
    }
}
