using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadManager : MonoBehaviour
{

    public static LoadManager lm;

    public string targetScene;

    string nextScene;
    public bool isSceneLoading;

    void Awake() {
        if(lm == null) lm = this;
        else if (lm != this) Destroy(gameObject);
        DontDestroyOnLoad(gameObject);      
    }
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void MoveScene(string sceneName){
        StartCoroutine(LoadScene(sceneName));
        //SceneManager.LoadScene(sceneName);
    }

    public void MoveSceneWithLoad(string sceneName){
        targetScene = sceneName;
        SceneManager.LoadScene("LoadScene");
    }
    IEnumerator LoadScene(string sceneName){
        yield return null;
     
        AsyncOperation op = SceneManager.LoadSceneAsync(sceneName);
        op.allowSceneActivation = false;
        isSceneLoading = true;
        while(!op.isDone){
            yield return null;
            if(op.progress <0.9f){
                
                Debug.Log("Onload");
            }
            else{
                yield return new WaitForSeconds(.5f);
                isSceneLoading = false;
                Debug.Log("loadDone");
                op.allowSceneActivation = true;
                yield break;
            }
        }

    }
}
