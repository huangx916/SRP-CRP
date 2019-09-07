# SRP-CRP
test scriptable render pipeline &amp; custom render pipeline  

### Note:  
OnPostRender函数中调用Graphics.Blit没效果，可能是由于hdr开启的原因。 
Every Graphics.Blit causes RenderTexture.ResolveAA if MSAA enabled which is killing framerate.  
