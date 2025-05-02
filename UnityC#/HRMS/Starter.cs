using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;


public class Starter : MonoBehaviour
{


    public float startTime;
    // Start is called before the first frame update
    void Start()
    {
        SetDefaultDatafolders();
        Invoke("LetsGo", startTime);
    }

    void SetDefaultDatafolders(){
        if(!Directory.Exists(Application.persistentDataPath+"/Database")){
            Directory.CreateDirectory(Application.persistentDataPath+"/Database");
            Directory.CreateDirectory(Application.persistentDataPath+"/Database/Projects");
            Directory.CreateDirectory(Application.persistentDataPath+"/Database/ActivityHistories");
            Directory.CreateDirectory(Application.persistentDataPath+"/Database/Employees");
            Directory.CreateDirectory(Application.persistentDataPath+"/Database/Departments");
            ProjectDBSelector.pdb.TestSaving();
            ProjectDBSelector.pdb.TestLoading();
        }
    }

    void LetsGo(){
        LoadManager.lm.MoveScene("HomeScene");
    }
}
