using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class UIManager : MonoBehaviour
{
    public Camera cam;
    public TMP_FontAsset mainfont;

    public static UIManager ui;


    void Awake(){
        if(ui == null) ui = this;
        else if (ui != this) Destroy(gameObject);
        DontDestroyOnLoad(gameObject);  
        cam = Cam.cam.GetComponent<Camera>();
        
    }

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        
    }

}
