using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MypagePanel : MonoBehaviour
{
    public Mypage mypage;

    public void SetMypagePanel(Employee e){
        mypage.SetMyPage(e);
    }
}
