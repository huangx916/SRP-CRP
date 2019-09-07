using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour
{
    

	public RenderTexture rt;
    public Transform[] cubeTransforms;
    public Mesh cubeMesh;
    public Material pureColorMaterial;

    public Skybox skybox;

    // Start is called before the first frame update
    void Start()
    {
        rt = new RenderTexture(Screen.width, Screen.height, 24);
    }

    private void OnPostRender()
    {
        Camera cam = Camera.current;
        Graphics.SetRenderTarget(rt);
        GL.Clear(true, true, Color.gray);

        pureColorMaterial.color = new Color(0, 0.5f, 0.8f);
        pureColorMaterial.SetPass(0);
        foreach(var i in cubeTransforms)
        {
            Graphics.DrawMeshNow(cubeMesh, i.localToWorldMatrix);
        }

        skybox.DrawSkybox(cam);

        Graphics.Blit(rt, cam.targetTexture);
    }
}
