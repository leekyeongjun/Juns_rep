using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using UnityEngine.UI;

public class ScreenshotManager : MonoBehaviour
{

    public GameObject ssbtn;
    public GameObject backbtn;
    public GameObject blink;
    public GameObject TargetUI;
    public void Capture_Button()
    {
        StartCoroutine("TakeScreenshotAndSave");
    }

    private async void RequestPermissionAsynchronously( NativeGallery.PermissionType permissionType, NativeGallery.MediaType mediaTypes )
    {
        NativeGallery.Permission permission = await NativeGallery.RequestPermissionAsync( permissionType, mediaTypes );
        Debug.Log( "Permission result: " + permission );
    }

    private IEnumerator TakeScreenshotAndSave()
    {
        Debug.Log("Capture btn deactive");
        ssbtn.SetActive(false);
        backbtn.SetActive(false);
        GameObject b = Instantiate(blink,TargetUI.transform);
        yield return new WaitForSeconds(1f);
        Destroy(b);

        yield return new WaitForEndOfFrame();

        Texture2D ss = new Texture2D( Screen.width, Screen.height, TextureFormat.RGB24, false );
        ss.ReadPixels( new Rect( 0, 0, Screen.width, Screen.height ), 0, 0 );
        ss.Apply();

        // Save the screenshot to Gallery/Photos
        NativeGallery.Permission permission = NativeGallery.SaveImageToGallery( ss, "GalleryTest", "Image.png", ( success, path ) => Debug.Log( "Media save result: " + success + " " + path ) );

        Debug.Log( "Permission result: " + permission );

        // To avoid memory leaks
        Destroy( ss );
        ssbtn.SetActive(true);
        backbtn.SetActive(true);
        Debug.Log("Capture btn reactive");
    }

    private void PickImage( int maxSize )
    {
        NativeGallery.Permission permission = NativeGallery.GetImageFromGallery( ( path ) =>
        {
            Debug.Log( "Image path: " + path );
            if( path != null )
            {
                // Create Texture from selected image
                Texture2D texture = NativeGallery.LoadImageAtPath( path, maxSize );
                if( texture == null )
                {
                    Debug.Log( "Couldn't load texture from " + path );
                    return;
                }

                // Assign texture to a temporary quad and destroy it after 5 seconds
                GameObject quad = GameObject.CreatePrimitive( PrimitiveType.Quad );
                quad.transform.position = Camera.main.transform.position + Camera.main.transform.forward * 2.5f;
                quad.transform.forward = Camera.main.transform.forward;
                quad.transform.localScale = new Vector3( 1f, texture.height / (float) texture.width, 1f );

                Material material = quad.GetComponent<Renderer>().material;
                if( !material.shader.isSupported ) // happens when Standard shader is not included in the build
                    material.shader = Shader.Find( "Legacy Shaders/Diffuse" );

                material.mainTexture = texture;

                Destroy( quad, 5f );

                // If a procedural texture is not destroyed manually, 
                // it will only be freed after a scene change
                Destroy( texture, 5f );
            }
        } );

        Debug.Log( "Permission result: " + permission );
    }

    private void PickVideo()
    {
        NativeGallery.Permission permission = NativeGallery.GetVideoFromGallery( ( path ) =>
        {
            Debug.Log( "Video path: " + path );
            if( path != null )
            {
                // Play the selected video
                Handheld.PlayFullScreenMovie( "file://" + path );
            }
        }, "Select a video" );

        Debug.Log( "Permission result: " + permission );
    }

    // Example code doesn't use this function but it is here for reference
    private void PickImageOrVideo()
    {
        if( NativeGallery.CanSelectMultipleMediaTypesFromGallery() )
        {
            NativeGallery.Permission permission = NativeGallery.GetMixedMediaFromGallery( ( path ) =>
            {
                Debug.Log( "Media path: " + path );
                if( path != null )
                {
                    // Determine if user has picked an image, video or neither of these
                    switch( NativeGallery.GetMediaTypeOfFile( path ) )
                    {
                        case NativeGallery.MediaType.Image: Debug.Log( "Picked image" ); break;
                        case NativeGallery.MediaType.Video: Debug.Log( "Picked video" ); break;
                        default: Debug.Log( "Probably picked something else" ); break;
                    }
                }
            }, NativeGallery.MediaType.Image | NativeGallery.MediaType.Video, "Select an image or video" );

            Debug.Log( "Permission result: " + permission );
        }
    }

}
