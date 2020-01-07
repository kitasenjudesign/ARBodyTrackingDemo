using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;

public class HumanBodyTracker3 : MonoBehaviour
{
    [SerializeField]
    [Tooltip("The Skeleton prefab to be controlled.")]
    GameObject m_SkeletonPrefab;

    [SerializeField]
    [Tooltip("The ARHumanBodyManager which will produce body tracking events.")]
    ARHumanBodyManager m_HumanBodyManager;

    /// <summary>
    /// Get/Set the <c>ARHumanBodyManager</c>.
    /// </summary>
    public ARHumanBodyManager humanBodyManager
    {
        get { return m_HumanBodyManager; }
        set { m_HumanBodyManager = value; }
    }

    /// <summary>
    /// Get/Set the skeleton prefab.
    /// </summary>
    public GameObject skeletonPrefab
    {
        get { return m_SkeletonPrefab; }
        set { m_SkeletonPrefab = value; }
    }

    Dictionary<TrackableId, BoneController> m_SkeletonTracker = new Dictionary<TrackableId, BoneController>();

    [SerializeField] private GameObject ballPrefab;
    [SerializeField] private Brushes _brushes;
    [SerializeField] private BubbleGen _bubbleGen;
    [SerializeField] private BoidsSimulationOnGPU.GPUBoids _boids;
    private List<GameObject> _balls;

    private GameObject leftHand;
    private GameObject rightHand;
    private GameObject leftFoot;
    private GameObject rightFoot;
    private GameObject head;


    void Awake(){

       

    }

    void OnEnable()
    {
        Debug.Assert(m_HumanBodyManager != null, "Human body manager is required.");
        m_HumanBodyManager.humanBodiesChanged += OnHumanBodiesChanged;
    }

    void OnDisable()
    {
        if (m_HumanBodyManager != null)
            m_HumanBodyManager.humanBodiesChanged -= OnHumanBodiesChanged;
    }

    void OnHumanBodiesChanged(ARHumanBodiesChangedEventArgs eventArgs)
    {
        BoneController boneController;

        foreach (var humanBody in eventArgs.added)
        {
            if (!m_SkeletonTracker.TryGetValue(humanBody.trackableId, out boneController))
            {
                Debug.Log($"Adding a new skeleton [{humanBody.trackableId}].");
                var newSkeletonGO = Instantiate(m_SkeletonPrefab, humanBody.transform);
                
                boneController = newSkeletonGO.GetComponent<BoneController>();
                m_SkeletonTracker.Add(humanBody.trackableId, boneController);
            }

            boneController.InitializeSkeletonJoints();
            boneController.ApplyBodyPose(humanBody);
        }


        if( leftHand == null ){
            leftHand = GameObject.Find("RightHandRingStart");            
        }

        if( rightHand == null ){
            rightHand = GameObject.Find("LeftHandRingStart");
            _boids._Feed = rightHand;
        }

        if( leftFoot == null ){
            leftFoot = GameObject.Find("LeftFoot");            
        }

        if( rightFoot == null ){
            rightFoot = GameObject.Find("RightFoot");
        }

        if( head == null ){
            head = GameObject.Find("Head");

            _brushes.Init(new Transform[]{
                leftHand.transform,
                rightHand.transform
                //leftFoot.transform,
                //rightFoot.transform,
                //head.transform
            });

            _bubbleGen.targets=new Transform[]{
                leftHand.transform,
                rightHand.transform
            };

        }

        //UpdateBall( rightHand );
        //UpdateBall( leftHand );
        //UpdateBall( leftFoot );
        //UpdateBall( rightFoot );
        //UpdateBall( head );

        //syokika
        //var joints = humanbody
        //XRHumanBodyJoint joint = joints[i];
        
        foreach (var humanBody in eventArgs.updated)
        {
            if (m_SkeletonTracker.TryGetValue(humanBody.trackableId, out boneController))
            {
                
                boneController.ApplyBodyPose(humanBody);

            }
        }

        foreach (var humanBody in eventArgs.removed)
        {
            Debug.Log($"Removing a skeleton [{humanBody.trackableId}].");
            if (m_SkeletonTracker.TryGetValue(humanBody.trackableId, out boneController))
            {
                Destroy(boneController.gameObject);
                m_SkeletonTracker.Remove(humanBody.trackableId);
            }
        }
    }


    private int _count = 0;
//RightHandRingEnd

    public void UpdateBall(GameObject tgt)
    {
        var b = _balls[_count%_balls.Count];
        _count++;

        

        if(tgt){
            var dist = Vector3.Distance( b.transform.position, tgt.transform.position);
            //if(dist>0.3f){
                b.transform.position = tgt.transform.position;
            //}
        }
    }


}
