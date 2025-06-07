using UnityEngine;
using System.Collections.Generic;

public class DecodeVertexVectors : MonoBehaviour
{
    [Header("Edge Interpolation")]
    [SerializeField] private int edgeSubdivisions = 5;
    [SerializeField] private float edgeGizmoScale = 0.3f;
    [SerializeField] private Color edgeVectorColor = new Color(0.5f, 0.8f, 1f, 0.7f);
    [SerializeField] private float edgeLineThickness = 2f;

    private Vector3[] decodedVertexVectors;

    void Start()
    {
        var mesh = GetComponent<MeshFilter>().mesh;
        var vertexColors = mesh.colors;

        if (vertexColors.Length == 0)
        {
            Debug.LogError("No vertex colors found on mesh!");
            return;
        }

        decodedVertexVectors = new Vector3[vertexColors.Length];

        for (int i = 0; i < vertexColors.Length; i++)
        {
            decodedVertexVectors[i] = DecodeVectorFromColor(vertexColors[i]);
        }
    }

    Vector3 DecodeVectorFromColor(Color color)
    {
        return new Vector3(
            -(color.r * 2.0f - 1.0f),
             (color.g * 2.0f - 1.0f),
             (color.b * 2.0f - 1.0f)) / color.a;
    }

    private void OnDrawGizmos()
    {
        var meshFilter = GetComponent<MeshFilter>();
        if (meshFilter == null) return;

        var mesh = meshFilter.sharedMesh;
        if (mesh == null) return;

        var vertices = mesh.vertices;
        var vertexColors = mesh.colors;

        DrawInterpolatedEdges(mesh, vertices, vertexColors);
    }

    void DrawInterpolatedEdges(Mesh mesh, Vector3[] vertices, Color[] vertexColors)
    {
        var triangles = mesh.triangles;
        HashSet<(int, int)> drawnEdges = new HashSet<(int, int)>();

        Gizmos.color = edgeVectorColor;

        for (int i = 0; i < triangles.Length; i += 3)
        {
            // Draw edges for each triangle
            for (int j = 0; j < 3; j++)
            {
                int v1 = triangles[i + j];
                int v2 = triangles[i + ((j + 1) % 3)];

                // Ensure we don't draw the same edge twice
                var edge = v1 < v2 ? (v1, v2) : (v2, v1);
                if (drawnEdges.Contains(edge)) continue;
                drawnEdges.Add(edge);

                if (v1 >= vertices.Length || v2 >= vertices.Length ||
                    v1 >= vertexColors.Length || v2 >= vertexColors.Length)
                    continue;

                // Interpolate along the edge
                for (int k = 0; k <= edgeSubdivisions; k++)
                {
                    float t = k / (float)edgeSubdivisions;

                    // Interpolate position
                    Vector3 localPos = Vector3.Lerp(vertices[v1], vertices[v2], t);
                    Vector3 worldPos = transform.TransformPoint(localPos);

                    // Interpolate color
                    Color interpolatedColor = Color.Lerp(vertexColors[v1], vertexColors[v2], t);

                    // Decode vector from interpolated color
                    Vector3 decodedVector = DecodeVectorFromColor(interpolatedColor);
                    Vector3 worldVector = transform.TransformDirection(decodedVector);

                    // Draw the interpolated vector
                    Vector3 start = worldPos;
                    Vector3 end = worldPos + worldVector * edgeGizmoScale;
                    Gizmos.DrawSphere(end, 0.02f);
                    Gizmos.DrawLine(start, end);
                }
            }
        }
    }
}
