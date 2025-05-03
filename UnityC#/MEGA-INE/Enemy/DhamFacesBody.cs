using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DhamFacesBody : MonoBehaviour
{
    private Rigidbody2D rigid2D;
    private Animator anim;
    private BattleBehaviour battleBehaviour;
    private DhamBossAttack bossattack;
    [Space(3f)]
    [Header("적의 피격 범위")]
    
    public Vector2 boxSize;
    public Vector2 Offset;

    
    void Awake()
    {
        anim = GetComponent<Animator>();    
        rigid2D = GetComponent<Rigidbody2D>();
        battleBehaviour = GetComponent<BattleBehaviour>();
        bossattack = GetComponent<DhamBossAttack>();
        //movement2D = GetComponent<Movement2D>();
    }
    
    void FixedUpdate()
    {
        Collider2D[] collider2Ds = Physics2D.OverlapBoxAll(new Vector2(transform.position.x + Offset.x , transform.position.y + Offset.y), boxSize ,0);
        foreach (Collider2D collider in collider2Ds)
        {
            if(collider.tag == "Player"){
                collider.GetComponent<BattleBehaviour>().GetDamaged(battleBehaviour.meleeDamage, battleBehaviour.meleeknockbackPower, transform, true,true,true,true);
            }
        }
    }
    

    void Start()
    {
        //Invoke("PatternOn", 2f);
    }

    void Update()
    {
        if(battleBehaviour.DhamMinionDied == true){
            StopAllCoroutines();
        }
        
    }

    private void OnDrawGizmos() {
        Gizmos.color = Color.blue;
        Gizmos.DrawWireCube(new Vector2(transform.position.x + Offset.x , transform.position.y + Offset.y), boxSize);
    }

}
