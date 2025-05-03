using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Problem{

    public string question;
    public string Answer_1;
    public string Answer_2;
    public int AnswerID;
};

public class QuestionMaker : MonoBehaviour
{
    public enum QType {multiply, add, minus};
    public QType qtype;

    public int minOffset = -5;
    public int maxOffset = 5;
    public int minvalue = 0;
    public int maxvalue = 21;

    public Problem makeProblem(){
        Problem p = new Problem();
        int randAnsID = Random.Range(0,2);

        int randLeftNum = Random.Range(minvalue, maxvalue);
        int randRightNum = Random.Range(minvalue, maxvalue);

        int rightAns;
        string op;

        if(qtype == QType.multiply){
            op = "X";
            rightAns = randLeftNum*randRightNum;
        }
        else if(qtype == QType.add){
            op = "+";
            rightAns = randLeftNum+randRightNum;
        }
        else{
            op = "-";
            rightAns = randLeftNum-randRightNum;
        }

        if(randAnsID == 0){
            p.Answer_1 = rightAns.ToString();
            p.Answer_2 = (rightAns+Random.Range(minOffset,maxOffset)).ToString();
        }
        else{
            p.Answer_1 = (rightAns+Random.Range(minOffset,maxOffset)).ToString();
            p.Answer_2 = rightAns.ToString();
        }

        p.AnswerID = randAnsID;

        p.question = randLeftNum.ToString()+op+randRightNum.ToString()+"=?";
        return p;
    }
}
