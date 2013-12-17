//
//  GLUtils2.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-08-14.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include <string>

typedef struct GLCoordinate
{
	int x, y;
}GLCoordinate;

static inline GLCoordinate GLCoordinateMake(int x, int y)
{
	return (GLCoordinate) {x, y};
}

struct GLProgram;


GLuint GLUtilsLoadTexture(std::string const& imageName, CGSize *textureSize);
GLuint GLUtilsLoadShader(std::string const& shaderSrc, GLenum type);


@interface GLUtils: NSObject

+ (GLProgram)loadProgramWithVertexShader:(NSString*)vertexShader fragmentShader:(NSString*)fragmentShader attributesBlock:(void(^)(GLProgram *glProgram))attributesBlock uniformsBlock:(void(^)(GLProgram *program))uniformsBlock;

@end