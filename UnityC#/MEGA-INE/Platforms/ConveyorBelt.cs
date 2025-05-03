using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConveyorBelt : MonoBehaviour
{
    public bool IsOn = false;
    public float TargetDriveSpeed = 3.0f;

    public float CurrentSpeed { get { return _currentSpeed; } }

    public Vector3 DriveDirection = Vector3.forward;

    [SerializeField] private float _forcePower = 50f;

    private float _currentSpeed = 0;
    public List<Rigidbody2D> _rigidbodies = new List<Rigidbody2D>();

    void Start()
    {
        DriveDirection = DriveDirection.normalized;
    }

    void FixedUpdate()
    {
        _currentSpeed = IsOn ? TargetDriveSpeed : 0;

        _rigidbodies.RemoveAll(r => r == null);

        foreach (var r in _rigidbodies)
        {
            
            var objectSpeed = Vector3.Dot(r.velocity, DriveDirection);

            if (objectSpeed < Mathf.Abs(TargetDriveSpeed))
            {
                r.AddForce(DriveDirection * _forcePower, ForceMode2D.Force);
            }
        }
    }

    void OnCollisionEnter2D(Collision2D collision)
    {
        if(Player.player.movement2D.isGrounded){
            var R = collision.gameObject.GetComponent<Rigidbody2D>();
            _rigidbodies.Add(R);
        }
    }

    void OnCollisionExit2D(Collision2D collision)
    {
        var R = collision.gameObject.GetComponent<Rigidbody2D>();
        _rigidbodies.Remove(R);
    }

}
