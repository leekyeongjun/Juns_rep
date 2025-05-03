using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BossSpawnTrigger : MonoBehaviour
{
    public BossSpawner bossspawner;
    public string BossName;
    public Sprite BossPort;
    public GameObject Wall;
    public bool activated = false;
    public GameObject Disabler;

    public bool CamPosSet = false;
    public Transform targetPos;

    private void Awake() {
        bossspawner = GetComponent<BossSpawner>();
    }

    private void Start(){
    }

    private void OnTriggerEnter2D(Collider2D collision) {
        if(activated == false){
            if(collision.transform.CompareTag("Player")){
                Debug.Log("spawn!");
                if(Wall!=null) Wall.SetActive(true);
                if(Disabler != null) Disabler.SetActive(false);
                if(CamPosSet){
                    CameraController.cam.SetOriginalPos(targetPos);
                    CameraController.cam.ChasingMC = false;
                }
                StartCoroutine(bossspawner.BossSpawnCutScene());
                activated = true;
            }
        }
    }

    public void ResetTrigger(){
        activated = false;
        if(CamPosSet){
            CameraController.cam.ChasingMC = true;
        }
        if(Wall!=null) Wall.SetActive(false);
    }
}
