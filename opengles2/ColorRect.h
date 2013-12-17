//
//  ColorRect.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-09-25.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#ifndef opengles2_ColorRect_h
#define opengles2_ColorRect_h



typedef struct ColorRect : DrawRect
{
	GLColor color;
	
	ColorRect(Scene &scene, CGRect rect, GLColor color) : DrawRect(scene, rect)
	{
		this->color = color;
	}
	
	virtual ~ColorRect()
	{
	}
	
	virtual void draw(GLKMatrix4 &projectionMatrix)
	{
		
		GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
		modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, rect.origin.x, rect.origin.y, 0.0);
		modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, rect.size.width*scale, rect.size.height*scale, 0.0);
		modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.5, 0.5, 0.0);
		modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, rotation, 0.0f, 0.0f, 1.0f);
		
		glBindBuffer(GL_ARRAY_BUFFER, scene.vertexBuffers[kGLVertexBufferRect]);
		
		glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
		glEnableVertexAttribArray(GLKVertexAttribPosition);
		
		glUniformMatrix4fv(scene.programs[kGLProgramTexture].uniforms[kGLUniformModelViewProjectionMatrix], 1, 0, GLKMatrix4Multiply(projectionMatrix, modelViewMatrix).m);
		
		float colorf[] = {color.r, color.g, color.b, color.a};
		
		glUniform4fv(scene.programs[kGLProgramColor].uniforms[kGLUniformColor], 1, colorf);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		
		
	}
}ColorRect;



#endif
