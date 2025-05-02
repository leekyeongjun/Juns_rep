using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MypageMain : MonoBehaviour
{
    public Mypage mypage;

    void Start(){
        if(AccountManager.am.loggedIn) mypage.SetMyPage(AccountManager.am.mydata.myemployeedata);
    } 

}
