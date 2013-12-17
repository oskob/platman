//
//  Renderer.cpp
//  opengles2
//
//  Created by Oskar Öberg on 2013-08-23.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "StandardScene.h"
#include <stdio.h>

#include "AnimationSprite.h"

StandardScene::StandardScene(CGSize viewSize) : Scene(viewSize)
{
	setupVBOs();
	setupPrograms();
}

StandardScene::~StandardScene()
{
	cleanUp(true);
}

void StandardScene::setupVBOs()
{
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glClearColor(1.0, 1.0, 1.0, 1.0);
	glDisable(GL_DEPTH_TEST);
	
	static GLfloat rectVertices[] = {
		-0.5, -0.5, 0.0,
		0.5, -0.5, 0.0,
		-0.5, 0.5, 0.0,
		0.5, 0.5, 0.0
	};
	
	GLfloat textureCoordinates[] = {
		0.0, 1.0,
        1.0, 1.0,
		0.0, 0.0,
        1.0, 0.0
	};
	
	GLfloat lineCoordinates[VBO_LINES_MAX_COUNT*6];
	GLfloat points[VBO_PARTICLES_MAX_COUNT*3];
	
    glGenBuffers(1, &vertexBuffers[kGLVertexBufferRect]);
	glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[kGLVertexBufferRect]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(rectVertices), rectVertices, GL_STATIC_DRAW);
	
	glGenBuffers(1, &vertexBuffers[kGLVertexBufferTextureCoordinates]);
	glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[kGLVertexBufferTextureCoordinates]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(textureCoordinates), textureCoordinates, GL_STATIC_DRAW);
	
	glGenBuffers(1, &vertexBuffers[kGLVertexBufferLines]);
	glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[kGLVertexBufferLines]);
	glBufferData(GL_ARRAY_BUFFER, sizeof(lineCoordinates), lineCoordinates, GL_STREAM_DRAW);

	glGenBuffers(1, &vertexBuffers[kGLVertexBufferLine]);
	glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[kGLVertexBufferLine]);
	glBufferData(GL_ARRAY_BUFFER, sizeof(float)*4, (GLfloat[]){0.0, 0.0, 0.0, 0.0}, GL_STATIC_DRAW);

	
	glGenBuffers(1, &vertexBuffers[kGLVertexBufferPoints]);
	glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[kGLVertexBufferPoints]);
	glBufferData(GL_ARRAY_BUFFER, sizeof(points), points, GL_STREAM_DRAW);
	
	
};

void StandardScene::setupPrograms()
{
	
	programs[kGLProgramTexture] = [GLUtils loadProgramWithVertexShader:@"texture" fragmentShader:@"texture" attributesBlock:^(GLProgram *glProgram) {
		glBindAttribLocation(glProgram->name, GLKVertexAttribPosition, "aPosition");
		glBindAttribLocation(glProgram->name, GLKVertexAttribTexCoord0, "aTextureCoordinates");
		
	}
										uniformsBlock:^(GLProgram *glProgram){
											glProgram->uniforms[kGLUniformModelViewProjectionMatrix] = glGetUniformLocation(glProgram->name, "uModelViewProjectionMatrix");	
											glProgram->uniforms[kGLUniformOpacity] = glGetUniformLocation(glProgram->name, "uOpacity");
											
										}];
	
	
	programs[kGLProgramColor] = [GLUtils loadProgramWithVertexShader:@"color" fragmentShader:@"color" attributesBlock:^(GLProgram *glProgram) {
		glBindAttribLocation(glProgram->name, GLKVertexAttribPosition, "aPosition");
		
	}
										  uniformsBlock:^(GLProgram *glProgram){
											  glProgram->uniforms[kGLUniformModelViewProjectionMatrix] = glGetUniformLocation(glProgram->name, "uModelViewProjectionMatrix");
											  glProgram->uniforms[kGLUniformColor] = glGetUniformLocation(glProgram->name, "uColor");
											  glProgram->uniforms[kGLUniformPointSize] = glGetUniformLocation(glProgram->name, "uPointSize");
											  
										  }];
	
}


