using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class button_sound : MonoBehaviour
{
    public AudioClip clickSound;
    AudioSource audioSource;
    
    public void Button_clicked_sound(){
        audioSource.clip = clickSound;
        audioSource.Play();
    }
    
    void Start()
    {
        this.audioSource = GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
