//
//  DrawObject.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-09-25.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//
#include "Scene.h"
#include "UpdateObject.h"

#ifndef opengles2_DrawObject_h
#define opengles2_DrawObject_h


typedef struct DrawObject : UpdateObject
{
	Scene &scene;
	CGPoint	velocity;
	float opacity;
	bool onGround;
	bool alive;
	
	DrawObject(Scene &scene) : scene(scene)
	{
		this->scene = scene;
		velocity = CGPointMake(0.0f, 0.0f);
		opacity = 1.0f;
		onGround = false;
		alive = true;
	};
	
	virtual ~DrawObject() {};
	
	virtual void draw(GLKMatrix4 &projectionMatrix) {}
	virtual void update(double delta) {}
	
}DrawObject;


#endif
