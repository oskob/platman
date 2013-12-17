//
//  DrawRect.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-09-25.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "Geom.h"

#ifndef opengles2_DrawRect_h
#define opengles2_DrawRect_h

typedef struct DrawRect : DrawObject
{
	CGRect rect;
	float rotation,
	scale,
	weight,
	friction,
	bounce;
	
	DrawRect(Scene &scene, CGRect rect) : DrawObject(scene)
	{
		this->rect = rect;
		rotation = 0.0f;
		scale = 1.0f;
		weight = 0.0f;
		friction = 0.0f;
		bounce = 0.0f;
	};
	
	virtual ~DrawRect() {};
	
	virtual void draw(GLKMatrix4 &projectionMatrix) {}
	
	virtual void update(double delta) {}
	
	virtual void centerInFrame(CGSize frame)
	{
		rect = GeomCenterRectInRect(rect, frame);
	}
	
}DrawRect;


#endif
