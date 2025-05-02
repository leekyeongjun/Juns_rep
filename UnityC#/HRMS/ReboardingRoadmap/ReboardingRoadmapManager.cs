using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

[System.Serializable]

public class ReboardingProcess{

    public Sprite ProcessName;
    [Multiline]
    public string ProcessPurpose;

    [Multiline]
    public List<string> ProcessDetail;
    [Multiline]
    public List<string> ProcessDetailExplanation;
    

}
public class ReboardingRoadmapManager : MonoBehaviour
{

    public List<ReboardingProcess> Rprocesses;

    public GameObject sortlayer;

    int currentReboardingIndex;
    public Image curProcessName;
    public TextMeshProUGUI curProcessPurpose;
    public TextMeshProUGUI curProcessDetails;
    public GameObject ReflectionPanel;

    void Start() {
        OnbuttonClick(0);
    }
    public void OnbuttonClick(int processid){
        SetReboardingRoadmapDetails(processid, Rprocesses[processid]);
    }

    public void SetReboardingRoadmapDetails(int id, ReboardingProcess Rprocess){
        currentReboardingIndex = id;
        curProcessName.sprite = Rprocess.ProcessName;
        curProcessPurpose.text = Rprocess.ProcessPurpose;
        string cpd = "";
        for(int i = 0; i<Rprocess.ProcessDetail.Count; i++){
            
            cpd += Rprocess.ProcessDetail[i] + "\n" + Rprocess.ProcessDetailExplanation[i] + "\n\n";
        }
        curProcessDetails.text = cpd;
    }
    public void OnPanelCreateButtonClick(){
        GameObject p = Instantiate(ReflectionPanel, sortlayer.transform, false);
        p.GetComponent<Reflectionpanel>().SetCurrentReflections(currentReboardingIndex);
    }
}
