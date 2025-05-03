using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BGMManager : MonoBehaviour
{

    public static BGMManager bgmManager;

    private AudioClip Curbgm;
    private int volcounter = 5;
    public AudioSource audioSource;

    private void Awake() {
        bgmManager = this;
    }

    private void Start() {
        audioSource = GetComponent<AudioSource>();
    }

    public void SetBGM(AudioClip bgm, float vol){
        //Debug.Log("Set BGM!");
        Curbgm = bgm;
        audioSource.clip = Curbgm;
        audioSource.volume = vol;
        volcounter = (int)vol;
        audioSource.loop = true;
    }

    public IEnumerator StartBGM(){
        Debug.Log("Start BGM!");
        audioSource.volume = 0f;
        if(!audioSource.isPlaying){
            audioSource.Play();
            for(int i = 0; i<volcounter; i++){
                //Debug.Log("CurVolume = " + audioSource.volume.ToString());
                audioSource.volume += 0.1f;
                yield return new WaitForSeconds(.1f);
            }
        }
    }

    public IEnumerator StopBGM(){
        Debug.Log("Stop BGM!");
        for(int i = 0; i<volcounter; i++){
            audioSource.volume -= 0.1f;
            yield return new WaitForSeconds(.1f);
        }
        audioSource.Stop();
    }

    public void StopBGMDirectly(){
        Debug.Log("Stop BGM! directly!");
        audioSource.volume = 0;
    }
}
