using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;



public class StageSelection : MonoBehaviour
{
    public GameObject[] Stages;
    public GameObject Cursor;

    public Sprite hiddenport;

    private int c_s = 1;
    private int c_g = 1;
    int[,] StageId = new int[3,3]{{0,1,2}, {6,6,6}, {3,4,5}};

    private void Start() {
        SoundManager.SM.SoundOn();
        for(int i = 0; i<7; i++){
            if(GameManager.GM.ClearedBoss[i] == true){
                Stages[i].GetComponent<StagePortrait>().OnCleared();
            }
        }
        
        for(int i = 0; i<6; i++){
            if(GameManager.GM.ClearedBoss[i] == true) Debug.Log("Stage " + i.ToString() + "Cleared.");
            else return;
        }
        Stages[6].GetComponent<StagePortrait>().idle = hiddenport;
        Stages[6].GetComponent<StagePortrait>().Chosen = hiddenport;

    }
    private void Update() {
        CursorMove();
        
        if(Input.GetKeyDown(KeyCode.Space)){
            
            if(StageId[c_g,c_s] == 6){
                for(int i = 0; i<6; i++){
                    if(GameManager.GM.ClearedBoss[i] == true) Debug.Log("Stage " + i.ToString() + "Cleared.");
                    else{
                        Debug.Log("Stage " + i.ToString() + "UnCleared!");
                        FXManager.fx.PlayDenySound();
                        return;
                    }
                }
                FXManager.fx.PlaySelectSound();
                Stages[StageId[c_g,c_s]].GetComponent<StageManager>().MoveScene();
                
            }
            else{
                FXManager.fx.PlaySelectSound();
                if(GameManager.GM.ClearedBoss[StageId[c_g,c_s]] == false)
                Stages[StageId[c_g,c_s]].GetComponent<StageManager>().MoveScene();
            }

        }
    }

    public void CursorMove(){
        if(Input.GetKeyDown(KeyCode.UpArrow)){
            FXManager.fx.PlayClickSound();
            Stages[StageId[c_g, c_s]].GetComponent<StagePortrait>().OutCursor();
            c_g -= 1;
            if(c_g < 0) c_g = 2;
            Stages[StageId[c_g, c_s]].GetComponent<StagePortrait>().OnCursor();
            Cursor.transform.position = Stages[StageId[c_g,c_s]].transform.position;
        }

        else if(Input.GetKeyDown(KeyCode.DownArrow)){
            FXManager.fx.PlayClickSound();
            Stages[StageId[c_g, c_s]].GetComponent<StagePortrait>().OutCursor();
            c_g += 1;
            if(c_g > 2) c_g = 0;
            Stages[StageId[c_g, c_s]].GetComponent<StagePortrait>().OnCursor();
            Cursor.transform.position = Stages[StageId[c_g,c_s]].transform.position;
        }

        else if(Input.GetKeyDown(KeyCode.LeftArrow)){
            FXManager.fx.PlayClickSound();
            Stages[StageId[c_g, c_s]].GetComponent<StagePortrait>().OutCursor();
            c_s -= 1;
            if(c_s < 0) c_s = 2;
            Stages[StageId[c_g, c_s]].GetComponent<StagePortrait>().OnCursor();
            Cursor.transform.position = Stages[StageId[c_g,c_s]].transform.position;
        }

        else if(Input.GetKeyDown(KeyCode.RightArrow)){
            FXManager.fx.PlayClickSound();
            Stages[StageId[c_g, c_s]].GetComponent<StagePortrait>().OutCursor();
            c_s += 1;
            if(c_s > 2) c_s = 0;
            Stages[StageId[c_g, c_s]].GetComponent<StagePortrait>().OnCursor();
            Cursor.transform.position = Stages[StageId[c_g,c_s]].transform.position;
        }
    }

}
