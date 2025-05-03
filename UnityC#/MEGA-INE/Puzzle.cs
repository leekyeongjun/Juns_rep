using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Puzzle : MonoBehaviour
{

    public GameObject Key;
    public Transform Target;

    public bool active = false;
    public bool OnDissapearing = false;

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(active){
            StartCoroutine(WallsDissapear());
        }
    }

    public IEnumerator WallsDissapear(){
        if(!OnDissapearing){
            OnDissapearing = true;
            foreach (Transform wall in Target){
                wall.gameObject.GetComponent<Animator>().SetTrigger("Activated");
                yield return new WaitForSeconds(0.2f);
            }
            Destroy(Target.gameObject);
        }
    }
}
