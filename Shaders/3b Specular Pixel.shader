Shader "Shantanu Bhadoria/Basic/3a Specular PixelShader" {
	Properties {
		_Color( "Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
		_SpecColor( "Specular Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
		_Shininess( "Shininess", float ) = 10
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
			uniform float4 _SpecColor;	
			uniform float _Shininess;
			
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
				float4 posWorld : TEXCOORD0;
				float3 normalDir : TEXCOORD1;
				float4 col : COLOR;
			};
			
			// Vertex Function
			vertexOutput vert(vertexInput v) {
				vertexOutput o;
				
				o.posWorld = mul(_Object2World, v.vertex);
				o.normalDir = normalize( mul( float4( v.normal, 0.0 ), _World2Object ).xyz );;
				
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				return o;

			}
			
			// Fragment Function
			float4 frag(vertexOutput i) : COLOR {
							
				float3 normalDirection = i.normalDir;
				float3 viewDirection = normalize( _WorldSpaceCameraPos.xyz - i.posWorld.xyz );
				float3 lightDirection;
				float atten = 1.0;
				
				lightDirection = normalize( _WorldSpaceLightPos0.xyz );
				
				float3 diffuseReflection = atten * _LightColor0.xyz * max( 0.0, dot( normalDirection, lightDirection ) );
				float3 specularReflection = atten * _SpecColor.rgb * max( 0.0, dot( normalDirection, lightDirection ) ) * pow( max( 0.0, dot( reflect( -lightDirection, normalDirection ), viewDirection ) ), _Shininess );
				float3 lightFinal = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;
				
				return float4( lightFinal * _Color.rgb, 1.0 );
			}
			
			ENDCG	
		}		
	} 
	//FallBack "Diffuse"
}
