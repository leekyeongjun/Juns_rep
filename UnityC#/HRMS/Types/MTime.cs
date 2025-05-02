using System;
using UnityEngine;


[System.Serializable]
public class MTime
{
    public int year;
    public int month;
    public int day;
    public int hour;
    public int minute;
    public int second;

    public MTime(){
        year = 0;
        month = 0;
        day = 0;
        hour = 0;
        minute = 0;
        second = 0;
    }

    public MTime(int year, int month, int day, int hour, int minute, int second){
        if (IsValidDateTime(year, month, day, hour, minute, second))
        {
            this.year = year;
            this.month = month;
            this.day = day;
            this.hour = hour;
            this.minute = minute;
            this.second = second;
        }
        else
        {
            Debug.LogError("Invalid date and time parameters.");
        }
    }
    public MTime(DateTime dateTime)
    {
        year = dateTime.Year;
        month = dateTime.Month;
        day = dateTime.Day;
        hour = dateTime.Hour;
        minute = dateTime.Minute;
        second = dateTime.Second;
    }

    public DateTime ToDateTime()
    {
        return new DateTime(year, month, day, hour, minute, second);
    }
    
    private bool IsValidDateTime(int year, int month, int day, int hour, int minute, int second)
    {
        try
        {
            new DateTime(year, month, day, hour, minute, second);
            return true;
        }
        catch (ArgumentOutOfRangeException)
        {
            return false;
        }
    }
}
