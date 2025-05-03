using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class LoadingSceneManager : MonoBehaviour
{
    public string nextScene;
    public static LoadingSceneManager Load;
    public Text Tip;

    [Multiline] 
    public string[] Tips;
    

    private void Start() {
        StartCoroutine(UserInterFace.ui.CloseLoadingPanel());
        SetTip();
        SetNextScene();
        StartCoroutine(LoadAsyncSceneCoroutine());
    }

    public void SetNextScene(){
        nextScene = Loader.loader.SceneName;
    }

    public IEnumerator LoadAsyncSceneCoroutine(){
        float curtime = 0f;
        AsyncOperation operation = SceneManager.LoadSceneAsync(nextScene);
        operation.allowSceneActivation = false;
        
        while (!operation.isDone) {
            curtime =+ Time.timeSinceLevelLoad;
            if(curtime > 3) {
                UserInterFace.ui.OpenLoadingPanel();
                yield return new WaitForSeconds(.5f);
                operation.allowSceneActivation = true;
                StartCoroutine(UserInterFace.ui.CloseLoadingPanel());
            }
            yield return null;
        }

    }

    public void SetTip(){
        int id = Random.Range(0,23);
        Tip.text = Tips[id];
    }


      
}
