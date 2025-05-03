using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimatorParameter : MonoBehaviour
{
    public Animator animator;
    

    void Start()
    {
        animator = GetComponent<Animator>();
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void isIdle()
    {
        animator.SetBool("isidle",true);

    }
    public void isCorrect()
    {
        animator.SetBool("isidle",false);
        animator.SetBool("iscorr",true);
        

    }
    public void isWrong()
    {
        animator.SetBool("isidle",false);
        animator.SetBool("iscorr",false);


    }
}
