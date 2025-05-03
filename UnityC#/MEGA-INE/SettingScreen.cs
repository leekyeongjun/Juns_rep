using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SettingScreen : MonoBehaviour
{
    public static SettingScreen settingscreen;
    public GameObject SettingPanel;

    void Awake(){
        DontDestroyOnLoad(gameObject);
        settingscreen = this;
        SettingPanel.SetActive(false);
    }

    void Update(){
        if(Input.GetKeyDown(KeyCode.Escape)){
            if(SettingPanel.activeSelf == true){
                CloseSettingTab();
            }
            
        }
    }
    public void OpenSettingTab(){
        FXManager.fx.PlaySelectSound();
        if(Player.player != null){
            Player.player.movement2D.Stop();
            Player.player.canControl = false;
        }
        GameManager.StopTime();
        SettingPanel.SetActive(true);
    }

    public void CloseSettingTab(){
        FXManager.fx.PlayDenySound();
        if(Player.player != null){
            Player.player.canControl = true;
            Player.player.movement2D.canMove = true;
        }
        GameManager.RestartTime();
        SettingPanel.SetActive(false);

    }

    public void QuitGame(){
        Application.Quit();
    }
}
