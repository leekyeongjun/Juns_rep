using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cam : MonoBehaviour
{
    // Start is called before the first frame update

    public static Cam cam;

    void Awake() {
        if(cam == null) cam = this;
        else if (cam != this) Destroy(gameObject);
        DontDestroyOnLoad(gameObject);  
    }
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
