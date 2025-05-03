using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class TheStart : MonoBehaviour
{
    private void Start() {
        Invoke("LetsStart", 5.5f);
    }
    public void LetsStart(){
        SceneManager.LoadScene("TitleScreen");
    }


}
