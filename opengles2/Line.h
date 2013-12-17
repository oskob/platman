//
//  Line.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-09-25.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "DrawObject.h"

#ifndef opengles2_Line_h
#define opengles2_Line_h

typedef struct Line : DrawObject
{
	CGPoint a;
	CGPoint b;
	GLColor color;
	
	Line(Scene &scene) : DrawObject(scene)
	{
		a = CGPointZero;
		b = CGPointZero;
		color = {1.0, 0.0, 0.0, 1.0};
	}
	
	virtual void draw(GLKMatrix4 &projectionMatrix)
	{
		GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
		
		const GLfloat line[] =
		{
			a.x, a.y,
			b.x, b.y
		};
		
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		//glBufferData(scene.vertexBuffers[kGLVertexBufferLine], sizeof(float)*4, line, GL_STATIC_DRAW);
		
		glEnableVertexAttribArray(GLKVertexAttribPosition);
		glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, line);
		
		glUniformMatrix4fv(scene.programs[kGLProgramTexture].uniforms[kGLUniformModelViewProjectionMatrix], 1, 0, GLKMatrix4Multiply(projectionMatrix, modelViewMatrix).m);
		
		float colorf[] = {color.r, color.g, color.b, color.a*opacity};
		
		glUniform4fv(scene.programs[kGLProgramColor].uniforms[kGLUniformColor], 1, colorf);
		glDrawArrays(GL_LINES, 0, 2);
	}
	
	virtual void update(double delta)
	{
	}
	
}Line;

#endif
