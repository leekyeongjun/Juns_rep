using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class Signup : MonoBehaviour
{
    public GameObject signupPanel;
    public GameObject errortext;
    public TMP_InputField codefield;

    private bool isSignedUp = false;

    void Start(){
        LoadSignupData();
        SignupPanelOn();
    }
    public void LoadSignupData(){
        int s = PlayerPrefs.GetInt("SignedUp");
        if(s == 0){
            isSignedUp = true;
        }
        else{isSignedUp = false;}
        
    }

    public void SignupPanelOn(){
        if(isSignedUp == false) signupPanel.SetActive(true);
        else signupPanel.SetActive(false);
    }

    public void TrySignUp(){
        string password;
        password = codefield.text;
        if(password == "Tataro123!"){
            PlayerPrefs.SetInt("SignedUp", 0);
            signupPanel.SetActive(false);
        }
        else{
            errortext.SetActive(true);
        }
    }
}
