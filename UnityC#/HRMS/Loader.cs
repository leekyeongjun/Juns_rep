using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
public class Loader : MonoBehaviour
{
    string nextScene;
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(LoadScene());
    }

    // Update is called once per frame
    IEnumerator LoadScene(){
        yield return null;
        nextScene = LoadManager.lm.targetScene;
        AsyncOperation op = SceneManager.LoadSceneAsync(nextScene);
        op.allowSceneActivation = false;
        while(!op.isDone){
            yield return null;
            if(op.progress <0.9f){
            }
            else{
                yield return new WaitForSeconds(1.5f);
                op.allowSceneActivation = true;
                yield break;
            }
        }

    }
}
