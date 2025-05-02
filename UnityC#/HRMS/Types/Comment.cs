using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

[System.Serializable]
public class Comment
{
    public int Writer;
    public MTime WrittenTime;
    [TextArea]
    public string CommentText;
    public int Likes;
}
