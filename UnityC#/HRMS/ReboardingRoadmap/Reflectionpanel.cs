using System.Collections;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.UI;


public class Reflectionpanel : MonoBehaviour
{
    public int currentReboardingIndex;
    public Reflection currentReflection;
    public int myid;

    public TMP_InputField YourFeeling;
    public TMP_InputField TodayNeed;
    public TMP_InputField TodayLearned;
    public TMP_InputField YourPlan;

    public List<Slider> sliders;

    public GameObject sliderPrefab;
    public GameObject sliderArea;


    public List<List<string>> Questions = new List<List<string>>() {
        new List<string> {"팀장/버디랑 라포 형성"},
        new List<string> {"업무 환경 이해", "동료들과 친해지기"},
        new List<string> {"조직의 구조 이해", "협업을 위한 툴 익히기"},
        new List<string> {"동료들과 친해지기", "조직 내 Key man 찾기"},
        new List<string> {"공동체의식 가지기"}
    };

    void Start(){
        ProjectDBSelector.pdb.SetEmployeeDB();
    }
    
    public void SetCurrentReflections(int id){
        currentReboardingIndex = id;
        myid = AccountManager.am.mydata.myemployeedata.Id;
        currentReflection = DBManager.db.Employees[myid].ReboardingReflectionList.reflections[currentReboardingIndex];
        

        YourFeeling.text =currentReflection.YourFeelings;
        TodayNeed.text = currentReflection.TodayNeeds;
        TodayLearned.text = currentReflection.TodayLearned;
        YourPlan.text = currentReflection.YourPlans;

        sliders = new List<Slider>();

        for(int i = 0; i<currentReflection.ReflectionScores.Count; i++){
            GameObject s = Instantiate(sliderPrefab, sliderArea.transform, false);
            Slider s_slider = s.GetComponentInChildren<Slider>();
            TextMeshProUGUI s_text = s.GetComponentInChildren<TextMeshProUGUI>();

            s_text.text = Questions[currentReboardingIndex][i];
            s_slider.value = currentReflection.ReflectionScores[i];
            s_slider.onValueChanged.AddListener(delegate {SetSliderValues();});
            sliders.Add(s_slider);
        }        
    }

    public void SetSliderValues(){
        for(int i = 0; i<sliders.Count; i++){
            currentReflection.ReflectionScores[i] = sliders[i].value;
        }
    }

    public void SetTexts(){
        currentReflection.YourFeelings = YourFeeling.text;
        currentReflection.TodayNeeds = TodayNeed.text;
        currentReflection.TodayLearned = TodayLearned.text;
        currentReflection.YourPlans = YourPlan.text;

    }
    public void CopydvsValuetoEmployeeData(){
        SetTexts();
        DBManager.db.Employees[myid].ReboardingReflectionList.reflections[currentReboardingIndex] = currentReflection;
        Destroy(gameObject);
    }

}
