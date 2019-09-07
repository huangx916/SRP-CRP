using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class BasicAssetPipe : RenderPipelineAsset
{
    public Color clearColor = Color.green;

    protected override RenderPipeline CreatePipeline()
    {
        return new BasicPipeInstance(clearColor);
    }
}
