using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Obstacle : MonoBehaviour
{

    public int damage;
    public float knockbackpower;

    public float radius;

    void Start()
    {
        
    }

    void Update()
    {
        
        Collider2D[] collider2Ds= Physics2D.OverlapCircleAll(transform.position,radius);

        foreach (Collider2D collider in collider2Ds)
        {
            if(collider.tag == "Player"){
                collider.GetComponent<BattleBehaviour>().GetDamaged(damage, knockbackpower, transform, true,true,true,true);
            }
        }
    }

    private void OnDrawGizmos() {
        Gizmos.DrawWireSphere(transform.position, radius);
    }
}
