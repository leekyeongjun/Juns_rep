using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LifeStat : MonoBehaviour
{
    public Text LifeStatText;

    private void Start() {
        
    }

    private void FixedUpdate() {
        LifeStatText.text = GameManager.GM.curLife.ToString();
    }
}
