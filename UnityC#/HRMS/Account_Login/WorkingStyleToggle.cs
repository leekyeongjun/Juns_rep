using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;
using Unity.VisualScripting;

public class WorkingStyleToggle : MonoBehaviour
{
    public Toggle toggle;

    public string Keyword;
    public TextMeshProUGUI Keywordtext;
    public TMP_InputField KeywordInputfield;

    public SignupManager sm;
    public MypageEditor me;
    public bool isCustom = false;

    public void Start() {
        FindParent();
    }

    public void SetToggleData(bool On, string word){
        if(isCustom == false){
            toggle.isOn = On;
            Keyword = word;
            Keywordtext.text = Keyword;
        }
        else{
            toggle.isOn = On;
            Keyword = word;
            KeywordInputfield.gameObject.SetActive(false);
            Keywordtext.gameObject.SetActive(true);
            Keywordtext.text = Keyword;
        }
    }

    public string ReturnKeyWord(){
        return Keyword;
    }

    public void CustomInputfieldOn(){
        if(toggle.isOn){
            if(KeywordInputfield.IsActive()){
                KeywordInputfield.interactable = true;
            }
        }
    }


    public void EndEdittingCustomWorkstyle(){
        if(KeywordInputfield.text == "") return;
        Keyword = KeywordInputfield.text; 
        Keywordtext.gameObject.SetActive(true);
        Keywordtext.text = Keyword;

        if(sm != null){
            //sm.InstantiateCustomToggle(transform.parent);
        }
        else if(me != null){
            //me.InstantiateCustomToggle(transform.parent);
        }
        KeywordInputfield.gameObject.SetActive(false);
    }

    public void FindParent(){
        if(isCustom){
            if(GameObject.FindGameObjectWithTag("SignUpManager") != null){
                sm = GameObject.FindGameObjectWithTag("SignUpManager").GetComponent<SignupManager>();
                Debug.Log("Found");
            }
            else if(GameObject.FindGameObjectWithTag("MypageEditor") != null){
                me = GameObject.FindGameObjectWithTag("MypageEditor").GetComponent<MypageEditor>();
            }
        }
    }



}
