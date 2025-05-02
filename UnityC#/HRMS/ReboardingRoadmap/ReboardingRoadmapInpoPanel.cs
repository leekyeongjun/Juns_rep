using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ReboardingRoadmapInpoPanel : MonoBehaviour
{

    public int currentReboardingIndex;
    public Image curProcessName;
    public TextMeshProUGUI curProcessPurpose;
    public TextMeshProUGUI curProcessDetails;
    GameObject sortlayer;
    public GameObject ReflectionPanel;

    // Start is called before the first frame update
    void Start()
    {
        sortlayer = GameObject.FindGameObjectWithTag("MiniPanelSortLayer");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public void SetReboardingRoadmapDetails(int id, ReboardingProcess Rprocess){
        currentReboardingIndex = id;
        curProcessName.sprite = Rprocess.ProcessName;
        curProcessPurpose.text = Rprocess.ProcessPurpose;
        string cpd = "";
        for(int i = 0; i<Rprocess.ProcessDetail.Count; i++){
            
            cpd += Rprocess.ProcessDetail[i] + " - " + Rprocess.ProcessDetailExplanation[i] + "\n";
        }
        curProcessDetails.text = cpd;
    }
    public void OnPanelCreateButtonClick(){
        GameObject p = Instantiate(ReflectionPanel, sortlayer.transform, false);
        p.GetComponent<Reflectionpanel>().SetCurrentReflections(currentReboardingIndex);
    }
}
