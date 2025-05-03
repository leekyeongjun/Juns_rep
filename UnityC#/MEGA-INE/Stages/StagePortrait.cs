using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class StagePortrait : MonoBehaviour
{
    public Sprite idle;
    public Sprite Chosen;
    public GameObject ClearedSign;
    public bool oncursor = false;

    
    private void Update() {
        if(ClearedSign.activeSelf==true) return;
        if(oncursor){
            gameObject.GetComponent<Image>().sprite = Chosen;
        }
        else{
            gameObject.GetComponent<Image>().sprite = idle;
        }
    }

    public void OnCursor(){
        oncursor = true;
    }

    public void OutCursor(){
        oncursor = false;
    }

    public void OnCleared(){
        ClearedSign.SetActive(true);
    }
}
