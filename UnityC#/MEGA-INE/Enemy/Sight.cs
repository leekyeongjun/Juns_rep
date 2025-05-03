using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sight : MonoBehaviour
{

    public SpriteRenderer SightSprite;
    public EnemyAttack enemyAttack;

    public Color IdleColor;
    public Color InsightColor;

    private void Awake() {
        enemyAttack = GetComponentInParent<EnemyAttack>();
    }

    private void OnTriggerStay2D(Collider2D collision) {
        if(collision.transform.CompareTag("Player")){
            enemyAttack.IsInSight = true;
            SightSprite.color = InsightColor;
        }
        if(collision.transform.CompareTag("SneakedPlayer")){
            enemyAttack.IsInSight = false;
            SightSprite.color = IdleColor;
        }
    }

    private void OnTriggerExit2D(Collider2D collision) {
        if(collision.transform.CompareTag("Player")){
            enemyAttack.IsInSight = false;
            SightSprite.color = IdleColor;
        } 
    }
}
