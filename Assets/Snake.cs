using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Snake : MonoBehaviour
{

    private Vector2 direction_ = Vector2.right;
    private List<Transform> segments_ = new List<Transform>();
    public Transform segmentPrefab;
    public int initialSize = 4;
    // Start is called before the first frame update
    void Start()
    {
        ResetState();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.W))
        {
            direction_ = Vector2.up;
        } 
        else if (Input.GetKeyDown(KeyCode.S))
        {
            direction_ = Vector2.down;
        } 
        else if (Input.GetKeyDown(KeyCode.A))
        {
            direction_ = Vector2.left;
        } 
        else if (Input.GetKeyDown(KeyCode.D))
        {
            direction_ = Vector2.right;
        }
    }

    private void FixedUpdate()
    {
        for (int i = segments_.Count - 1; i > 0; i--)
        {
            segments_[i].position = segments_[i - 1].position;
        }
        this.transform.position = new Vector3 (
                Mathf.Round(this.transform.position.x) + direction_.x,
                Mathf.Round(this.transform.position.y) + direction_.y,
                0.0f
            );
    }

    private void Grow()
    {
        Transform segment = Instantiate(this.segmentPrefab);
        segment.position = segments_[segments_.Count - 1].position;

        segments_.Add(segment);
    }

    private void ResetState()
    {
        for (int i = 1; i < segments_.Count; i++)
        {
            Destroy(segments_[i].gameObject);
        }

        segments_.Clear();
        segments_.Add(this.transform);

        for (int i = 1; i < initialSize; i++)
        {
            this.segments_.Add(Instantiate(this.segmentPrefab));
        }

        this.transform.position = Vector3.zero;
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag == "Food")
            Grow();
        else if (collision.tag == "Obstacle")
            ResetState();
    }
}
