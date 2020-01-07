using System.Text;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.ARFoundation;

public class PeopleOcclusion : MonoBehaviour
{
    [SerializeField, Tooltip("The ARHumanBodyManager which will produce frame events.")]
    private ARHumanBodyManager _humanBodyManager;

    [SerializeField]
    private Material _material = null;

    [SerializeField]
    private ARCameraBackground _arCameraBackground = null;

    [SerializeField]
    private RawImage _captureImage = null;

    private RenderTexture _captureTexture = null;

    public ARHumanBodyManager HumanBodyManager
    {
        get { return _humanBodyManager; }
        set { _humanBodyManager = value; }
    }

    [SerializeField]
    private RawImage _rawImage;

    /// <summary>
    /// The UI RawImage used to display the image on screen.
    /// </summary>
    public RawImage RawImage
    {
        get { return _rawImage; }
        set { _rawImage = value; }
    }

    [SerializeField]
    private Text _imageInfo;

    /// <summary>
    /// The UI Text used to display information about the image on screen.
    /// </summary>
    public Text ImageInfo
    {
        get { return _imageInfo; }
        set { _imageInfo = value; }
    }

    #region ### MonoBehaviour ###
    private void Awake()
    {
        Camera camera = GetComponent<Camera>();
        camera.depthTextureMode |= DepthTextureMode.Depth;

        _rawImage.texture = _humanBodyManager.humanDepthTexture;

        _captureTexture = new RenderTexture(Screen.width, Screen.height, 0);
        //_captureImage.texture = _captureTexture;
    }
    #endregion ### MonoBehaviour ###

    private void LogTextureInfo(StringBuilder stringBuilder, string textureName, Texture2D texture)
    {
        stringBuilder.AppendFormat("texture : {0}\n", textureName);
        if (texture == null)
        {
            stringBuilder.AppendFormat("   <null>\n");
        }
        else
        {
            stringBuilder.AppendFormat("   format : {0}\n", texture.format.ToString());
            stringBuilder.AppendFormat("   width  : {0}\n", texture.width);
            stringBuilder.AppendFormat("   height : {0}\n", texture.height);
            stringBuilder.AppendFormat("   mipmap : {0}\n", texture.mipmapCount);
        }
    }

    private void Update()
    {
        var subsystem = _humanBodyManager.subsystem;

        if (subsystem == null)
        {
            if (_imageInfo != null)
            {
                _imageInfo.text = "Human Segmentation not supported.";
            }
            return;
        }

        StringBuilder sb = new StringBuilder();
        Texture2D humanStencil = _humanBodyManager.humanStencilTexture;
        Texture2D humanDepth = _humanBodyManager.humanDepthTexture;
        LogTextureInfo(sb, "stencil", humanStencil);
        LogTextureInfo(sb, "depth", humanDepth);

        if (_imageInfo != null)
        {
            _imageInfo.text = sb.ToString();
        }

        _material.SetTexture("_StencilTex", humanStencil);
        _material.SetTexture("_DepthTex", humanDepth);
        _material.SetTexture("_BackgroundTex", _captureTexture);
    }

    private void LateUpdate()
    {
        if (_arCameraBackground.material != null)
        {
            Graphics.Blit(null, _captureTexture, _arCameraBackground.material);
        }
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, _material);
    }
}