using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour
{
    public static Mesh fullScreenMesh
    {
        get
        {
            if(m_mesh != null)
            {
                return m_mesh;
            }

            m_mesh = new Mesh();
            m_mesh.vertices = new Vector3[]
            {
                new Vector3(-1,-1,0),
                new Vector3(-1,1,0),
                new Vector3(1,1,0),
                new Vector3(1,-1,0)
            };
            m_mesh.uv = new Vector2[]
            {
                new Vector2(0,1),
                new Vector2(0,0),
                new Vector2(1,0),
                new Vector2(1,1)
            };
            m_mesh.SetIndices(new int[] {0,1,2,3}, MeshTopology.Quads, 0);
            return m_mesh;
        }
    }
    private static Mesh m_mesh;
    private static Vector4[] corners = new Vector4[4];
    public void DrawSkybox(Camera cam)
    {
        corners[0] = cam.ViewportToWorldPoint(new Vector3(0,0,cam.farClipPlane));
        corners[1] = cam.ViewportToWorldPoint(new Vector3(1,0,cam.farClipPlane));
        corners[2] = cam.ViewportToWorldPoint(new Vector3(0,1,cam.farClipPlane));
        corners[3] = cam.ViewportToWorldPoint(new Vector3(1,1,cam.farClipPlane));
        skyboxMaterial.SetVectorArray("_Corner", corners);
        skyboxMaterial.SetPass(0);
        Graphics.DrawMeshNow(fullScreenMesh, Matrix4x4.identity);
    }

	public RenderTexture rt;
    public Transform[] cubeTransforms;
    public Mesh cubeMesh;
    public Material pureColorMaterial;
    public Material skyboxMaterial;
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

        DrawSkybox(cam);

        Graphics.Blit(rt, cam.targetTexture);
    }
}
