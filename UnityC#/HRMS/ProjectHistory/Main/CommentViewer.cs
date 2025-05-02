using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System;

public class CommentViewer : MonoBehaviour
{
    public GameObject CommentContent;
    public GameObject CommentBlockprefab;
    public TMP_InputField CommentInputfield;

    int pid,tid,aid;

    void Start(){
        ProjectDBSelector.pdb.SetEmployeeDB();
    }
    void Setids(int _pid, int _tid, int _aid){
        pid = _pid;
        tid = _tid;
        aid = _aid;
    }

    public void SetCommentView(int _pid, int _tid, int _aid){
        Setids(_pid, _tid, _aid);
        foreach(Transform child in CommentContent.transform){
            Destroy(child.gameObject);
        }
        
        CommentInputfield.text = "";

        foreach(Comment c in DBManager.db.projects[pid].tasks[tid].activities[aid].Comments){
            GameObject cmt = Instantiate(CommentBlockprefab, CommentContent.transform, false);
            cmt.GetComponent<CommentBlock>().SetComment(c, pid,tid,aid,DBManager.db.projects[pid].tasks[tid].activities[aid].Comments.IndexOf(c));
        }
    }

    public void WriteComment(){
        if(CommentInputfield.text != ""){
            Comment c = new(){
                CommentText = CommentInputfield.text,
                Writer = AccountManager.am.mydata.myemployeedata.Id,
                Likes = 0,
                WrittenTime = new MTime(DateTime.Now)
            };
            DBManager.db.projects[pid].tasks[tid].activities[aid].Comments.Add(c);
            
            ActivityHistory ah = new();
            ah.SetCommentActivityHistory(pid, tid, aid, c.CommentText, AccountManager.am.mydata.myemployeedata, new MTime(DateTime.Now));
            DBManager.db.Employees[AccountManager.am.mydata.myemployeedata.Id].PersonalActivityHistories.Add(ah);
            DBManager.db.activityHistories.Add(ah);
            SetCommentView(pid,tid,aid);
            ProjectDBSelector.pdb.GetDBDifference(AccountManager.am.mydata.myemployeedata.Department);
        }
    }
    

}