void StandardScene::draw(double delta)
{
    glClear(GL_COLOR_BUFFER_BIT);
	
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	GLKMatrix4 baseProjectionMatrix = GLKMatrix4Identity;
	baseProjectionMatrix = GLKMatrix4MakeOrtho(0.0, viewSize.width, 0.0, viewSize.height, 1.0, -1.0);
	
	for(int layerIndex = 0; layerIndex < kLayersMax; layerIndex++)
	{
		std::vector<DrawObject*> *layer = &layers[layerIndex];
		if(layerIndex == kLayersBackgroundColor || layerIndex == kLayersBackgroundColorFixed || layerIndex == kLayersForegroundColor || layerIndex == kLayersForegroundColorFixed)
		{
			glUseProgram(programs[kGLProgramColor].name);
		}
		else
		{
			glUseProgram(programs[kGLProgramTexture].name);
		}
		
		float e;
		switch (layerIndex)
		{
			case kLayersBackgroundFixed:
			case kLayersBackgroundColorFixed:
			case kLayersForegroundColorFixed:
			case kLayersForegroundFixed:
				e = 0.0;
				break;
			case kLayersBackgroundParallax1:
				e = 0.25;
				break;
			case kLayersBackgroundParallax2:
				e = 0.5;
				break;
			case kLayersBackgroundParallax3:
				e = 0.75;
				break;
			default:
				e = 1.0;
				break;
		}
		
		GLKMatrix4 projectionMatrix = GLKMatrix4Translate(baseProjectionMatrix, -((-viewSize.width/2.0)+cameraPosition.x)*e, -((-viewSize.height/2.0)+cameraPosition.y)*e, 0.0);
		
		for(int drawRectIndex = 0; drawRectIndex < layer->size(); drawRectIndex++)
		{
			DrawObject *drawObject = layer->at(drawRectIndex);
			drawObject->draw(projectionMatrix);
		}
	}
}
template <class T> void StandardScene::checkListForDeadObjects(std::vector<T>&list, std::vector<DrawObject*>&deadList, bool force)
{
	for(int i = list.size()-1; i >= 0; i--)
	{
		if(!list.at(i)->alive || force)
		{
			DrawObject *o = list.at(i);
			
			if(std::find(deadList.begin(), deadList.end(), o) == deadList.end())
			{
				deadList.push_back(o);
			}
			list.erase(list.begin() + i);
		}
	}
}

void StandardScene::cleanUp(bool force)
{
	
	std::vector<DrawObject*> deadObjects;
	checkListForDeadObjects(levelCollideList, deadObjects, force);
	checkListForDeadObjects(collideList, deadObjects, force);
	checkListForDeadObjects(updateList, deadObjects, force);
	checkListForDeadObjects(physicsList, deadObjects, force);
	checkListForDeadObjects(buttonList, deadObjects, force);
	
	for(int layerIndex = 0; layerIndex < kLayersMax; layerIndex++)
	{
		std::vector<DrawObject*> &layer = layers[layerIndex];
		checkListForDeadObjects(layer, deadObjects, force);
	}
	
	for(int i = deadObjects.size()-1; i >= 0; i--)
	{
		DrawObject *o = deadObjects.at(i);
		deadObjects.erase(deadObjects.begin() + i);
		delete o;
	}
}

