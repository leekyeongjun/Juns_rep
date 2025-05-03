using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JuDropObstacle : MonoBehaviour
{
    public GameObject Lava;
    public Transform LavaPos;
    public float DropCool;
    public bool CanDrop = true;

    private Animator anim;

    private void Awake() {
        anim = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        StartCoroutine(LavaDrop());
    }

    public IEnumerator LavaDrop(){
        if(CanDrop){
            CanDrop = false;
            anim.SetTrigger("Drop");
            yield return new WaitForSeconds(DropCool);
            CanDrop = true;

        }
    }

    public void SummonLava(){
        Instantiate(Lava, LavaPos.position, Lava.transform.rotation);
    }
}
