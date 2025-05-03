using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CircularObstacle : MonoBehaviour
{

    public bool clockwise = false;
    public float speed;
    public float radius;
    private float degree;

    public Transform anchor;

    public GameObject obstacle;

    private void Update() {
        if(clockwise) ClockMove();
        else R_ClockMove();   
    }

    private void OnDrawGizmos() {
        Gizmos.DrawWireSphere(anchor.position, radius);
    }

    private void R_ClockMove(){
        degree += Time.deltaTime * speed;
        if(degree < 360){
            var rad = Mathf.Deg2Rad * (degree);
            var x = radius * Mathf.Sin(rad);
            var y = radius * Mathf.Cos(rad);

            obstacle.transform.position = anchor.position + new Vector3(x,y);
        }
        else{
            degree = 0;
        }
    }

    private void ClockMove(){
        degree -= Time.deltaTime * speed;
        if(degree > -360){
            var rad = Mathf.Deg2Rad * (degree);
            var x = radius * Mathf.Sin(rad);
            var y = radius * Mathf.Cos(rad);

            obstacle.transform.position = anchor.position + new Vector3(x,y);
        }
        else{
            degree = 0;
        }
    }

}
