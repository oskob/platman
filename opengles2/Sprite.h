//
//  Sprite.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-09-25.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include <string>

#ifndef opengles2_Sprite_h
#define opengles2_Sprite_h

typedef struct Sprite : DrawRect
{
	GLTexture texture;
	bool flipped;
	CGSize padding;
	CGRect textureRect;

	
	Sprite(Scene &scene, CGRect rect, std::string const& textureName) : DrawRect(scene, rect)
	{
		texture = scene.getTexture(textureName);
		flipped = false;
		padding = CGSizeMake(0.0, 0.0);
		textureRect = CGRectMake(0.0, 0.0, texture.size.width, texture.size.height);
	}
	
	virtual ~Sprite() {};
	
	virtual CGRect getDrawRect()
	{
		return CGRectMake(rect.origin.x - padding.width, rect.origin.y - padding.height, rect.size.width+(padding.width*2), rect.size.height+(padding.height*2));
	}
	
	virtual void draw(GLKMatrix4 &projectionMatrix)
	{
		CGRect drawRect = getDrawRect();
		
		GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
		modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, drawRect.origin.x, drawRect.origin.y, 0.0);
		modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, drawRect.size.width*scale, drawRect.size.height*scale, 0.0);
		modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.5, 0.5, 0.0);
		modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, rotation, 0.0f, 0.0f, 1.0f);
		
		float textureCoords[8] = {
			(flipped ? textureRect.origin.x + textureRect.size.width : textureRect.origin.x) / texture.size.width,
			(textureRect.origin.y + textureRect.size.height) / texture.size.height,
			(flipped ? textureRect.origin.x : textureRect.origin.x + textureRect.size.width ) / texture.size.width,
			(textureRect.origin.y + textureRect.size.height) / texture.size.height,
			(flipped ? textureRect.origin.x + textureRect.size.width : textureRect.origin.x) / texture.size.width, textureRect.origin.y / texture.size.height,
			(flipped ? textureRect.origin.x : textureRect.origin.x + textureRect.size.width ) / texture.size.width,
			textureRect.origin.y / texture.size.height
		};
		
		glBindTexture(GL_TEXTURE_2D, texture.name);
		glBindBuffer(GL_ARRAY_BUFFER, scene.vertexBuffers[kGLVertexBufferRect]);
		glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
		
		// optimization: store tex coords per sprite type in a VBO and use that instead of dynamically generating
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, &textureCoords);
		
		glUniformMatrix4fv(scene.programs[kGLProgramTexture].uniforms[kGLUniformModelViewProjectionMatrix], 1, 0, GLKMatrix4Multiply(projectionMatrix, modelViewMatrix).m);
		
		glUniform1f(scene.programs[kGLProgramTexture].uniforms[kGLUniformOpacity], opacity);
		
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	}
	
}Sprite;

#endif
