using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UGS;

public class ProjectManager : MonoBehaviour
{
    
    public List<Project> projects;
    public int finalID;
  



    void Start(){
        //DBManager.db.GetProjectDB(projects);
    }

    /*
    public void WriteProjectDatatoGoogle(){
        var newProjectData = new ProjectDB.Personnel(){
            ID = finalID+1,
            ProjectID = 2,
            ProjectName = "테스트용프로젝트",
            TaskID = 0,
            TaskName = "테스트용태스크",
            Participants = new List<int>() {0,1},
            Duration = 40,
            ActivityDetails = "테스트",
            Gadgets = new List<string>() {"test", "test2"},
            Result = "끝으로가면 성공",
            ExtraMaterial = "제발",
            ProgressRatio = 100,
            note = "가나다라마바사",
            FuturePlan = "구현만된다면",

            WriterID = AccountManager.am.mydata.myemployeedata.Id,
            WrittenTime = DateTime.Now.ToString("yyyyMMdd")
        };

        UnityGoogleSheet.Write<ProjectDB.Personnel>(newProjectData);
        finalID++;
        LoadManager.lm.MoveScene("ProjectHistoryScene");
    }
    */
}
