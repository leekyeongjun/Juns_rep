using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TaskCreateBtn : MonoBehaviour
{

    public GameObject TaskCreator;

    GameObject sortlayer;

    int pid;

    // Start is called before the first frame update
    void Start()
    {
        sortlayer = GameObject.FindGameObjectWithTag("MiniPanelSortLayer");
    }

    public void OnButtonClick(){
        GameObject T = Instantiate(TaskCreator, sortlayer.transform, false);
        T.GetComponent<TaskCreator>().setpid(pid);
    }

    public void setpid(int _pid){
        pid = _pid;
    }

}
