using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
public class TimeManager : MonoBehaviour
{
    public static TimeManager tm;
    void Awake() {
        if(tm == null) tm= this;
        else if (tm != this) Destroy(gameObject);
        DontDestroyOnLoad(gameObject);  
    }

    void Start(){

    }

    public string GetTimeComparedtoNow(DateTime t){
        string msg = "";
        DateTime now = DateTime.Now;
        TimeSpan ts = now.Subtract(t);

        int diffMin = Mathf.Abs((int)ts.TotalMinutes);
        int diffhou =  Mathf.Abs((int)ts.TotalHours);
        int diffday = Mathf.Abs((int) ts.TotalDays);
        int diffsec = /*Mathf.Abs*/((int) ts.TotalSeconds);

        //Debug.Log(" Diffday = " + diffday.ToString() + " Diffhou = " + diffhou.ToString() +  " Diffmin = "  + diffMin.ToString() + " DiffSec = " + diffsec.ToString());
        if(diffday >= 30){
            msg = (String.Format("{0}년 {1:00}월 {2:00}일", t.Year, t.Month, t.Day));
        }
        else if(diffday >= 1){
            msg = diffday.ToString() + "일 전";
        }
        else if(diffhou >= 1){
            msg = diffhou.ToString() + "시간 전";
        }
        else if(diffMin >= 1){
            msg = diffMin.ToString() + "분 전";
        }
        else if(diffsec <= 59 && diffsec >= 15) {
            msg = diffsec.ToString() + "초 전";
        }
        else {
            msg = "방금 전";
        }
        return msg;
    }

    void TestTimes(){
        DateTime n = DateTime.Now;
        DateTime t0 = n.AddDays(60);
        Debug.Log(GetTimeComparedtoNow(t0));
        DateTime t = n.AddDays(5);
        Debug.Log(GetTimeComparedtoNow(t));
        DateTime t2 = n.AddHours(15);
        Debug.Log(GetTimeComparedtoNow(t2));
        DateTime t3 = n.AddMinutes(59);
        Debug.Log(GetTimeComparedtoNow(t3));
        DateTime t4 = n.AddSeconds(20);
        Debug.Log(GetTimeComparedtoNow(t4));
    }
}
