using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using TMPro;

public class LoginManager : MonoBehaviour
{
    // Start is called before the first frame update

    public TMP_InputField inputField_ID;
    public TMP_InputField inputField_PW;
    public Button Button_login;
    Employee target;
    public GameObject ErrorPanel;
    GameObject sortlayer;

    public bool isLoginning = false;


    void Start(){
        sortlayer = GameObject.FindGameObjectWithTag("MiniPanelSortLayer");
        ProjectDBSelector.pdb.SetEmployeeDB();
    }
    public void LoginButtonClicked(){
        CheckValidity();
    }

    public void CheckValidity(){
        //Debug.Log("Checking!");
        isLoginning = true;
        
        foreach(Employee e in DBManager.db.Employees){
            if(inputField_ID.text == e.SysID)
            target = e;
        }
        if(target!=null){
            if(inputField_PW.text == target.SysPw){
                AccountManager.am.SetMyData(target);
                LoadManager.lm.MoveScene("HomeScene");
                //Debug.Log("Logged in!");
            }
            else{
                GameObject er = Instantiate(ErrorPanel, sortlayer.transform, false);
                GameObject errmsg = GameObject.FindGameObjectWithTag("ErrorMsg");
                errmsg.GetComponent<TextMeshProUGUI>().text = "비밀번호가 틀렸습니다.";
            }
        }
        else{
            GameObject er = Instantiate(ErrorPanel, sortlayer.transform, false);
            GameObject errmsg = GameObject.FindGameObjectWithTag("ErrorMsg");
            errmsg.GetComponent<TextMeshProUGUI>().text = "해당 ID의 임직원 데이터가 없습니다.";
        }
        isLoginning = false;
    }

}
