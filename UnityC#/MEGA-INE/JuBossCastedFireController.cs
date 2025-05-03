using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JuBossCastedFireController : MonoBehaviour
{
    public List<Transform> FireBalls;

    private void Start(){
        foreach(Transform child in transform){
            FireBalls.Add(child);
        }
    }
    public void DisableFireBalls(){
        foreach(Transform fireball in FireBalls){
            if(fireball.gameObject.GetComponent<Animator>() != null){
                fireball.gameObject.GetComponent<Animator>().SetTrigger("Dissapear");
            }
        }
    }
}
