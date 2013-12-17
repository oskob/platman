//
//  Scene.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-08-29.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//


#include <map>
#include <set>
#include <unordered_set>
#include <string>
#import "GLUtils.h"
#import <GLKit/GLKit.h>

#ifndef __opengles2__Scene__
#define __opengles2__Scene__

typedef enum
{
	kGLUniformModelViewProjectionMatrix,
	kGLUniformTexture,
	kGLUniformColor,
	kGLUniformPointSize,
	kGLUniformOpacity,
	kGLUniformMax
} kGLUniform;

typedef enum
{
	kGLVertexBufferRect,
	kGLVertexBufferTextureCoordinates,
	kGLVertexBufferPoint,
	kGLVertexBufferLine,
	kGLVertexBufferLines,
	kGLVertexBufferPoints,
	kGLVertexBufferMax
}kGLVertexBuffer;

typedef enum
{
	kGLProgramTexture,
	kGLProgramColor,
	kGLProgramMax
}kGLProgram;

typedef struct GLColor
{
	GLfloat r;
	GLfloat g;
	GLfloat b;
	GLfloat a;
}GLColor;

typedef struct GLTexture
{
	GLuint name;
	CGSize size;
	
	GLTexture()
	{
		name = -1;
		size = CGSizeZero;
	}
}GLTexture;

typedef struct GLProgram
{
	GLuint name;
	GLint uniforms[kGLUniformMax];
}GLProgram;

typedef enum GLTouchState
{
	GLTouchStateNew,
	GLTouchStateNormal,
	GLTouchStateEnded
}GLTouchState;

typedef struct GLTouch
{
	GLTouchState state;
	CGPoint startLocation;
	CGPoint location;
	CGPoint previousLocation;
}GLTouch;

class Scene
{

public:
	GLuint vertexBuffers[kGLVertexBufferMax];
	GLProgram programs[kGLProgramMax];
	
	std::map<std::string, GLTexture> textures;
	
	std::unordered_set<GLTouch*> touches;
	
	CGSize viewSize;
	
	Scene(CGSize viewSize);
	
	GLTexture getTexture(std::string const& imageName);
	CGRect rectFromRelativeCoordinates(float x, float y, float width, float height);
	
	virtual void draw(double delta);
	virtual void update(double delta);
	
	virtual ~Scene();
};

#endif /* defined(__opengles2__Scene__) */
