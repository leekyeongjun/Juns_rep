using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class startscreen : MonoBehaviour
{
    public AudioClip clickSound;
    AudioSource audioSource;
    
    void Play_sound(){
        audioSource.clip = clickSound;
        audioSource.Play();
    }

    public void Button_clicked_sound()
    {
        Play_sound();
    }
    
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
