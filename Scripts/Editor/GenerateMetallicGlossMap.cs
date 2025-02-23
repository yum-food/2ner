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

        if (GUILayout.Button("Generate Metallic Gloss Map") && metallicMap != null && smoothnessMap != null)
        {
            GenerateMap();
        }
    }

    private void GenerateMap()
    {
        // Get path of metallic map
        string path = AssetDatabase.GetAssetPath(metallicMap);
        string directory = Path.GetDirectoryName(path);
        string newPath = Path.Combine(directory, metallicMap.name + "_metallicgloss.png");

        // Create new texture
        int width = metallicMap.width;
        int height = metallicMap.height;
        Texture2D combinedTexture = new Texture2D(width, height, TextureFormat.RGBA32, false);

        // Make the texture readable
        TextureImporter metallicImporter = AssetImporter.GetAtPath(AssetDatabase.GetAssetPath(metallicMap)) as TextureImporter;
        TextureImporter smoothnessImporter = AssetImporter.GetAtPath(AssetDatabase.GetAssetPath(smoothnessMap)) as TextureImporter;

        bool metallicReadable = metallicImporter.isReadable;
        bool smoothnessReadable = smoothnessImporter.isReadable;

        metallicImporter.isReadable = true;
        smoothnessImporter.isReadable = true;

        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(metallicMap));
        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(smoothnessMap));

        // Get pixels
        Color[] metallicPixels = metallicMap.GetPixels();
        Color[] smoothnessPixels = smoothnessMap.GetPixels();
        Color[] newPixels = new Color[metallicPixels.Length];

        // Combine channels (R from metallic, A from smoothness)
        for (int i = 0; i < metallicPixels.Length; i++)
        {
            float smoothness = invertSmoothness ? 1 - smoothnessPixels[i].r : smoothnessPixels[i].r;
            newPixels[i] = new Color(
                metallicPixels[i].r,    // Metallic in R
                0,                      // Empty G
                0,                      // Empty B
                smoothness              // Smoothness in A (inverted if flag is set)
            );
        }

        // Apply pixels and save
        combinedTexture.SetPixels(newPixels);
        combinedTexture.Apply();

        // Encode and save
        byte[] bytes = combinedTexture.EncodeToPNG();
        File.WriteAllBytes(newPath, bytes);

        // Restore original import settings
        metallicImporter.isReadable = metallicReadable;
        smoothnessImporter.isReadable = smoothnessReadable;

        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(metallicMap));
        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(smoothnessMap));
        AssetDatabase.ImportAsset(newPath);

        Debug.Log("Generated metallic gloss map at: " + newPath);
    }
}

#endif  // UNITY_EDITOR
