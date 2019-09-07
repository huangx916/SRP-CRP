using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour
{
	private RenderTexture cameraTarget;

    private RenderBuffer[] GBuffers;
    private RenderTexture[] GBufferTextures;
    private int[] GBufferIDs;

    private RenderTexture depthTexture;
    private static int _DepthTexture = Shader.PropertyToID("_DepthTexture");

    public Transform[] cubeTransforms;
    public Mesh cubeMesh;
    public Material pureColorMaterial;
    
    public Skybox skybox;
    public DeferredLighting deferredLighting;

    // Start is called before the first frame update
    void Start()
    {
        cameraTarget = new RenderTexture(Screen.width, Screen.height, 0);
        GBufferTextures = new RenderTexture[]
        {
            new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear),
            new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear),
            new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear),
            new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear)
        };
        depthTexture = new RenderTexture(Screen.width, Screen.height, 24, RenderTextureFormat.Depth, RenderTextureReadWrite.Linear);
        GBuffers = new RenderBuffer[GBufferTextures.Length];
        for(int i = 0; i < GBuffers.Length; ++i)
        {
            GBuffers[i] = GBufferTextures[i].colorBuffer;
        }
        GBufferIDs = new int[]
        {
            Shader.PropertyToID("_GBuffer0"),
            Shader.PropertyToID("_GBuffer1"),
            Shader.PropertyToID("_GBuffer2"),
            Shader.PropertyToID("_GBuffer3")
        };
    }

    private void OnPostRender()
    {
        Camera cam = Camera.current;
        Shader.SetGlobalTexture(_DepthTexture, depthTexture);
        //Graphics.SetRenderTarget(cameraTarget);
        Graphics.SetRenderTarget(GBuffers, depthTexture.depthBuffer);
        GL.Clear(true, true, Color.black);

        //pureColorMaterial.color = new Color(0, 0.5f, 0.8f);
        //pureColorMaterial.SetPass(0);
        deferredLighting.deferredMaterial.SetPass(0);
        foreach(var i in cubeTransforms)
        {
            Graphics.DrawMeshNow(cubeMesh, i.localToWorldMatrix);
        }

        skybox.DrawSkybox(cam);

        Graphics.Blit(cameraTarget, cam.targetTexture);
    }

    
}
