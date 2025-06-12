using UnityEngine;
using System.Collections.Generic;
using System.Linq;

public class DecodeVertexVectors : MonoBehaviour
{
    [Header("Display Settings")]
    [SerializeField] private int maxVertices = 100;
    [SerializeField] private float vectorScale = 0.3f;
    
    [Header("Edge Visualization")]
    [SerializeField] private bool showEdges = true;
    [SerializeField] private int edgeSubdivisions = 2;
    
    [Header("Orientation")]
    [SerializeField] private bool showOrientations = true;
    [SerializeField] private float orientationScale = 1.0f;
    
    [Header("UV Channels")]
    [SerializeField] private int quaternionXYChannel = 1;
    [SerializeField] private int quaternionZWChannel = 2;
    
    [Header("Colors")]
    [SerializeField] private Color vectorColor = new Color(0.5f, 0.8f, 1f);
    [SerializeField] private Color correctedVectorColor = new Color(1f, 0.5f, 0.2f);
    [SerializeField] private Color forwardColor = Color.blue;

    private void OnDrawGizmos()
    {
        var meshFilter = GetComponent<MeshFilter>();
        if (!meshFilter || !meshFilter.sharedMesh) return;
        
        var mesh = meshFilter.sharedMesh;
        var vertices = mesh.vertices;
        var colors = mesh.colors;
        
        // Draw vertex vectors from colors
        if (colors != null && colors.Length > 0)
        {
            DrawVertexVectors(mesh, vertices, colors);
        }
        
        // Draw orientations from UVs
        if (showOrientations)
        {
            DrawOrientations(mesh, vertices);
        }
    }
    
    void DrawVertexVectors(Mesh mesh, Vector3[] vertices, Color[] colors)
    {
        Vector2[] uvXY = GetUVData(mesh, quaternionXYChannel);
        Vector2[] uvZW = GetUVData(mesh, quaternionZWChannel);
        bool hasQuaternions = uvXY != null && uvZW != null;
        
        int vertexStep = Mathf.Max(1, vertices.Length / maxVertices);
        
        // Draw vectors at vertices
        for (int i = 0; i < vertices.Length; i += vertexStep)
        {
            if (i >= colors.Length) break;
            
            Vector3 worldPos = transform.TransformPoint(vertices[i]);
            Vector3 decodedVector = DecodeVectorFromColor(colors[i]);
            
            // Basic vector
            Gizmos.color = vectorColor;
            DrawVector(worldPos, transform.TransformDirection(decodedVector), vectorScale);
            
            // Quaternion-corrected vector
            if (hasQuaternions && i < uvXY.Length && i < uvZW.Length)
            {
                Quaternion quat = GetQuaternionFromUV(uvXY[i], uvZW[i]);
                Vector3 corrected = quat * decodedVector;
                
                Gizmos.color = correctedVectorColor;
                DrawVector(worldPos, transform.TransformDirection(corrected), vectorScale);
            }
        }
        
        // Draw edge interpolations
        if (showEdges && edgeSubdivisions > 0)
        {
            DrawEdgeInterpolations(mesh, vertices, colors, uvXY, uvZW);
        }
    }
    
