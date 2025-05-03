using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LaserAttack : MonoBehaviour
{
    public Vector2 boxSize;
    public int Damage;
    public float KnockbackPower;

    public bool Player = false;
    public string Ltarget;


    void Start(){
        Ltarget = (Player) ? "Enemy" : "Player";
    }

    void FixedUpdate()
    {
        Collider2D[] collider2Ds = Physics2D.OverlapBoxAll(transform.position,boxSize,0);
        foreach (Collider2D collider in collider2Ds)
        {
            if(collider.tag == Ltarget){
                collider.GetComponent<BattleBehaviour>().GetDamaged(Damage,KnockbackPower, transform, true,(!Player),true,(!Player));
            }
        }
    }

    private void OnDrawGizmos() {
        Gizmos.color = Color.blue;
        Gizmos.DrawWireCube(transform.position, boxSize);
    }
}
