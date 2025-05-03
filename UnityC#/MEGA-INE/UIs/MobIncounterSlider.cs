using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class MobIncounterSlider : MonoBehaviour
{
    public Slider s;
    public SideScrollingSpawner spawner;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(spawner){
            s.value = (float)spawner.WaveID/(float)spawner.Waves.Length;
        }
    }
}
