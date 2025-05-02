using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Loader : MonoBehaviour
{
    string TargetScene;
    public bool isPc = false;
    public static Loader LM;

    // Start is called before the first frame update

    private void Awake()
    {
        if (LM == null)
        {
            LM = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }

    public void MoveScene(string targetScene){
        TargetScene = targetScene;
        if(isPc == true) TargetScene += "_Land";
        SceneManager.LoadScene(TargetScene);
    }
}
