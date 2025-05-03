using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StageStarter : MonoBehaviour
{
    public bool IsFlying = false;
    public bool IsFixedDirection = false;
    public bool chasingmc = true;
    public float camerasize = 7f;

    public Vector2 minboundary;
    public Vector2 maxboundary;

    public bool Starter = true;
    public bool Continuer = false;

    public string ISDname;
    public string stageName;
    public bool PanelOn = false;

    // Start is called before the first frame update

    void Awake(){
    }
    void Start()
    {
        SoundManager.SM.SoundOn();
        
        if(Starter){
            GameManager.GM.StageEnter(IsFlying, IsFixedDirection, chasingmc, camerasize, minboundary, maxboundary);
            Debug.Log("Start Stage");
            if(PanelOn){
                StartPanelOn();
            }
        }
        if(Continuer){
            GameManager.GM.StageContinue(IsFlying, IsFixedDirection, chasingmc, camerasize, minboundary, maxboundary);
            Debug.Log("Start Stage");
        }

    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void StartPanelOn(){
        UserInterFace.ui.StageName.text = stageName;
        UserInterFace.ui.ISDName.text = ISDname;
        UserInterFace.ui.StageStartPanel.GetComponent<Animator>().SetBool("StageStart", true);   
    }
}
