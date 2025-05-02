using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEngine.Tilemaps;

public class CommentBlock : MonoBehaviour
{
    int pid,tid,aid;
    int CommentIndexInDB;
    public Image ProfileImage;
    public TextMeshProUGUI Nametext;
   
    public TextMeshProUGUI Datetext;
    public GameObject CommentText;
    RectTransform CommentTextRect;
    RectTransform rect;

    TextMeshProUGUI CommentTmptext;
    public RectTransform likebtnrect;
    public TextMeshProUGUI LikeNum;
    float NameTextheight;
    float LikeNumHeight;
    CommentViewer commentViewer;


    bool liked = false;

    void Awake(){
        CommentTextRect = CommentText.GetComponent<RectTransform>();
        CommentTmptext = CommentText.GetComponent<TextMeshProUGUI>();
        rect = GetComponent<RectTransform>();
        NameTextheight = Nametext.gameObject.GetComponent<RectTransform>().sizeDelta.y;
        LikeNumHeight = likebtnrect.sizeDelta.y;
        commentViewer = GameObject.FindGameObjectWithTag("CommentViewer").GetComponent<CommentViewer>();
    }
    public void SetComment(Comment c, int _pid, int _tid, int _aid, int cid){
        Employee e = DBManager.db.Employees[c.Writer];
        ProfileImage.sprite = DBManager.db.FaceImageList[e.Facetype];
        Nametext.text = e.Employee_Name;
        Datetext.text = TimeManager.tm.GetTimeComparedtoNow(c.WrittenTime.ToDateTime());
        LikeNum.text = c.Likes.ToString();
        CommentIndexInDB = cid;
        pid = _pid;
        tid = _tid;
        aid = _aid;

        Vector2 defaultsize = CommentTextRect.sizeDelta;

        CommentTmptext.text = c.CommentText;
        Vector2 Preferredsize = CommentTmptext.GetPreferredValues(c.CommentText);

        int enhancetime = (int)(Preferredsize.x / defaultsize.x);
        float preferredHeight = (enhancetime+1) * Preferredsize.y;
        
        if(preferredHeight < defaultsize.y) preferredHeight = defaultsize.y;

        //Debug.Log("preferedsize : "+ Preferredsize + "/ enhancetime : " + enhancetime.ToString() + "Prefered Height  : "+ preferredHeight.ToString());

        CommentTextRect.sizeDelta = new Vector2(CommentTextRect.sizeDelta.x, preferredHeight + 15);
        float newHeight = preferredHeight + NameTextheight + LikeNumHeight + 20;
        rect.sizeDelta = new Vector2(rect.sizeDelta.x, newHeight);

    }
    
    public void AddLike(){
        if(liked == false){
            DBManager.db.projects[pid].tasks[tid].activities[aid].Comments[CommentIndexInDB].Likes++;
            ProjectDBSelector.pdb.GetDBDifference(AccountManager.am.mydata.myemployeedata.Department);
            liked = true;
            commentViewer.SetCommentView(pid,tid,aid);
        }
    }
}
