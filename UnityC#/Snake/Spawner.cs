using System.Collections;
using System.Collections.Generic;
using System.Linq.Expressions;
using UnityEngine;

public class Spawner : MonoBehaviour
{
    public GameObject bodyPrefab;
    public GameObject applePrefab;
    public Vector2 applePos;
    private GameObject curApple;
    Land landScript;

    void Start(){
        landScript = GameObject.FindWithTag("Land").GetComponent<Land>();
    }

    public void SpawnApple(){
        List<Vector2> coords = new List<Vector2>();
        for(int i = 0; i<landScript.yMax; i++){
            for(int j = 0; j <landScript.yMax; j++){
                if(landScript.emptyLand[j,i] == false){
                    coords.Add(new Vector2(i,j));
                }
            }
        }

        int rnd = Random.Range(0,coords.Count);
        Vector2 spawnCoord = coords[rnd];
        applePos = spawnCoord;
        GameObject apple = Instantiate(
            applePrefab,
            landScript.At((int) spawnCoord.x, (int) spawnCoord.y).position,
            applePrefab.transform.rotation
        );
        curApple = apple;
        landScript.emptyLand[(int) spawnCoord.x, (int) spawnCoord.y] = true;
    }

    public void RemoveApple(){
        Destroy(curApple);
        landScript.emptyLand[(int) applePos.x, (int) applePos.y] = false;
    }

    public Body SpawnBody(Vector2 spawnCoord){
        Body nb = Instantiate(
            bodyPrefab,
            landScript.At((int) spawnCoord.x, (int) spawnCoord.y).position,
            bodyPrefab.transform.rotation
        ).GetComponent<Body>();
        
        return nb;
    }



}
