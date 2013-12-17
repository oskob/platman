//
//  GLUtils.c
//  opengles2
//
//  Created by Oskar Öberg on 2013-08-13.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include <stdio.h>
#include <OpenGLES/EAGL.h>
#include "GLUtils.h"
#include "Scene.h"

GLuint GLUtilsLoadShader(std::string const& shaderSrc, GLenum type)
{
	GLuint shader;
	GLint compiled;
	
	shader = glCreateShader(type);
	if(shader == 0)
		return 0;
	
	const char *shaderSrcC = shaderSrc.c_str();
	
	glShaderSource(shader, 1, &shaderSrcC, NULL);
	glCompileShader(shader);
	glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
	
	if(!compiled)
	{
		GLint infoLen = 0;
		glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
		if(infoLen > 1)
		{
			char* infoLog = (char*)malloc(sizeof(char) * infoLen);
			glGetShaderInfoLog(shader, infoLen, NULL, infoLog);
			NSLog(@"Error compiling shader:\n%s\n", infoLog);
			free(infoLog);
		}
		glDeleteShader(shader);
		return 0;
	}
	return shader;
}

GLuint GLUtilsLoadTexture(std::string const& imageName, CGSize *textureSize)
{
	
	CGImageRef spriteImage = [UIImage imageNamed:[NSString stringWithUTF8String:imageName.c_str()]].CGImage;
    if (!spriteImage)
	{
        NSLog(@"Failed to load image %s", imageName.c_str());
        exit(1);
    }
	
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
	
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
	
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
													   CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
	
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);
	
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
	
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
	
    free(spriteData);
	
	if(textureSize)
	{
		textureSize->width = (CGFloat)width;
		textureSize->height = (CGFloat)height;
	}
	
    return texName;
}

@implementation GLUtils

+ (GLProgram)loadProgramWithVertexShader:(NSString*)vertexShader fragmentShader:(NSString*)fragmentShader attributesBlock:(void(^)(GLProgram *glProgram))attributesBlock uniformsBlock:(void(^)(GLProgram *program))uniformsBlock;
{
	GLuint programName = glCreateProgram();
	
	GLProgram glProgram;
	glProgram.name = programName;
	
	NSString *vertShaderSrc = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:vertexShader ofType:@"vsh"] encoding:NSUTF8StringEncoding error:nil];
	
	NSString *fragShaderSrc = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fragmentShader ofType:@"fsh"] encoding:NSUTF8StringEncoding error:nil];
	
	GLuint fragShader = GLUtilsLoadShader(fragShaderSrc.UTF8String, GL_FRAGMENT_SHADER);
	GLuint vertShader = GLUtilsLoadShader(vertShaderSrc.UTF8String, GL_VERTEX_SHADER);
	
	glAttachShader(programName, vertShader);
    glAttachShader(programName, fragShader);
	
    attributesBlock(&glProgram);
	
	GLint status;
	glLinkProgram(programName);
	
	
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(programName, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(programName, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(programName, GL_LINK_STATUS, &status);
    if (status == 0) {
		NSLog(@"Failed to link program");
    }
	
	uniformsBlock(&glProgram);
	
	return glProgram;
}




@end