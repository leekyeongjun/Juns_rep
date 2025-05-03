using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Loader : MonoBehaviour
{

    public static Loader loader;
    public string SceneName;

    private void Awake() {
        if(loader != null){
            Destroy(gameObject);
            return;
        }
        loader = this;
        DontDestroyOnLoad(gameObject);
    }
    public void SetNextScene(string sceneName){
        SceneName = sceneName;
    }

}
