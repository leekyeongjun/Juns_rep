using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UGS;

public class ScrollviewElements : MonoBehaviour
{

    public GameObject contentArea;
    public GameObject LoadingPos;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(ShowData());
    }

    // Update is called once per frame

    public IEnumerator ShowData(){
        //DBManager.db.GetEntireEmployeeDB();
        
        yield return new WaitUntil(()=> DBManager.db.isLoadingDB == false);

        Debug.Log("출력시작");
        InstantiateTMPRO("임직원 명", 30, true ,contentArea);
        InstantiateTMPRO("성별", 30, true ,contentArea);
        InstantiateTMPRO("나이", 30, true,contentArea);
        InstantiateTMPRO("전환배치 횟수", 30, true,contentArea);
        InstantiateTMPRO("근속연수", 30, true,contentArea);
        InstantiateTMPRO("부서", 30, true,contentArea);

        foreach(Employee x in DBManager.db.Employees){
            InstantiateTMPRO(x.Employee_Name, 30, false,contentArea);
            InstantiateTMPRO(x.Employee_Gender.ToString(), 30, false,contentArea);
            InstantiateTMPRO(x.Employee_Age.ToString(), 30, false,contentArea);
            InstantiateTMPRO(x.Relocation_times.ToString(), 30, false,contentArea);
            InstantiateTMPRO(x.Service_years.ToString(), 30, false,contentArea);
            InstantiateTMPRO(x.Department.ToString(), 30, false,contentArea);
        }
        
        yield return null;
    }

    GameObject InstantiateTMPRO(string s, int fontsize, bool bold, GameObject parent){
        TextMeshProUGUI cur = new GameObject(s).AddComponent<TextMeshProUGUI>();
        cur.text = s;
        cur.font = UIManager.ui.mainfont;
        cur.fontSize = fontsize;
        if(bold){
            cur.fontStyle = FontStyles.Bold;
        }
        cur.color = Color.black;
        cur.alignment = TextAlignmentOptions.Midline;
        cur.transform.position = new Vector3(1,1,1);
        cur.transform.SetParent(parent.transform, false);
        return cur.gameObject;
    }


}

