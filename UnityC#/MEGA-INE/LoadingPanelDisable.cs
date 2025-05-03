using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LoadingPanelDisable : MonoBehaviour
{
    public void DisableThis(){
        //Debug.Log("로딩패널 꺼짐");
        transform.gameObject.SetActive(false);
    }
}
