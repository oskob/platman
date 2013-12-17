//
//  Bullet.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-11-12.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "Line.h"

#ifndef opengles2_Bullet_h
#define opengles2_Bullet_h

struct Bullet : Line
{
	
	Bullet(Scene &scene) : Line(scene)
	{
		color = {0.5, 0.5, 0.5, 0.5};
	}
	
	virtual ~Bullet()
	{
	}
	
	virtual void update(double delta)
	{
		opacity -= 0.05;
		if(opacity <= 0.0)
		{
			opacity = 0.0;
			alive = false;
		}
	}
};

#endif
