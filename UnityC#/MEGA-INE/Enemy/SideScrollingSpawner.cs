using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;

[System.Serializable]
public class MobArray{
    public List<GameObject> Mob;
}

public class SideScrollingSpawner : MonoBehaviour
{
    public MobArray[] Waves;

    public List<GameObject> CurMobs = new List<GameObject>();
    public GameObject Portal;
    public int WaveID = 0;

    public float TimeBetweenWaves;
    public Transform[] SpawnPoint;
    public bool CanSpawn = true;

    public int[] indexs = {0,1,2,3,4,5,6,7};

    private void Start() {
        StartCoroutine(SpawnMobs());
    }
    private void Update() {
        if(Player.player.Died == true) CanSpawn = false; 
        else CanSpawn = true;
    }

    public IEnumerator SpawnMobs(){
        foreach(MobArray wave in Waves)
            {
                Debug.Log("Spawn!");
                var shuffledIndex = indexs.OrderBy(a => Guid.NewGuid()).ToList();
                Debug.Log(wave.Mob.Count.ToString() + "mobs appear!");

                for(int i = 0; i<wave.Mob.Count; i++){
                    Debug.Log(shuffledIndex[i].ToString());
                }
                while(CanSpawn == false){
                    yield return null;
                }
                for(int i = 0; i<wave.Mob.Count; i++){
                    if(wave.Mob[i] != null && SpawnPoint[indexs[i]]!= null){
                        GameObject m = Instantiate(wave.Mob[i], SpawnPoint[indexs[i]].position, Quaternion.identity);
                        CurMobs.Add(m);
                    }
                }
                yield return new WaitForSeconds(TimeBetweenWaves);
                WaveID++;
            }
        }

}
