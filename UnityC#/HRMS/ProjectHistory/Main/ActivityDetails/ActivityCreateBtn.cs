using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;

public class ActivityCreateBtn : MonoBehaviour
{
    private GameObject sortlayer;
    public GameObject ActivityCreatorPanelPrefab;

    int pid,tid;
    void Start()
    {
        sortlayer = GameObject.FindWithTag("MiniPanelSortLayer");
    }

    // Update is called once per frame
    public void OnButtonClick(){
        GameObject p = Instantiate(ActivityCreatorPanelPrefab, sortlayer.transform, false);
        p.GetComponent<ActivityCreator>().StartActivityCreator(pid,tid,AccountManager.am.mydata.myemployeedata);
    }

    public void Setids(int _pid, int _tid){
        pid = _pid;
        tid = _tid;
    }
}
