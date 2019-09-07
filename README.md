# SRP-CRP
test scriptable render pipeline &amp; custom render pipeline  

### Note:  
OnPostRender函数中调用Graphics.Blit没效果，可能是由于hdr开启的原因。 
Every Graphics.Blit causes RenderTexture.ResolveAA if MSAA enabled which is killing framerate.  

Unity使用的是OpenGL标准，即-1是左和下，1是右和上， 0是远裁面，1是近裁面  

GBuffer中储存当前像素的Albedo, Specular, AO, normal, Depth等  
通过深度图反推世界坐标就需要viewProjection matrix的逆矩阵: 
```
float4 worldPos = mul(_InvVP, float4(i.uv*2-1, depth, 1)); 
```
