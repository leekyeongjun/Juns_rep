using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SceneMoveBtnNotinHome : MonoBehaviour
{
    // Start is called before the first frame update
    public void Go_Scene(string sceneName){
        Loader.LM.MoveScene(sceneName);
    }
}
