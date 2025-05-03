using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class SideScrollingPlatformData{
    public GameObject Platform;
    public int SpawnPointID;
}

[System.Serializable]
public class PlatformArray{
    public List<SideScrollingPlatformData> Platforms;
}

public class SideScrollingPlatformSpawner : MonoBehaviour
{
    public PlatformArray[] Waves;

    public int WaveID = 0;
    public float TimeBetweenWaves;
    public Transform[] SpawnPoint;

    public bool CanSpawn = true;
    
    void Update()
    {
        if(Player.player.Died == false) StartCoroutine(SpawnPlatforms());
    }

    public IEnumerator SpawnPlatforms(){
        if(CanSpawn){
            if(WaveID < Waves.Length){
                Debug.Log("Spawn Platform!");
                CanSpawn = false;

                foreach(SideScrollingPlatformData platformData in Waves[WaveID].Platforms){

                    int rid = platformData.SpawnPointID;
                    if(platformData.Platform != null){
                        GameObject P = Instantiate(platformData.Platform, SpawnPoint[rid].position, Quaternion.identity);
                    } 
                }
                yield return new WaitForSeconds(TimeBetweenWaves);
                WaveID++;
                CanSpawn = true;
            }

        }

    }
}
