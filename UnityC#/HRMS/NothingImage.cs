using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NothingImage : MonoBehaviour
{
    public void ImageOn(bool on){
        transform.gameObject.SetActive(on);
    }
}
