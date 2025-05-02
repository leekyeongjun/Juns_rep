using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class Buttons : MonoBehaviour
{

    public bool Screen_Create_Btn;
    public bool Move_Scene_Btn;
    public bool logout_Btn;

    public bool WebLink_Btn;

    public bool LoginNecessary;

    public List<GameObject> uiPrefabs;
    public Vector3 instoffset;
    private GameObject sortlayer;

    LoadManager load;
    public string Dest;

    public string URL;
    public GameObject ErrorPanel;

    // Start is called before the first frame update
    void Start()
    {
        sortlayer = GameObject.FindWithTag("MiniPanelSortLayer");
        load = LoadManager.lm;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void OnButtonClick(){
        if(LoginNecessary){
            if(!AccountManager.am.loggedIn){
                string e = "로그인 후 이용하세요.";
                GameObject err = Instantiate(ErrorPanel, sortlayer.transform, false);
                GameObject errmsg = GameObject.FindGameObjectWithTag("ErrorMsg");
                errmsg.GetComponent<TextMeshProUGUI>().text = e;
                return;
            }

        }
        if(Screen_Create_Btn){
            Debug.Log("Created");
            Transform instTransform = sortlayer.transform;
            Vector3 instvec = instTransform.position;

            foreach(GameObject uiprefab in uiPrefabs){
                Instantiate(uiprefab, instvec, Quaternion.identity, instTransform);
                instvec = new Vector3(instvec.x + instoffset.x, instvec.y+ instoffset.y, instvec.z);
            }
        }
        if(Move_Scene_Btn){
            load.MoveScene(Dest);
        }
        if(logout_Btn){
            AccountManager.am.DisposalMydata();
            load.MoveScene("HomeScene");
        }
        if(WebLink_Btn){
            Application.OpenURL(URL);
        }
    }
}
