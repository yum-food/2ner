using UnityEngine;
using System.Collections.Generic;

public class DecodeVertexVectors : MonoBehaviour
{
    [Header("Edge Interpolation")]
    [SerializeField] private int edgeSubdivisions = 5;
    [SerializeField] private float edgeGizmoScale = 0.3f;
    [SerializeField] private Color edgeVectorColor = new Color(0.5f, 0.8f, 1f, 0.7f);
    [SerializeField] private Color correctedVectorColor = new Color(1f, 0.5f, 0.2f, 0.7f);

    [Header("Orientation Visualization")]
    [SerializeField] private bool showOrientations = true;
    [SerializeField] private bool showAllAxes = true;
    [SerializeField] private float orientationVectorLength = 1.0f;

    [Header("UV Channels")]
    [SerializeField] private int quaternionXYChannel = 1;
    [SerializeField] private int quaternionZWChannel = 2;

    [Header("Colors")]
    [SerializeField] private Color forwardColor = Color.blue;
    [SerializeField] private Color rightColor = Color.red;
    [SerializeField] private Color upColor = Color.green;

    private void OnDrawGizmos()
    {
        var meshFilter = GetComponent<MeshFilter>();
        if (meshFilter == null) return;

        var mesh = meshFilter.sharedMesh;
        if (mesh == null) return;

        var vertices = mesh.vertices;
        var vertexColors = mesh.colors;

        if (vertexColors != null && vertexColors.Length > 0)
        {
            DrawInterpolatedEdges(mesh, vertices, vertexColors);
        }

        if (showOrientations)
        {
            DrawOrientations(mesh, vertices);
        }
    }

    void DrawInterpolatedEdges(Mesh mesh, Vector3[] vertices, Color[] vertexColors)
    {
        var triangles = mesh.triangles;
        HashSet<(int, int)> drawnEdges = new HashSet<(int, int)>();

        Vector2[] uvXY = GetUVData(mesh, quaternionXYChannel);
        Vector2[] uvZW = GetUVData(mesh, quaternionZWChannel);
        bool hasQuaternions = uvXY != null && uvZW != null && uvXY.Length > 0 && uvZW.Length > 0;

        for (int i = 0; i < triangles.Length; i += 3)
        {
            for (int j = 0; j < 3; j++)
            {
                int v1 = triangles[i + j];
                int v2 = triangles[i + ((j + 1) % 3)];

                var edge = v1 < v2 ? (v1, v2) : (v2, v1);
                if (drawnEdges.Contains(edge)) continue;
                drawnEdges.Add(edge);

                if (v1 >= vertices.Length || v2 >= vertices.Length ||
                    v1 >= vertexColors.Length || v2 >= vertexColors.Length)
                    continue;

                bool canUseQuaternions = hasQuaternions && 
                    v1 < uvXY.Length && v2 < uvXY.Length &&
                    v1 < uvZW.Length && v2 < uvZW.Length;

                for (int k = 0; k <= edgeSubdivisions; k++)
                {
                    float t = k / (float)edgeSubdivisions;

                    Vector3 localPos = Vector3.Lerp(vertices[v1], vertices[v2], t);
                    Vector3 worldPos = transform.TransformPoint(localPos);

                    Color interpolatedColor = Color.Lerp(vertexColors[v1], vertexColors[v2], t);
                    Vector3 decodedVector = DecodeVectorFromColor(interpolatedColor);

                    Gizmos.color = edgeVectorColor;
                    Vector3 worldVector = transform.TransformDirection(decodedVector);
                    DrawVector(worldPos, worldVector, edgeGizmoScale);

                    if (canUseQuaternions)
                    {
                        Quaternion q1 = GetQuaternionFromUV(uvXY[v1], uvZW[v1]);
                        Quaternion q2 = GetQuaternionFromUV(uvXY[v2], uvZW[v2]);
                        // Slerp is more correct, but lerp is what we'll actually get in the shader.
                        Quaternion interpolatedQuat = Quaternion.Lerp(q1, q2, t);

                        Vector3 correctedVector = interpolatedQuat * decodedVector;
                        Vector3 worldCorrectedVector = transform.TransformDirection(correctedVector);

                        Gizmos.color = correctedVectorColor;
                        DrawVector(worldPos, worldCorrectedVector, edgeGizmoScale);
                    }
                }
            }
        }
    }

    void DrawVector(Vector3 origin, Vector3 direction, float scale)
    {
        Vector3 end = origin + direction * scale;
        Gizmos.DrawSphere(end, 0.02f);
        Gizmos.DrawLine(origin, end);
    }

    Quaternion GetQuaternionFromUV(Vector2 xy, Vector2 zw)
    {
        float x = xy.x;
        float y = xy.y;
        float z = zw.x;
        float w = zw.y;

        return new Quaternion(x, y, z, w).normalized;
    }

    void DrawOrientations(Mesh mesh, Vector3[] vertices)
    {
        Vector2[] uvXY = GetUVData(mesh, quaternionXYChannel);
        Vector2[] uvZW = GetUVData(mesh, quaternionZWChannel);

        if (uvXY == null || uvZW == null || uvXY.Length == 0 || uvZW.Length == 0) return;

        int vertexCount = Mathf.Min(vertices.Length, uvXY.Length, uvZW.Length);

        for (int vertIdx = 0; vertIdx < vertexCount; vertIdx++)
        {
            Quaternion quat = GetQuaternionFromUV(uvXY[vertIdx], uvZW[vertIdx]);

            Vector3 worldPos = transform.TransformPoint(vertices[vertIdx]);

            Vector3 forward = transform.TransformDirection(quat * Vector3.forward);
            DrawArrow(worldPos, forward, forwardColor, orientationVectorLength);

            if (showAllAxes)
            {
                Vector3 right = transform.TransformDirection(quat * Vector3.right);
                Vector3 up = transform.TransformDirection(quat * Vector3.up);
                DrawArrow(worldPos, right, rightColor, orientationVectorLength * 0.8f);
                DrawArrow(worldPos, up, upColor, orientationVectorLength * 0.8f);
            }
        }
    }

    void DrawArrow(Vector3 origin, Vector3 direction, Color color, float length)
    {
        Gizmos.color = color;

        Vector3 end = origin + direction * length;
        Gizmos.DrawLine(origin, end);

        Vector3 right = Vector3.Cross(direction, Vector3.up).normalized;
        if (right.magnitude < 0.01f)
            right = Vector3.Cross(direction, Vector3.right).normalized;

        Vector3 arrowBack = -direction * length * 0.2f;
        Vector3 arrowSide = right * length * 0.1f;

        Gizmos.DrawLine(end, end + arrowBack + arrowSide);
        Gizmos.DrawLine(end, end + arrowBack - arrowSide);

        Gizmos.DrawSphere(origin, 0.05f);
    }

    n (-1 to 1), aVectorontains scale factor.
    /// </summary>

        return new Vector3(
             (color.r * 2.0f - 1.0f),
             (color.g * 2.0f - 1.0f),
             (color.b * 2.0f - 1.0f)) / color.a;
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
