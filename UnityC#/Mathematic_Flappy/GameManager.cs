using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager GM;
    public QuestionMaker qm;
    public int qtype = 0;

    public bool onGame = false;
    public int point = 0;
    public int maxPoint = 0;
    public Transform StartPos;
    public GameObject Character;
    public ObstacleSpawner obs;

    void Awake(){
        GM = this;
    }
    void Start()
    {
        StopTime();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public void SetQtype(int type){
        if(type == 0) qm.qtype = QuestionMaker.QType.add;
        else if(type == 1) qm.qtype = QuestionMaker.QType.multiply;
        else qm.qtype = QuestionMaker.QType.minus;
    }
    public void GameReady(){
        Character.transform.position = StartPos.position;
        SetQtype(qtype);
        obs.DeleteOb();
        point = 0;
    }
    public void GameStart(){
        Debug.Log("GameStart!");
        StartTime();
        GameManager.GM.onGame = true;
        Character.GetComponent<OneCommand>().rigid.velocity = Vector2.zero;
        Character.GetComponent<OneCommand>().pop();
        
    }
    public void GameOver(){
        Debug.Log("Die");
        GameManager.GM.onGame = false;
        if(maxPoint <= point) maxPoint = point;
        StopTime();
        UserInterface.ui.GameOverPanelActivate();
    }

    public void GetPoint(){
        point++;
        Debug.Log("Ding!");
    }

    public void StopTime(){
        Time.timeScale = 0f;
    }

    public void StartTime(){
        Time.timeScale = 1f;
    }
}
