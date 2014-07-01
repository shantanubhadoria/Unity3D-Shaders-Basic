Shader "Shantanu Bhadoria/Basic/7 Normal Map" {
	Properties {
		_Color ( "Color Tint", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
		_MainTex ("Diffuse Texture", 2D) = "white" {}
		_BumpMap ("Normal Texture", 2D) = "bump" {}
		_BumpDepth ("Bump Depth", Range( -2.0, 2.0 )) = 1
		_SpecColor( "Specular Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
		_Shininess( "Shininess", float ) = 10
		_RimColor( "Rim Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
		_RimPower( "Rim Power", Range( 0.1, 10.0 )) = 3.0
	}
	SubShader {
		Pass{
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers flash
			
			// User Defined Variables
			uniform float4 _Color;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _BumpMap;
			uniform float4 _BumpMap_ST;
			uniform float _BumpDepth;
			uniform float4 _SpecColor;
			uniform float _Shininess;
			uniform float4 _RimColor;
			uniform float _RimPower;
			
			// Unity Defined Variables;
			uniform float4 _LightColor0;
			
			// Base Input Structs
			struct vertexInput {
				float4 vertex: POSITION;
				float3 normal: NORMAL;
				float4 texcoord: TEXCOORD0;
				float4 tangent: TANGENT;
			};
			struct vertexOutput {
				float4 pos: SV_POSITION;
				float4 tex: TEXCOORD0;
				float4 posWorld: TEXCOORD1;
				float3 normalWorld: TEXCOORD2;
				float3 tangentWorld: TEXCOORD3;
				float3 binormalWorld: TEXCOORD4;
			};
			
			// Vertex Function
			vertexOutput vert( vertexInput v ) {
				vertexOutput o;
				
				o.normalWorld = normalize( mul( float4( v.normal, 0.0 ), _World2Object ).xyz );		
				o.tangentWorld = normalize( mul( _Object2World, v.tangent ).xyz );
				o.binormalWorld = normalize( cross( o.normalWorld, o.tangentWorld ) );
						
				o.posWorld = mul( _Object2World, v.vertex );
				o.pos = mul( UNITY_MATRIX_MVP, v.vertex );
				o.tex = v.texcoord;
				
				return o;
			}
			
			// Fragment Function
			float4 frag( vertexOutput i ): COLOR {
				float3 viewDirection = normalize( _WorldSpaceCameraPos.xyz - i.posWorld.xyz );
				float3 lightDirection;
				float atten;
				
				if( _WorldSpaceLightPos0.w == 0.0 ) { // Directional Light
					atten = 1.0;
					lightDirection = normalize( _WorldSpaceLightPos0.xyz );
				} else {
					float3 fragmentToLightSource = _WorldSpaceLightPos0.xyz - i.posWorld.xyz;
					float distance = length( fragmentToLightSource );
					float atten = 1 / distance;
					lightDirection = normalize( fragmentToLightSource );
				}
				
				// Texture Maps
				float4 tex = tex2D( _MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw );
				float4 texN = tex2D( _BumpMap, i.tex.xy * _BumpMap_ST.xy + _BumpMap_ST.zw );
				
				// unpackNormal Function
				float3 localCoords = float3(2.0 * texN.ag - float2(1.0,1.0), 0.0);
				//localCoords.z = 1.0 - 0.5 * dot( localCoords, localCoords );
				//localCoords.z = 1.0;
				localCoords.z = _BumpDepth;
				
				// Normal Transpose Matrix
				float3x3 local2WorldTranspose = float3x3(
					i.tangentWorld,
					i.binormalWorld,
					i.normalWorld
				);
				
				// Calculate Normal Direction
				float3 normalDirection = normalize( mul( localCoords, local2WorldTranspose ) );
				
				// Lighting
				float3 diffuseReflection = atten * _LightColor0.rgb * saturate( dot( normalDirection, lightDirection ) );
				float3 specularReflection = diffuseReflection * _SpecColor.rgb * pow( saturate( dot( reflect( -lightDirection, normalDirection ), viewDirection ) ), _Shininess);
				
				// Rim Lighting
				float rim = 1 - saturate( dot( viewDirection, normalDirection ) );
				float3 rimLighting = saturate( pow( rim, _RimPower ) * _RimColor.rgb * diffuseReflection);
				float3 lightFinal = diffuseReflection + specularReflection + rimLighting + UNITY_LIGHTMODEL_AMBIENT.rgb;
				

				return float4( tex.xyz * lightFinal * _Color.xyz, 1.0);
			}
			
			ENDCG
		}
		Pass{
			Tags { "LightMode" = "ForwardAdd" }
			Blend One One
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers flash
			
			// User Defined Variables
			uniform float4 _Color;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _BumpMap;
			uniform float4 _BumpMap_ST;
			uniform float _BumpDepth;
			uniform float4 _SpecColor;
			uniform float _Shininess;
			uniform float4 _RimColor;
			uniform float _RimPower;
			
			// Unity Defined Variables;
			uniform float4 _LightColor0;
			
			// Base Input Structs
			struct vertexInput {
				float4 vertex: POSITION;
				float3 normal: NORMAL;
				float4 texcoord: TEXCOORD0;
				float4 tangent: TANGENT;
			};
			struct vertexOutput {
				float4 pos: SV_POSITION;
				float4 tex: TEXCOORD0;
				float4 posWorld: TEXCOORD1;
				float3 normalWorld: TEXCOORD2;
				float3 tangentWorld: TEXCOORD3;
				float3 binormalWorld: TEXCOORD4;
			};
			
			// Vertex Function
			vertexOutput vert( vertexInput v ) {
				vertexOutput o;
				
				o.normalWorld = normalize( mul( float4( v.normal, 0.0 ), _World2Object ).xyz );		
				o.tangentWorld = normalize( mul( _Object2World, v.tangent ).xyz );
				o.binormalWorld = normalize( cross( o.normalWorld, o.tangentWorld ) );
						
				o.posWorld = mul( _Object2World, v.vertex );
				o.pos = mul( UNITY_MATRIX_MVP, v.vertex );
				o.tex = v.texcoord;
				
				return o;
			}
			
			// Fragment Function
			float4 frag( vertexOutput i ): COLOR {
				float3 viewDirection = normalize( _WorldSpaceCameraPos.xyz - i.posWorld.xyz );
				float3 lightDirection;
				float atten;
				
				if( _WorldSpaceLightPos0.w == 0.0 ) { // Directional Light
					atten = 1.0;
					lightDirection = normalize( _WorldSpaceLightPos0.xyz );
				} else {
					float3 fragmentToLightSource = _WorldSpaceLightPos0.xyz - i.posWorld.xyz;
					float distance = length( fragmentToLightSource );
					float atten = 1 / distance;
					lightDirection = normalize( fragmentToLightSource );
				}
				
				// Texture Maps
				float4 tex = tex2D( _MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw );
				float4 texN = tex2D( _BumpMap, i.tex.xy * _BumpMap_ST.xy + _BumpMap_ST.zw );
				
				// unpackNormal Function
				float3 localCoords = float3(2.0 * texN.ag - float2(1.0,1.0), 0.0);
				//localCoords.z = 1.0 - 0.5 * dot( localCoords, localCoords );
				//localCoords.z = 1.0;
				localCoords.z = _BumpDepth;
				
				// Normal Transpose Matrix
				float3x3 local2WorldTranspose = float3x3(
					i.tangentWorld,
					i.binormalWorld,
					i.normalWorld
				);
				
				// Calculate Normal Direction
				float3 normalDirection = normalize( mul( localCoords, local2WorldTranspose ) );
				
				// Lighting
				float3 diffuseReflection = atten * _LightColor0.rgb * saturate( dot( normalDirection, lightDirection ) );
				float3 specularReflection = diffuseReflection * _SpecColor.rgb * pow( saturate( dot( reflect( -lightDirection, normalDirection ), viewDirection ) ), _Shininess);
				
				// Rim Lighting
				float rim = 1 - saturate( dot( viewDirection, normalDirection ) );
				float3 rimLighting = saturate( pow( rim, _RimPower ) * _RimColor.rgb * diffuseReflection);
				float3 lightFinal = diffuseReflection + specularReflection + rimLighting;
				

				return float4( tex.xyz * lightFinal * _Color.xyz, 1.0);
			}
			
			ENDCG
		}		
	} 
	//FallBack "Specular"
}