    void DrawEdgeInterpolations(Mesh mesh, Vector3[] vertices, Color[] colors, Vector2[] uvXY, Vector2[] uvZW)
    {
        var triangles = mesh.triangles;
        HashSet<(int, int)> drawnEdges = new HashSet<(int, int)>();
        bool hasQuaternions = uvXY != null && uvZW != null;
        
        for (int i = 0; i < triangles.Length && drawnEdges.Count < maxVertices/2; i += 3)
        {
            for (int j = 0; j < 3; j++)
            {
                int v1 = triangles[i + j];
                int v2 = triangles[i + ((j + 1) % 3)];
                
                var edge = v1 < v2 ? (v1, v2) : (v2, v1);
                if (!drawnEdges.Add(edge)) continue;
                
                if (v1 >= vertices.Length || v2 >= vertices.Length ||
                    v1 >= colors.Length || v2 >= colors.Length) continue;
                
                // Draw subdivisions along edge
                for (int k = 1; k < edgeSubdivisions; k++)
                {
                    float t = k / (float)edgeSubdivisions;
                    Vector3 pos = Vector3.Lerp(vertices[v1], vertices[v2], t);
                    Color col = Color.Lerp(colors[v1], colors[v2], t);
                    
                    Vector3 worldPos = transform.TransformPoint(pos);
                    Vector3 vec = DecodeVectorFromColor(col);
                    
                    // Basic vector
                    Gizmos.color = vectorColor * 0.7f; // Slightly dimmer for edge points
                    DrawVector(worldPos, transform.TransformDirection(vec), vectorScale * 0.8f);
                    
                    // Quaternion-corrected vector
                    if (hasQuaternions && v1 < uvXY.Length && v2 < uvXY.Length && 
                        v1 < uvZW.Length && v2 < uvZW.Length)
                    {
                        Vector2 interpXY = Vector2.Lerp(uvXY[v1], uvXY[v2], t);
                        Vector2 interpZW = Vector2.Lerp(uvZW[v1], uvZW[v2], t);
                        Quaternion interpQuat = GetQuaternionFromUV(interpXY, interpZW);
                        Vector3 corrected = interpQuat * vec;
                        
                        Gizmos.color = correctedVectorColor * 0.7f; // Slightly dimmer for edge points
                        DrawVector(worldPos, transform.TransformDirection(corrected), vectorScale * 0.8f);
                    }
                }
            }
        }
    }
    
    void DrawOrientations(Mesh mesh, Vector3[] vertices)
    {
        Vector2[] uvXY = GetUVData(mesh, quaternionXYChannel);
        Vector2[] uvZW = GetUVData(mesh, quaternionZWChannel);
        
        if (uvXY == null || uvZW == null) return;
        
        int vertexStep = Mathf.Max(1, vertices.Length / maxVertices);
        
        for (int i = 0; i < vertices.Length; i += vertexStep)
        {
            if (i >= uvXY.Length || i >= uvZW.Length) break;
            
            Vector3 worldPos = transform.TransformPoint(vertices[i]);
            Quaternion quat = GetQuaternionFromUV(uvXY[i], uvZW[i]);
            
            // Draw forward direction
            Gizmos.color = forwardColor;
            Vector3 forward = transform.TransformDirection(quat * Vector3.forward);
            DrawArrow(worldPos, forward, orientationScale);
        }
    }
    
    void DrawVector(Vector3 origin, Vector3 direction, float scale)
    {
        Vector3 end = origin + direction * scale;
        Gizmos.DrawLine(origin, end);
        Gizmos.DrawSphere(end, 0.02f);
    }
    
    void DrawArrow(Vector3 origin, Vector3 direction, float length)
    {
        Vector3 end = origin + direction * length;
        Gizmos.DrawLine(origin, end);
        
        // Simple arrowhead
        Vector3 right = Vector3.Cross(direction, Vector3.up).normalized;
        if (right.magnitude < 0.01f)
            right = Vector3.Cross(direction, Vector3.right).normalized;
            
        Vector3 arrowBack = -direction * length * 0.2f;
        Vector3 arrowSide = right * length * 0.1f;
        
        Gizmos.DrawLine(end, end + arrowBack + arrowSide);
        Gizmos.DrawLine(end, end + arrowBack - arrowSide);
    }
    
    Quaternion GetQuaternionFromUV(Vector2 xy, Vector2 zw)
    {
        return new Quaternion(xy.x, xy.y, zw.x, zw.y).normalized;
    }
    
    Vector3 DecodeVectorFromColor(Color color)
    {
        return new Vector3(
            color.r * 2.0f - 1.0f,
            color.g * 2.0f - 1.0f,
            color.b * 2.0f - 1.0f) / color.a;
    }
    
    Vector2[] GetUVData(Mesh mesh, int channel)
    {
        switch (channel)
        {
            case 0: return mesh.uv;
            case 1: return mesh.uv2;
            case 2: return mesh.uv3;
            case 3: return mesh.uv4;
            case 4: return mesh.uv5;
            case 5: return mesh.uv6;
            case 6: return mesh.uv7;
            case 7: return mesh.uv8;
            default: return null;
        }
    }
}
