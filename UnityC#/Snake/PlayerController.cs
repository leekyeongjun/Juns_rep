using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Android;

public class PlayerController : MonoBehaviour
{
    float moveSpeed = 0.05f;
    Body bodyScript;
    Spawner spawnerScript;
    public List<Body> bodies;
    Land landScript;
    float horizontalInput;
    float verticalInput;

    public bool xMod = true;
    public bool yMod = false;
    public bool addX = true;
    public bool addY = false;
    bool appleEaten = false;

    public Vector2 appleCoord;
    void Start(){
        landScript = GameObject.FindWithTag("Land").GetComponent<Land>();
        spawnerScript = GameObject.FindWithTag("Spawner").GetComponent<Spawner>();
        bodies = new List<Body>();
        bodyScript = GetComponent<Body>();
        landScript.InitLandGrid(20,20);
        bodies.Add(bodyScript);
        spawnerScript.SpawnApple();
        InvokeRepeating("PlayerAct", 1, moveSpeed);
    }
    void Update(){
        horizontalInput = Input.GetAxis("Horizontal");
        verticalInput = Input.GetAxis("Vertical");
        // 입력받기
        GetInput();
    }

    void GetInput(){
        if(horizontalInput > 0){xMod = true; yMod = false; addX = true;}
        if(horizontalInput < 0){xMod = true; yMod = false; addX = false;}
        if(verticalInput > 0){yMod = true; xMod = false; addY = true;}
        if(verticalInput < 0){yMod = true; xMod = false; addY = false;} 
    }

    void PlayerAct(){
        
        
        // 이동하기
        MoveAllBody();
        
        ResetEmptyGrid();
        // head 방향 정하기
        // body 방향 정하기
        
        // (apple 먹은 상태 아니면) spawn apple 하기
        // (apple 먹은 상태 && 현재 grid가 empty) Spawn body 하기
        CheckAppleEaten();
        SpawnThings();
        SetNextCoord();
    }

    void SetNextCoord(){
        Vector2 next = bodyScript.current;
        if(xMod == true && addX  == true && bodyScript.current.x+1 < landScript.xMax){next = new Vector2(bodyScript.current.x+1, bodyScript.current.y);}
        else if(xMod == true && addX == false && bodyScript.current.x-1 >= 0){next = new Vector2(bodyScript.current.x-1, bodyScript.current.y);}
        else if(yMod == true && addY  == true && bodyScript.current.y+1 < landScript.yMax){next = new Vector2(bodyScript.current.x, bodyScript.current.y+1);}
        else if(yMod == true && addY == false && bodyScript.current.y-1 >= 0){next = new Vector2(bodyScript.current.x, bodyScript.current.y-1);}
        int num = bodies.Count;
        bodies[0].next = next;
        for(int i = 0; i<num; i++){
            if(i+1 < num){
                bodies[i+1].next = bodies[i].current;
            }
        }
    }

    void MoveAllBody(){
        foreach(Body b in bodies){
            b.Move();
        }
    }

    void ResetEmptyGrid(){
        List<Vector2> bodyCoords = new List<Vector2>();
        foreach(Body b in bodies){
            bodyCoords.Add(b.current);
        }
        landScript.ResetGrid(bodyCoords);
    }

    void SpawnThings(){
        if(appleEaten == true){
            Debug.Log(appleCoord.ToString() + landScript.emptyLand[(int)appleCoord.y,(int)appleCoord.x]);
            if(landScript.emptyLand[(int)appleCoord.y,(int)appleCoord.x] == false){ 
                Debug.Log("Spawn Body!");
                Body nb = spawnerScript.SpawnBody(appleCoord);
                nb.current = appleCoord;
                nb.next = appleCoord;
                bodies.Add(nb);
                spawnerScript.SpawnApple();
                appleEaten = false;
            }
        }
           
        
    }

    void CheckAppleEaten(){
        if((int)bodies[0].current.x == (int)spawnerScript.applePos.x && 
            (int)bodies[0].current.y == (int)spawnerScript.applePos.y && appleEaten == false
        ){
            Debug.Log("appleeaten!");
            appleEaten = true;
            appleCoord = bodies[0].current;
            Debug.Log(appleCoord);
            spawnerScript.RemoveApple();
        }
    }
}
