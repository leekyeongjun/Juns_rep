using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class SortOrderManager : MonoBehaviour ,IPointerClickHandler
{


    public void OnPointerClick(PointerEventData eventData){
        Debug.Log("clicked");
        transform.SetAsLastSibling();
    }
}
