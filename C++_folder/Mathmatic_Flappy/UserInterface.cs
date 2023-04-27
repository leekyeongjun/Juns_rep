using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UserInterface : MonoBehaviour
{
    public static UserInterface ui;

    public Text pointText;

    public GameObject GameOverPanel;
    public Button RestartBtn;
    public Text MaxScoreText;
    public Text CurScoreText;

    public GameObject StartPanel;
    public Button StartBtn;
    public Button PlusBtn;
    public Button MinusBtn;
    public Button MultiBtn;

    public GameObject GetReadyPanel;
    public Button ReadyBtn;
    
    // Start is called before the first frame update
    void Awake(){
        ui = this;
    }
    void Start()
    {
        StartPanel.SetActive(true);
        StartBtn.onClick.AddListener(StartPanelDeActivate);
        ReadyBtn.onClick.AddListener(GetReadyPanelDeActivate);
        RestartBtn.onClick.AddListener(GameOverPanelDeActivate);
        PlusBtn.onClick.AddListener(SetQtypetoPlus);
        MinusBtn.onClick.AddListener(SetQtypetoMinus);
        MultiBtn.onClick.AddListener(SetQtypetoMultiply);
        
    }

    // Update is called once per frame
    void Update()
    {
        pointText.text = GameManager.GM.point.ToString();
    }

    public void StartPanelDeActivate(){
        PanelActive(StartPanel, false);
        GetReadyPanelActivate();
    }
    public void GetReadyPanelActivate(){
        PanelActive(GetReadyPanel, true);
        GameManager.GM.GameReady();
    }
    public void GetReadyPanelDeActivate(){
        PanelActive(GetReadyPanel,false);
        GameManager.GM.GameStart();
    }
    public void GameOverPanelActivate(){
        PanelActive(GameOverPanel,true);
        MaxScoreText.text = GameManager.GM.maxPoint.ToString();
        CurScoreText.text = GameManager.GM.point.ToString();
    }
    public void GameOverPanelDeActivate(){
        PanelActive(GameOverPanel,false);
        GetReadyPanelActivate();
    }

    public void SetQtypetoPlus(){
        GameManager.GM.qtype = 0;
    }
    public void SetQtypetoMultiply(){
        GameManager.GM.qtype = 1;
    }
    public void SetQtypetoMinus(){
        GameManager.GM.qtype = 2;
    }
    public void PanelActive(GameObject panel, bool par){
        if(par){
            panel.SetActive(true);
            return;
        }
        else{
            panel.SetActive(false);
            return;
        }
    }
}
