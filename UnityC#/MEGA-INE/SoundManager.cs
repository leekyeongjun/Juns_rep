using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using UnityEngine.Audio;
using UnityEngine.UI;

public class SoundManager : MonoBehaviour
{

    public static SoundManager SM;

    public AudioMixer masterMixer;
    public Slider audioSlider_BGM;

    
    public Slider audioSlider_FX;
    public Slider audioSlider_Master;

    public float Master_volume_Buffer;

    void Awake(){
        if(SM == null){
            DontDestroyOnLoad(gameObject);
            SM = this;
        }
        else{
            Destroy(gameObject);
        }
    }


    public void AudioControl_BGM(){
        float sound = audioSlider_BGM.value;

        if(sound == -40f) masterMixer.SetFloat("BGM", -80);
        else masterMixer.SetFloat("BGM", sound);
    }

    public void AudioControl_FX(){
        float sound = audioSlider_FX.value;

        if(sound == -40f) masterMixer.SetFloat("FX", -80);
        else masterMixer.SetFloat("FX", sound);
    }

    public void AudioControl_Master(){
        float sound = audioSlider_Master.value;
        
        if(sound == -40f) masterMixer.SetFloat("Master", -80);
        else masterMixer.SetFloat("Master", sound);
    }

    public void SoundOFF(){
        Master_volume_Buffer = audioSlider_Master.value;
        Debug.Log("Sound Off, Current Master Buffer is " + Master_volume_Buffer.ToString());
        masterMixer.SetFloat("Master", -80);
    }

    public void SoundOn(){
        Debug.Log("Sound On, Previous Master Buffer is " +  Master_volume_Buffer.ToString());
        masterMixer.SetFloat("Master", Master_volume_Buffer);
    }
}
