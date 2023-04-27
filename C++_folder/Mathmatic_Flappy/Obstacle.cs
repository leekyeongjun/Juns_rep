using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Obstacle : MonoBehaviour
{
    public float speed;

    public BoxCollider2D part_1;
    public BoxCollider2D part_2;
    public QuestionMaker q;

    public TMP_Text ans_1;
    public TMP_Text ans_2;
    public TMP_Text question;

    void Awake(){
        GetQuestionData();
    }
    void Start()
    {
        Invoke("Destroy", 5f);
        
    }

    void Update()
    {
        if(GameManager.GM.onGame == false){
            speed = 0;
        }
        transform.Translate(Vector3.left *speed* Time.deltaTime);
    }


    void GetQuestionData(){

        Problem p = new Problem();
        p = q.makeProblem();
        ans_1.text = p.Answer_1;
        ans_2.text = p.Answer_2;
        question.text = p.question;

        if(p.AnswerID == 0){ // 1번이 정답임
            Debug.Log("Upper!");
            part_1.tag = "Point";
            part_2.tag = "Obstacle";
        }
        else{ // 2번이 정답임
            Debug.Log("below!");
            part_1.tag = "Obstacle";
            part_2.tag = "Point";
        }
    }

    void Destroy(){
        Destroy(gameObject);
    }

}
