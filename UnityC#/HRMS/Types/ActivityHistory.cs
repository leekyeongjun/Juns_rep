using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class ActivityHistory
{
    public enum Status {project, task, activity, comment};

    public Status status;

    [NonSerialized]
    public int pid,tid,aid;
    public string activityHistoryLabel;
    public int Writer;
    public MTime WrittenTime;
    public string CommentData;


    public void SetProjectActivityHistory(int _pid, Employee _Writer, MTime _WrittenTime){
        status = Status.project;
        pid = _pid;
        Writer = _Writer.Id;
        WrittenTime = _WrittenTime;
        SetActivityHistoryLabel();
    }

    public void SetTaskActivityHistory(int _pid, int _tid, Employee _Writer, MTime _WrittenTime){
        status = Status.task;
        pid = _pid;
        tid = _tid;
        Writer = _Writer.Id;
        WrittenTime  =_WrittenTime;
        SetActivityHistoryLabel();
    }

    public void SetActivitiesActivityHistory(int _pid, int _tid, int _aid, Employee _Writer, MTime _WrittenTime){
        status = Status.activity;
        pid = _pid;
        tid = _tid;
        aid = _aid;
        Writer = _Writer.Id;
        WrittenTime  =_WrittenTime;
        SetActivityHistoryLabel();
    }

    public void SetCommentActivityHistory(int _pid, int _tid, int _aid, string _commentData, Employee _Writer, MTime _WrittenTime){
        status = Status.comment;
        pid = _pid;
        tid = _tid;
        aid = _aid;
        Writer = _Writer.Id;
        WrittenTime  =_WrittenTime;
        CommentData = _commentData;
        SetActivityHistoryLabel();
    }

    public void SetActivityHistoryLabel(){
        if(status == Status.project){
            activityHistoryLabel = DBManager.db.Employees[Writer].Employee_Name + " 이(가) " + "프로젝트 히스토리의 <color=#0A75A3>\n" + DBManager.db.projects[pid].ProjectName +"</color>에 프로젝트를 추가했습니다.";
        }
        else if(status == Status.task){
            activityHistoryLabel = DBManager.db.Employees[Writer].Employee_Name + " 이(가)" + "프로젝트 히스토리의 <color=#0A75A3>\n" + DBManager.db.projects[pid].ProjectName +" > "+ DBManager.db.projects[pid].tasks[tid].TaskName + "</color>에 테스크를 추가했습니다.";
        }
        else if(status == Status.activity){
            activityHistoryLabel = DBManager.db.Employees[Writer].Employee_Name + " 이(가)" + "프로젝트 히스토리의 <color=#0A75A3>\n"+ DBManager.db.projects[pid].ProjectName + " > " + DBManager.db.projects[pid].tasks[tid].TaskName +   " > " + DBManager.db.projects[pid].tasks[tid].activities[aid].ActivityName +  "</color>에 액티비티를 업데이트 했습니다.";
        }
        else{
            activityHistoryLabel = DBManager.db.Employees[Writer].Employee_Name + " 이(가)" + "프로젝트 히스토리의 <color=#0A75A3>\n"+ DBManager.db.projects[pid].ProjectName + " > " + DBManager.db.projects[pid].tasks[tid].TaskName +   " > " + DBManager.db.projects[pid].tasks[tid].activities[aid].ActivityName +  "</color>에 댓글을 작성했습니다.";

        }
    }
}
