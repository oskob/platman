//
//  TestScene.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-08-29.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "StandardScene.h"
#include "Hero.h"
#include "Sequencer.h"

#define HERO_WALK_MAX_VEL 60.0
#define HERO_WALK_ACC 20.0
#define HERO_JUMP_VEL 150.0
#define HERO_FRICTION 0.2
#define CAMERA_PADDING 30.0

#ifndef __opengles2__TestScene__
#define __opengles2__TestScene__


class TestScene : public StandardScene
{
public:
	Sequencer sequencer;
	Hero *hero;
	TestScene(CGSize viewSize);
	virtual void update(double delta);
	virtual void collide(DrawRect *o1, DrawRect *o2);
};



#endif /* defined(__opengles2__TestScene__) */
