#if UNITY_EDITOR

using UnityEngine;
using UnityEditor;
using System.IO;

public class GenerateMetallicGlossMap : EditorWindow
{
    private Texture2D metallicMap;
    private Texture2D smoothnessMap;
    private bool invertSmoothness = false;

    [MenuItem("Tools/yum_food/GenerateMetallicGlossMap")]
    public static void ShowWindow()
    {
        GetWindow<GenerateMetallicGlossMap>("Metallic Gloss Map Generator");
    }

    private void OnGUI()
    {
        GUILayout.Label("Metallic Gloss Map Generator", EditorStyles.boldLabel);

        metallicMap = (Texture2D)EditorGUILayout.ObjectField(
            "Metallic Map (R)", metallicMap, typeof(Texture2D), false);
        smoothnessMap = (Texture2D)EditorGUILayout.ObjectField(
            "Smoothness Map (R)", smoothnessMap, typeof(Texture2D), false);
        
        invertSmoothness = EditorGUILayout.Toggle("Invert Smoothness", invertSmoothness);

        if (GUILayout.Button("Generate Metallic Gloss Map") && smoothnessMap != null)
        {
            GenerateMap();
        }
    }

    private void GenerateMap()
    {
        // Get path and determine output location
        string directory = metallicMap != null 
            ? Path.GetDirectoryName(AssetDatabase.GetAssetPath(metallicMap))
            : Path.GetDirectoryName(AssetDatabase.GetAssetPath(smoothnessMap));
        string filename = metallicMap != null ? metallicMap.name : "black";
        string newPath = Path.Combine(directory, filename + "_metallicgloss.png");

        // Create new texture
        int width = metallicMap != null ? metallicMap.width : smoothnessMap.width;
        int height = metallicMap != null ? metallicMap.height : smoothnessMap.height;
        Texture2D combinedTexture = new Texture2D(width, height, TextureFormat.RGBA32, false);

        // Make the smoothness texture readable
        TextureImporter smoothnessImporter = AssetImporter.GetAtPath(AssetDatabase.GetAssetPath(smoothnessMap)) as TextureImporter;
        bool smoothnessReadable = smoothnessImporter.isReadable;
        smoothnessImporter.isReadable = true;
        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(smoothnessMap));

        // Handle metallic texture if it exists
        TextureImporter metallicImporter = null;
        bool metallicReadable = false;
        if (metallicMap != null)
        {
            metallicImporter = AssetImporter.GetAtPath(AssetDatabase.GetAssetPath(metallicMap)) as TextureImporter;
            metallicReadable = metallicImporter.isReadable;
            metallicImporter.isReadable = true;
            AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(metallicMap));
        }

        // Get pixels
        Color[] smoothnessPixels = smoothnessMap.GetPixels();
        Color[] metallicPixels = metallicMap != null ? metallicMap.GetPixels() : new Color[smoothnessPixels.Length];
        Color[] newPixels = new Color[smoothnessPixels.Length];

        // Combine channels (R from metallic or black, A from smoothness)
        for (int i = 0; i < smoothnessPixels.Length; i++)
        {
            float metallic = metallicMap != null ? metallicPixels[i].r : 0f;  // Use 0 (black) if no metallic map
            float smoothness = invertSmoothness ? 1 - smoothnessPixels[i].r : smoothnessPixels[i].r;
            newPixels[i] = new Color(metallic, 0, 0, smoothness);
        }

        // Apply pixels and save
        combinedTexture.SetPixels(newPixels);
        combinedTexture.Apply();

        // Encode and save
        byte[] bytes = combinedTexture.EncodeToPNG();
        File.WriteAllBytes(newPath, bytes);

        // Restore original import settings
        if (metallicMap != null)
        {
            metallicImporter.isReadable = metallicReadable;
            AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(metallicMap));
        }
        smoothnessImporter.isReadable = smoothnessReadable;
        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(smoothnessMap));
        AssetDatabase.ImportAsset(newPath);

        Debug.Log("Generated metallic gloss map at: " + newPath);
    }
}

#endif  // UNITY_EDITOR
