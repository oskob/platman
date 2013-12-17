//
//  BenchScene.cpp
//  opengles2
//
//  Created by Oskar Öberg on 2013-08-29.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "BenchScene.h"

BenchScene::BenchScene(CGSize viewSize) : StandardScene(viewSize)
{
	texName = GLUtilsLoadTexture("trollface", NULL);
}

void BenchScene::draw()
{
	static float a = 0.0;
	
	float feed = (sin(a)/2)+0.5f;
	
	glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);
	
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	GLKMatrix4 projectionMatrix = GLKMatrix4Identity;
	projectionMatrix = GLKMatrix4MakeOrtho(0.0, viewSize.width, 0.0, viewSize.height, 1.0, -1.0);
	
	// textured rects
	
	glUseProgram(programs[kGLProgramTexture].name);
	
	for(int i = 0; i < 100; i++)
	{
		CGRect rect = CGRectMake(RANDOM*viewSize.width, RANDOM*viewSize.height, 50.0, 50.0);
		
		GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
		modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, rect.origin.x, rect.origin.y, 0.0);
		modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, rect.size.width, rect.size.height, 0.0);
		modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, ((feed) * M_PI)-(M_PI/2), 0.0f, 0.0f, 1.0f);
		
		glBindTexture(GL_TEXTURE_2D, texName);
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[kGLVertexBufferRect]);
		
		glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
		glEnableVertexAttribArray(GLKVertexAttribPosition);
		
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[kGLVertexBufferTextureCoordinates]);
		
		glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, 0);
		glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
		
		glUniformMatrix4fv(programs[kGLProgramTexture].uniforms[kGLUniformModelViewProjectionMatrix], 1, 0, GLKMatrix4Multiply(projectionMatrix, modelViewMatrix).m);
		glUniform1i(programs[kGLProgramTexture].uniforms[kGLUniformTexture], 0);
		
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	}
	
	glDisable(GL_TEXTURE_2D);
	glUseProgram(programs[kGLProgramColor].name);
	
	// lines
	
	for(int i = 0; i < 1; i++)
	{
		GLfloat line[] = {
			feed, 0.0, 0.0,
			1.0, feed, 0.0,
			0.0, feed, 0.0,
			feed, 1.0, 0.0
			
		};
		
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[kGLVertexBufferLines]);
		glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(line), &line);
		
		glEnableVertexAttribArray(GLKVertexAttribPosition);
		glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
		
		float color[] = {1.0f, 0.0f, 0.0f, 1.0f};
		
		GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
		modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 100.0, 100.0, 0.0);
		modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, 100.0, 100.0, 0.0);
		
		glUniformMatrix4fv(programs[kGLProgramColor].uniforms[kGLUniformModelViewProjectionMatrix], 1, 0, GLKMatrix4Multiply(projectionMatrix, modelViewMatrix).m);
		glUniform4fv(programs[kGLProgramColor].uniforms[kGLUniformColor], 1, color);
		
		glDrawArrays(GL_LINES, 0, 4);
	}
	
	// colored rects
	
	for(int i = 0; i < 1000; i++)
	{
		float size = 1.0;
		float color[] = {0.0f, 1.0f, 0.0f, 1.0f};
		
		CGRect rect = CGRectMake(RANDOM*viewSize.width, RANDOM*viewSize.height, size, size);
		
		GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
		modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, rect.origin.x, rect.origin.y, 0.0);
		modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, rect.size.width, rect.size.height, 0.0);
		
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[kGLVertexBufferRect]);
		
		glEnableVertexAttribArray(GLKVertexAttribPosition);
		glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
		
		glUniformMatrix4fv(programs[kGLProgramColor].uniforms[kGLUniformModelViewProjectionMatrix], 1, 0, GLKMatrix4Multiply(projectionMatrix, modelViewMatrix).m);
		glUniform4fv(programs[kGLProgramColor].uniforms[kGLUniformColor], 1, color);
		
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	}
	
	// particles
	
	GLfloat points[VBO_PARTICLES_MAX_COUNT*3];
	
	for(int i = 0; i < sizeof(points)/sizeof(GLfloat); i++)
	{
		if(i % 3 == 2) points[i] = 0.0;
		else points[i] = RANDOM;
	}
	
	GLfloat pointSize = 2.0;
	
	glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[kGLVertexBufferPoints]);
	glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(points), &points);
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
	
	float color[] = {1.0f, 0.0f, 0.0f, 1.0f};
	
	GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
	modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, viewSize.width, viewSize.height, 0.0);
	
	glUniformMatrix4fv(programs[kGLProgramColor].uniforms[kGLUniformModelViewProjectionMatrix], 1, 0, GLKMatrix4Multiply(projectionMatrix, modelViewMatrix).m);
	glUniform4fv(programs[kGLProgramColor].uniforms[kGLUniformColor], 1, color);
	glUniform1fv(programs[kGLProgramColor].uniforms[kGLUniformPointSize], 1, &pointSize);
	
	glDrawArrays(GL_POINTS, 0, sizeof(points)/sizeof(GLfloat)/3);

}

void BenchScene::update()
{
	
}