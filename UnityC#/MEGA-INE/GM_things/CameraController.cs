using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public static CameraController cam;

    private Camera Cam;
    public float speed;
    public bool EshakeOn = false;
    Vector3 originalPos;
    public bool ChasingMC = true;

    public Vector2 minCamBoundary;
    public Vector2 maxCamBoundary;


    void Awake(){
        if(cam == null){
            DontDestroyOnLoad(gameObject);
            cam = this;
        }
        else{
            Destroy(gameObject);
        }
        originalPos = new Vector3(0,0,-1);
        Cam = transform.GetComponent<Camera>();
       
    }
    
    void Update(){
        if(ChasingMC){
            if(Player.player != null){
                originalPos = Player.player.transform.position;
            }
        }
        if(EshakeOn == true){
            StartCoroutine(EShake(0.015f));
        }
    }

    void LateUpdate() {
        if(ChasingMC){
            if(Player.player != null){
                Vector3 campos = new Vector3(Player.player.transform.position.x, Player.player.transform.position.y, -1) ;
                
                if(minCamBoundary != null && maxCamBoundary != null){
                    campos.x = Mathf.Clamp(campos.x, minCamBoundary.x, maxCamBoundary.x);
                    campos.y = Mathf.Clamp(campos.y, minCamBoundary.y, maxCamBoundary.y);
                }

                transform.position = Vector3.Lerp(transform.position, campos, Time.deltaTime*speed);
                transform.position = new Vector3(transform.position.x, transform.position.y, -1f);
             }
        }
        else{
            transform.position = Vector3.Lerp(transform.position, originalPos, Time.deltaTime*speed);
            transform.position = new Vector3(transform.position.x, transform.position.y, -1f); 
        }

    }
    public IEnumerator Shake(float duration, float magnitude){
        float elapsed = 0f;

        while(elapsed < duration){
            float x = Random.Range(-0.5f,0.5f)*magnitude+transform.position.x;
            float y = Random.Range(-0.5f,0.5f)*magnitude+transform.position.y;

            transform.position = new Vector3(x,y, originalPos.z);
            elapsed += Time.deltaTime;
            yield return null;
        }

    }

    public IEnumerator EShake(float magnitude){
        while(EshakeOn == true){
            float x = Random.Range(-0.5f,0.5f)*magnitude+transform.position.x;
            float y = Random.Range(-0.5f,0.5f)*magnitude+transform.position.y;

            transform.position = new Vector3(x,y, originalPos.z);
            yield return null;
        }
    }

    public void CamReset(bool chasingmc, float size, Vector2 minCBoundary, Vector2 maxCBoundary){
        ChasingMC = chasingmc;
        Cam.orthographicSize = size;
        originalPos = new Vector3(0,0,-1);
        transform.position = originalPos;
        minCamBoundary = minCBoundary;
        maxCamBoundary = maxCBoundary;
    }

    public void ShakeOn(){
        EshakeOn = true;
    }
    public void ShakeOff(){
        EshakeOn = false;
    }


    public void SetOriginalPos(Transform targetPos){
        originalPos = targetPos.position;
    }

    public IEnumerator ZoomOut(float duration, float amount){
        float elapsed = 0f;

        while(elapsed < duration){
            Cam.orthographicSize += Time.deltaTime * amount;
            elapsed += Time.deltaTime;
            yield return null;
        } 
    }
}
