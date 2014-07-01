Shader "Shantanu Bhadoria/Basic/2 Lambert" {
	Properties {
		_Color( "Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
	}
	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			
			// Pragmas
			#pragma vertex vert
			#pragma fragment frag
			
			// User Defined Variables
			uniform float4 _Color;
			
			// Unity Defined Variables	
			uniform float4 _LightColor0;
			// float4x4 _Object2World;
			// float4x4 _World2Object;
			//float4 _WorldSpaceLightPos0;
			
			// Base Input Structs
			struct vertexInput {
				float4 vertex : POSITION;			
				float3 normal : NORMAL;
			};
			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};
			
			// Vertex Function
			vertexOutput vert(vertexInput v) {
				vertexOutput o;
				
				float3 normalDirection = normalize( mul( float4( v.normal, 0.0 ), _World2Object ).xyz );
				float3 lightDirection;
				float atten = 1.0;
				
				lightDirection = normalize( _WorldSpaceLightPos0.xyz );
				
				float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
				
				o.col = float4(diffuseReflection,1.0);
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				return o;			
			}
			
			// Fragment Function
			float4 frag(vertexOutput i) : COLOR {
				return i.col;
			}
			
			ENDCG	
		}		
	} 
	//FallBack "Diffuse"
}
