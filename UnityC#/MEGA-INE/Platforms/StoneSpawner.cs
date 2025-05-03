using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StoneSpawner : MonoBehaviour
{
    public GameObject Stone;
    public float SpawnCooltime;
    public Transform SpawnPoint;

    public bool canSpawn = true;

    void Update()
    {
        StartCoroutine(SpawnStone());
    }

    public IEnumerator SpawnStone(){
        if(canSpawn){
            canSpawn = false;
            Instantiate(Stone, SpawnPoint.position, Stone.transform.rotation);
            yield return new WaitForSeconds(SpawnCooltime);
            canSpawn = true;
        }

    }
}
