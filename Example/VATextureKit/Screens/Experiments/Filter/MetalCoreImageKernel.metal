//
//  MetalCoreImageKernel.metal
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 28.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include <CoreImage/CoreImage.h>

extern "C" {
    namespace coreimage {

        float pseudo_rand(int x, int y, int z) {
            int seed = x + y * 57 + z * 241;
            seed = (seed<< 13) ^ seed;
            return (( 1.0 - ( (seed * (seed * seed * 15731 + 789221) + 1376312589) & 2147483647) / 1073741824.0f) + 1.0f) / 2.0f;
        }

        float4 dropPixels(coreimage::sample_t sample, float rand, destination dest) {
            float2 coord = dest.coord();
            float value = fract(sin(dot(dest.coord() + pseudo_rand(coord.x, coord.y, rand), float2(12.9898, 78.233))) * 43758.5453);
            float alpha;
            if (value > 0.5) {
                alpha = 1;
            } else {
                alpha = 0;
            }
            return float4(sample.r, sample.g, sample.b, alpha) * sample.a;
        }
    }
}