void StandardScene::update(double delta)
{
	
	for(std::unordered_set<GLTouch*>::iterator touchIt = touches.begin(); touchIt != touches.end(); ++touchIt)
	{
		GLTouch *touch = *touchIt;
		
		for(int i = 0; i < buttonList.size(); i++)
		{
			Button *button = buttonList.at(i);
			GLTouchEvent &touchEvent = (GLTouchEvent&)button->touchEvent;
		
			if(touchEvent.touchOver && CGRectContainsPoint(button->drawRect->rect, touch->location))
			{
				touchEvent.touchOver(*this, *button);
			}
			
			if(touch->state == GLTouchStateEnded && touchEvent.touchUpInside && CGRectContainsPoint(button->drawRect->rect, touch->location) && CGRectContainsPoint(button->drawRect->rect, touch->startLocation))
			{
				touchEvent.touchUpInside(*this, *button);
			}
			
			if(touchEvent.touchOut && CGRectContainsPoint(button->drawRect->rect, touch->previousLocation) && !CGRectContainsPoint(button->drawRect->rect, touch->location))
			{
				touchEvent.touchOut(*this, *button);
			}
		}
	}
	
	for(int updateObjectIndex = 0; updateObjectIndex < updateList.size(); updateObjectIndex++)
	{
		updateList.at(updateObjectIndex)->update(delta);
	}

	for(int physicsObjectIndex = 0; physicsObjectIndex < physicsList.size(); physicsObjectIndex++)
	{
		DrawRect *drawObject = (DrawRect*)updateList.at(physicsObjectIndex);
		
		drawObject->rect.origin.x += delta * drawObject->velocity.x;
		drawObject->rect.origin.y += delta * drawObject->velocity.y;
		drawObject->onGround = false;
		
		for(int collideIndex = 0; collideIndex < levelCollideList.size(); collideIndex++)
		{
			DrawRect *collideObject = levelCollideList.at(collideIndex);
			if(collideObject == drawObject) continue;
			
			if(CGRectIntersectsRect(collideObject->rect, drawObject->rect))
			{
				CGRect proposedFrame = drawObject->rect;
				
				float xDist = drawObject->velocity.x > 0 ?
				-(drawObject->rect.origin.x - (collideObject->rect.origin.x - drawObject->rect.size.width)) :
				(collideObject->rect.origin.x + collideObject->rect.size.width) - drawObject->rect.origin.x;
				
				float yDist = xDist * (drawObject->velocity.y / drawObject->velocity.x);
				
				if(yDist > 0 && drawObject->velocity.y > 0.0) yDist = -yDist;
				
				proposedFrame.origin.x += xDist;
				proposedFrame.origin.y += yDist;
				
				if(
					proposedFrame.origin.y + proposedFrame.size.height > collideObject->rect.origin.y &&
					proposedFrame.origin.y < collideObject->rect.origin.y + collideObject->rect.size.height
				)
				{
					drawObject->velocity.x *= -drawObject->bounce;
					if(drawObject->bounce == 0.0)
					{
						proposedFrame.origin.y = drawObject->rect.origin.y;
					}
				}
				else
				{
					proposedFrame = drawObject->rect;
					float yDist = drawObject->velocity.y > 0.0 ?
					(collideObject->rect.origin.y) - (drawObject->rect.origin.y + drawObject->rect.size.height) :
					-(drawObject->rect.origin.y - (collideObject->rect.origin.y + collideObject->rect.size.height));
					
					float xDist = yDist * (drawObject->velocity.x / drawObject->velocity.y);
					
					if(xDist > 0 && drawObject->velocity.x > 0.0)
					{
						xDist = -xDist;
					}
					
					proposedFrame.origin.x += xDist;
					proposedFrame.origin.y += yDist;
					
					drawObject->velocity.y *= -drawObject->bounce;
				}
				drawObject->rect = proposedFrame;
			}
			
			if(
			   drawObject->rect.origin.x + drawObject->rect.size.width > collideObject->rect.origin.x &&
			   drawObject->rect.origin.x < collideObject->rect.origin.x + collideObject->rect.size.width &&
			   drawObject->rect.origin.y == collideObject->rect.origin.y + collideObject->rect.size.height
			)
			{
				drawObject->onGround = true;
			}
		}
		
		if(!drawObject->onGround) // gravity
		{
			drawObject->velocity.y -= delta * drawObject->weight;
		}
		else
		{
			if(drawObject->velocity.y < 10.0) drawObject->velocity.y = 0.0;
			drawObject->velocity.x *= 1.0 - drawObject->friction;
		}
	}
	
	for(int collideIndex1 = 0; collideIndex1 < collideList.size(); collideIndex1++)
	{
		DrawRect *o1 = (DrawRect*)collideList.at(collideIndex1);
		for(int collideIndex2 = collideIndex1+1; collideIndex2 < collideList.size(); collideIndex2++)
		{
			DrawRect *o2 = (DrawRect*)collideList.at(collideIndex2);
			if(CGRectIntersectsRect(o1->rect, o2->rect))
			{
				collide(o1, o2);
			}
		}
	}
	
	cleanUp();
}

void StandardScene::collide(DrawRect *o1, DrawRect *o2)
{
	
}

DrawRect* StandardScene::objectAtPoint(CGPoint point)
{
	
	for(uint i = 0; i < levelCollideList.size(); i++)
	{
		if(CGRectContainsPoint(levelCollideList.at(i)->rect, point))
		{
			return levelCollideList.at(i);
		}
	}
	
	return NULL;
}
