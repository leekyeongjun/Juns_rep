using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;


public class Scene_manager : MonoBehaviour
{
    public static float playTime = 83f; 
    
    public void Game_quit()
    {
        Application.Quit();
    }

    public void SetPlaytime_40()
    {
        playTime = 43f;
        timer.rTime = playTime;
    }
    public void SetPlaytime_60()
    {
        playTime = 63f;
        timer.rTime = playTime;
    }
    public void SetPlaytime_80()
    {
        playTime = 83f;
        timer.rTime = playTime;
    }
    public void SetPlaytime_100()
    {
        playTime = 103f;
        timer.rTime = playTime;
    }

    public void go_Start_screen(){
        SceneManager.LoadScene("Start_screen");
    }
    
    public void go_Select_screen()
    {
        Time.timeScale = 1;      
        SceneManager.LoadScene("Stage_0");
    }
    public void go_Stage_0_1()
    {
        Time.timeScale = 1;
        SceneManager.LoadScene("Stage_0_1");
    }

    public void Replay_Stage_0_1()
    {
        timer.rTime = playTime;
        Time.timeScale = 1;
        SceneManager.LoadScene("Stage_0_1");
    }

    public void go_Stage1()
    {
        Time.timeScale = 1;
        SceneManager.LoadScene("Stage_1");
    }

    public void Replay_Stage1()
    {
        timer.rTime = playTime;
        Time.timeScale = 1;
        SceneManager.LoadScene("Stage_1");
    }


    public void go_Stage2()
    {
        Time.timeScale = 1;
        SceneManager.LoadScene("Stage_2");
    }
    public void Replay_Stage2()
    {
        timer.rTime = playTime;
        Time.timeScale = 1;
        SceneManager.LoadScene("Stage_2");
    }

    public void go_Stage3()
    {
        Time.timeScale = 1;
        
        SceneManager.LoadScene("Stage_3");
    }

    public void Replay_Stage3()
    {
        timer.rTime = playTime;
        Time.timeScale = 1;
        SceneManager.LoadScene("Stage_3");
    }
    public void go_Stage4()
    {
        Time.timeScale = 1;
        
        SceneManager.LoadScene("Stage_4");
    }
    public void Replay_Stage4()
    {
        timer.rTime = playTime;
        Time.timeScale = 1;
        
        SceneManager.LoadScene("Stage_4");
    }




}
