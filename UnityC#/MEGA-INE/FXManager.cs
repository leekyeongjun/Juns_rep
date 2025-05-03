using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FXManager : MonoBehaviour
{
    public static FXManager fx;

    public AudioClip clickSound;
    public AudioClip BossSiren;
    public AudioClip SelectSound;
    public AudioClip DenySound;

    public AudioClip ShieldOnSound;

    public AudioClip ClearSound;
    public AudioClip WeaponUnlockSound;
    public AudioClip GameOverSound;

    private AudioSource audioSource;

    private void Awake() {
        DontDestroyOnLoad(gameObject);
        fx = this;
    }

    private void Start() {
        audioSource = GetComponent<AudioSource>();
    }

    public void PlayClickSound(){
        audioSource.volume = 0.2f;
        audioSource.clip = clickSound;
        audioSource.Play();
    }
    public void PlaySelectSound(){
        audioSource.volume = 0.2f;
        audioSource.clip = SelectSound;
        audioSource.Play();
    }
    public void PlayBossSiren(){
        audioSource.volume = 0.05f;
        audioSource.clip = BossSiren;
        audioSource.Play();
    }

    public void PlayClearSound(){
        audioSource.volume = 0.2f;
        audioSource.clip = ClearSound;
        audioSource.Play();
    }
    public void PlayWeaponUnlockSound(){
        audioSource.volume = 0.2f;
        audioSource.clip = WeaponUnlockSound;
        audioSource.Play();
    }
        
    public void PlayGameOverSound(){
        audioSource.volume = 0.2f;
        audioSource.clip = GameOverSound;
        audioSource.Play();
    }
    public void PlayDenySound(){
        audioSource.volume = 0.2f;
        audioSource.clip = DenySound;
        audioSource.Play();
    }
    public void PlaySheildOnSound(){
        audioSource.volume = 0.5f;
        audioSource.clip = ShieldOnSound;
        audioSource.Play();
    }

    public void StopFXDirectly(){
        audioSource.volume = 0;
    }
}
