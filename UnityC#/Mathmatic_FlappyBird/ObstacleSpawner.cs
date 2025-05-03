using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObstacleSpawner : MonoBehaviour
{
    public GameObject Obstacle;
    public List<GameObject> Obstacles = new List<GameObject>();
    public bool creatable = true;
    public float createTime = 4f;
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(GameManager.GM.onGame){
            StartCoroutine(CreateOb());
        }
        else{
            StopAllCoroutines();
        }
    }

    public IEnumerator CreateOb(){
        if(creatable){
            Vector3 createVec = new Vector3(transform.position.x, transform.position.y + Random.Range(-1.3f,1.4f), transform.position.z);
            GameObject ob = Instantiate(Obstacle, createVec, Quaternion.identity);
            Obstacles.Add(ob);
            creatable = false;
            yield return new WaitForSecondsRealtime(createTime);
            creatable = true;
        }
    }

    public void DeleteOb(){
        foreach(GameObject ob in Obstacles){
            Destroy(ob);
        }
        creatable = true;
    }
}
