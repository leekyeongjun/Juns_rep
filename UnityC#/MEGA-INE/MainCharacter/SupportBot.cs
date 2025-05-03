using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SupportBot : MonoBehaviour
{
    public Transform LaserPosition;
    public Transform Emitposition;
    public GameObject Laser;
    public Animator anim;

    public GameObject DestroyFX;
    public GameObject LaserEmmitingFX;

    public GameObject CurLaser;
    public GameObject CurLaserEFX;

    void Start()
    {
        anim = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void LaserShoot(){
        anim.SetTrigger("LaserOn");
        CurLaser = Instantiate(Laser, LaserPosition.position, LaserPosition.rotation);
        CurLaserEFX = Instantiate(LaserEmmitingFX, Emitposition.position, LaserEmmitingFX.transform.rotation);
        
    }

    public void LaserOffTriggerOn(){
        
        anim.SetTrigger("LaserOff");
        for(int i = 0; i<Laser.transform.childCount; i++){
            CurLaser.transform.GetChild(i).GetComponent<Animator>().SetTrigger("LaserOff");
        }
        Destroy(CurLaserEFX);
    }

    public void LaserDestroy(){

        Instantiate(DestroyFX, transform.position, DestroyFX.transform.rotation);
        Destroy(CurLaser);
        CurLaser = null;
    }
}
