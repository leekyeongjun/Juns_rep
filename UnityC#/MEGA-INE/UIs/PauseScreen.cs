using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PauseScreen : MonoBehaviour
{
    public GameObject[] PauseMenuAnchors;
    int[] PauseThingsID = new int[1];
    public GameObject Cursor;


    private int c_id = 0;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        CursorMove();
        PauseActs();
    }

    public void CursorMove(){
        if(Input.GetKeyDown(KeyCode.UpArrow)){
            c_id -= 1;
            if(c_id < 0) c_id = 2;
            FXManager.fx.PlayClickSound();
            
        }

        else if(Input.GetKeyDown(KeyCode.DownArrow)){
            c_id += 1;
            if(c_id > 2) c_id = 0;
            FXManager.fx.PlayClickSound();
        }

        Cursor.transform.position = PauseMenuAnchors[c_id].transform.position;
    }

    public void PauseActs(){
        if(Input.GetKeyDown(KeyCode.Space)){
            
            if(c_id == 0){ 
                UserInterFace.ui.ClosePauseTab();
                FXManager.fx.PlayDenySound();
            }
            else if(c_id == 1){
                UserInterFace.ui.ClosePauseTab();
                SoundManager.SM.SoundOFF();
                Invoke("ReturnMove", .3f);
                
            }
            else if(c_id == 2){
                FXManager.fx.PlaySelectSound();
                SettingScreen.settingscreen.OpenSettingTab();

            }
        }
    }

    public void ReturnMove(){
        GameManager.GM.ResetPlayer();
        GameManager.GM.LoadtoScene("StageSelectScene");
    }
}
