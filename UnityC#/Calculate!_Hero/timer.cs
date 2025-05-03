using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class timer : MonoBehaviour
{
    Text timer_text;
    public static float rTime;
    
    void Start()
    {
        rTime = Scene_manager.playTime;
        timer_text = GetComponent<Text>();
    }

    // Update is called once per frame
    void Update()
    {
        rTime -= Time.deltaTime;
        if(rTime<0){
            rTime=0;
        }
        timer_text.text=Mathf.Round(rTime).ToString();
    }
}
