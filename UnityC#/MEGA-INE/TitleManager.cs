using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class TitleManager : MonoBehaviour
{
    public GameObject TitleMenu;
    private bool TitleOn = false;

    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Space)){
            if(TitleOn == false){
                FXManager.fx.PlaySelectSound();
                TitleMenu.SetActive(true);
                TitleOn = true;
            }
        }
    }
}
