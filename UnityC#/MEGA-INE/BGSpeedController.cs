using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BGSpeedController : MonoBehaviour
{
    public BossSpawnTrigger bt;
    public SideShooterBG bg;
    
    public float targetSpeed = 0.5f;
    // Start is called before the first frame update
    void Start()
    {
        bt = GetComponent<BossSpawnTrigger>();
    }

    // Update is called once per frame
    void Update()
    {
        if(bt.activated){
            bg.scrollSpeed = targetSpeed;
        }
        else bg.scrollSpeed = 0f;
    }
}
