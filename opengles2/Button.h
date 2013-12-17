//
//  Header.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-10-24.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "DrawRect.h"
#include <functional>

#ifndef opengles2_Header_h
#define opengles2_Header_h

class Button;

typedef struct GLTouchEvent
{
	
	std::function<void(Scene&, Button&)> touchUpInside;
	std::function<void(Scene&, Button&)> touchDown;
	std::function<void(Scene&, Button&)> touchOver;
	std::function<void(Scene&, Button&)> touchOut;
	
}GLTouchEvent;

struct Button : DrawObject
{
	DrawRect *drawRect;
	GLTouchEvent touchEvent;
	
	Button(Scene &scene, DrawRect *drawRect, GLTouchEvent touchEvent) : DrawObject(scene), touchEvent(touchEvent)
	{
		this->drawRect = drawRect;
	}
	
	virtual ~Button()
	{
		delete drawRect;
		drawRect = NULL;
	}
	
	
};

#endif
