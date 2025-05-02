using System.Collections;
using System.Collections.Generic;
using JetBrains.Annotations;
using UnityEngine;

public class Land : MonoBehaviour
{
    
    public List<List<Transform>> landGrid;
    public bool[,] emptyLand;
    public GameObject landPrefab;
    public int xMax;
    public int yMax;
    void Start(){

    }

    public bool InitLandGrid(int x, int y){
        xMax = x;
        yMax = y;
        emptyLand = new bool[yMax,xMax];
        for(int i = 0; i<yMax; i++){
            for(int j = 0; j<xMax; j++){
                emptyLand[j,i] = false;
            }
        }
        float offsetX = 5;
        float offsetY = 5;

        landGrid = new List<List<Transform>>();

        for(int i = 0; i<y; i++){
            List<Transform> tmpList = new List<Transform>();
            for(int j = 0; j < x; j++){
                Vector3 spawnPos = new Vector3(
                    transform.position.x+(offsetX*j),
                    0, 
                    transform.position.z + (offsetY*i)
                );
                GameObject l = Instantiate(landPrefab, spawnPos, landPrefab.transform.rotation);
                l.transform.parent = transform;
                l.name = "(" +j + "," + i + ")";
                
                tmpList.Add(l.transform);
            }
            landGrid.Add(tmpList);
        }


        foreach(List<Transform>t in landGrid){
            string line = "";
            foreach(Transform land in t){
                line += land.name + " ";
            }
           
        }
        return true;
    }

    public Transform At(int x, int y){
        int posX = x, posY = y;

        if(x >= xMax) posX = xMax;
        if(x < 0)posX = 0;
        if(y >= yMax) posY = yMax;
        if(y < 0)posY = 0;
        //Debug.Log(landGrid[posY][posX].gameObject.name);
        return landGrid[posY][posX];
    }

    public void ResetGrid(List<Vector2> list){
        emptyLand = new bool[yMax,xMax];
        foreach(Vector2 pos in list){
            emptyLand[(int)pos.y,(int)pos.x] = true;
        }
    }
}
