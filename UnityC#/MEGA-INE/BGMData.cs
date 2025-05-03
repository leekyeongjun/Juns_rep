using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BGMData : MonoBehaviour
{
    public AudioClip BGM;
    public bool BossScene = false;
    public float volume = 1f;

    void Start(){
        if(BGM != null) BGMManager.bgmManager.SetBGM(BGM, volume);
        if(!BossScene) StartCoroutine(BGMManager.bgmManager.StartBGM());
    }
}
