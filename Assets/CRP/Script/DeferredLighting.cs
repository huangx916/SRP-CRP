using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public struct DeferredLighting
{
    public Material deferredMaterial;
    public Light directionalLight;
    private static int _InvVP = Shader.PropertyToID("_InvVP");
    private static int _CurrentLightDir = Shader.PropertyToID("_CurrentLightDir");
    private static int _LightFinalColor = Shader.PropertyToID("_LightFinalColor");

    public void DrawLight(RenderTexture[] gbufferTextures, int[] gbufferIDs, RenderTexture target, Camera cam)
    {
        Matrix4x4 proj = GL.GetGPUProjectionMatrix(cam.projectionMatrix, false);
        Matrix4x4 vp = proj * cam.worldToCameraMatrix;
        deferredMaterial.SetMatrix(_InvVP, vp.inverse);
        deferredMaterial.SetVector(_CurrentLightDir, -directionalLight.transform.forward);
        deferredMaterial.SetVector(_LightFinalColor, directionalLight.color * directionalLight.intensity);
        for (int i = 0; i < gbufferIDs.Length; ++i)
        {
            deferredMaterial.SetTexture(gbufferIDs[i], gbufferTextures[i]);
        }
        Graphics.Blit(null, target, deferredMaterial, 0);
    }
}
