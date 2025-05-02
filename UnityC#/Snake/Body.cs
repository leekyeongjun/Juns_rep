using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class Body : MonoBehaviour
{
    public Vector2 current;
    public Vector2 next;
    Land landScript;
    void Start(){
        landScript = GameObject.FindWithTag("Land").GetComponent<Land>();
    }
    public void SetCurrent(float x, float y){
        current = new Vector2(x, y);
    }

    public void Move(){
        if(next != null){
            transform.position = landScript.At((int)next.x, (int)next.y).position;
            current = next;
        }
    }

    
    
}
