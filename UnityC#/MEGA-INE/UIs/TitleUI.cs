using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class TitleUI : MonoBehaviour
{
    public GameObject Cursor;
    public GameObject[] MenuAnchors;
    int[] TitleThingsID = new int[2];


    private int c_id = 0;

    public GameObject DifficultySelectPanel;
    public GameObject Titlemenu;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        CursorMove();
        TitleActs();        
    }

    public void CursorMove(){
        
        if(Input.GetKeyDown(KeyCode.UpArrow)){
            FXManager.fx.PlayClickSound();
            c_id -= 1;
            if(c_id < 0) c_id = 2;
        }
        else if(Input.GetKeyDown(KeyCode.DownArrow)){
            FXManager.fx.PlayClickSound();
            c_id += 1;
            if(c_id > 2) c_id = 0;
            
        }
        Cursor.transform.position = MenuAnchors[c_id].transform.position;
    }

    public void TitleActs(){
        if(Input.GetKeyDown(KeyCode.Space)){
            FXManager.fx.PlaySelectSound();
            if(c_id == 0){ 
                Titlemenu.SetActive(false);
                DifficultySelectPanel.SetActive(true);
            }
            else if(c_id == 1){
                Application.Quit();
            }
            else if(c_id == 2){
                SettingScreen.settingscreen.OpenSettingTab();
            }
        }
    }
}
