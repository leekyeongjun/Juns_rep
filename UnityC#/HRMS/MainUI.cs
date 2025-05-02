using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;
using Unity.VisualScripting.Dependencies.Sqlite;

public class MainUI : MonoBehaviour
{

    private Canvas mainCanvas;
    private CanvasScaler mainCanvasScaler;
    public GameObject LoadingPanel;
    public GameObject MypageBtn;
    public GameObject LogoutBtn;
    public GameObject LoginBtn;


    // Start is called before the first frame update
    void Awake(){
        LoginUIChange();
    }
    void Start()
    {
        mainCanvas = GetComponent<Canvas>();
        mainCanvasScaler = GetComponent<CanvasScaler>();
        mainCanvas.worldCamera = UIManager.ui.cam;

        
    }

    // Update is called once per frame
    void Update()
    {
        if(LoadingPanel != null) {
            LoadingPanel.SetActive(LoadManager.lm.isSceneLoading || ProjectDBSelector.pdb.isLoadingDB);

        }
    }

    void LoginUIChange(){
        if(!(MypageBtn && LogoutBtn && LoginBtn)){
            return;
        } 
        if(AccountManager.am.loggedIn == true){
            //Debug.Log("isLoggedIn!");
            MypageBtn.SetActive(true);
            LoginBtn.SetActive(false);
            LogoutBtn.SetActive(true);
        }
        else{
            MypageBtn.SetActive(false);
            LoginBtn.SetActive(true);
            LogoutBtn.SetActive(false);
        }
    }
}
