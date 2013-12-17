//
//  TestScene.cpp
//  opengles2
//
//  Created by Oskar Öberg on 2013-08-29.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "TestScene.h"
#include "ColorRect.h"
#include "TileSprite.h"
#include "TextSprite.h"
#include "Coin.h"
#include "Button.h"
#include "Geom.h"
#include "ScalableSprite.h"
#include "Bullet.h"

template <class T>
BOOL isType(DrawObject *o)
{
	T* t = dynamic_cast<T*>(o);
	return t != NULL;
}

template <class T>
DrawObject *getOtherObjectIfOneIsType(DrawObject *o1, DrawObject *o2)
{
	if(isType<T>(o1))
	{
		return o2;
	}
	else if(isType<T>(o2))
	{
		return o1;
	}
	return NULL;
}


void walkRight(Scene &scene, Button &button)
{
	TestScene &t = (TestScene&)scene;
	t.hero->velocity.x += HERO_WALK_ACC * (t.hero->onGround ? 1.0 : 0.5);
	if(t.hero->velocity.x > HERO_WALK_MAX_VEL) t.hero->velocity.x = HERO_WALK_MAX_VEL;
	t.hero->friction = 0.0;
}

void walkLeft(Scene &scene, Button &button)
{
	TestScene &t = (TestScene&)scene;
	t.hero->velocity.x -= HERO_WALK_ACC * (t.hero->onGround ? 1.0 : 0.5);
	if(t.hero->velocity.x < -HERO_WALK_MAX_VEL) t.hero->velocity.x = -HERO_WALK_MAX_VEL;
	t.hero->friction = 0.0;
}

void jump(Scene &scene, Button &button)
{
	TestScene &tScene = ((TestScene&)scene);
	if(tScene.hero->onGround)
	{
		tScene.hero->velocity.y = HERO_JUMP_VEL;
	}
}

void cancelJump(Scene &scene, Button &button)
{
	TestScene & tScene = ((TestScene&)scene);
	if(tScene.hero->velocity.y > 0.0)
	{
		tScene.hero->velocity.y *= 0.5;
	}
}

void shoot(Scene &scene, Button &button)
{
	TestScene & tScene = ((TestScene&)scene);
	tScene.hero->shoot();
}

TestScene::TestScene(CGSize viewSize) : StandardScene(viewSize)
{
	
	TextSprite *text = new TextSprite(*this, CGRectMake(0.0, 0.0, 16.0, 16.0), "letters", "level 1");
	
	text->centerInFrame(this->viewSize);
	
	sequencer.addTimedEvent(2.0, [this, text] ()
	{
		sequencer.addContinuousEvent([text] (double delta) -> bool
		{
			text->opacity -= delta;
			if(text->opacity <= 0.0)
			{
				text->alive = false;
				return false;
			}
			return true;
		});
	});

	layers[kLayersForegroundFixed].push_back(text);
	
	hero = new Hero(*this);

	hero->rect.origin.x = 150.0;
	hero->rect.origin.y = 80.0;
	hero->friction = HERO_FRICTION;
	
	cameraPosition = hero->rect.origin;
	
	updateList.push_back(hero);
	physicsList.push_back(hero);
	layers[kLayersHero].push_back(hero);
	
	ColorRect *background = new ColorRect(*this, CGRectMake(0.0, 0.0, viewSize.width, viewSize.height), {162.0/255.0, 187.0/255.0, 242.0/255.0, 1.0});
	layers[kLayersBackgroundColorFixed].push_back(background);
	
	
	ScalableSprite *shootArea = new ScalableSprite(*this, rectFromRelativeCoordinates(0.05, 0.05, 0.15, 0.2), "box", CGSizeMake(3.0, 3.0));
	shootArea->opacity = 0.5;
	layers[kLayersForegroundFixed].push_back(shootArea);

	ScalableSprite *touchArea = new ScalableSprite(*this, rectFromRelativeCoordinates(0.65, 0.05, 0.3, 0.3), "box", CGSizeMake(3.0, 3.0));
	touchArea->opacity = 0.5;
	layers[kLayersForegroundFixed].push_back(touchArea);

	GLTouchEvent leftButtonEvents;
	leftButtonEvents.touchOver = &walkLeft;

	GLTouchEvent rightButtonEvents;
	rightButtonEvents.touchOver = &walkRight;
	
	GLTouchEvent jumpButtonEvents;
	jumpButtonEvents.touchOver = &jump;
	jumpButtonEvents.touchOut = &cancelJump;

	GLTouchEvent shootButtonEvents;
	shootButtonEvents.touchOver = &shoot;
	
	Button *leftButton = new Button(*this, new ColorRect(*this, rectFromRelativeCoordinates(0.65, 0.05, 0.1, 0.3), {1.0, 0.0, 0.0, 1.0}), leftButtonEvents);
	
	Button *rightButton = new Button(*this, new ColorRect(*this, rectFromRelativeCoordinates(0.85, 0.05, 0.1, 0.3), {1.0, 0.0, 0.0, 1.0}), rightButtonEvents);
	
	Button *jumpButton = new Button(*this, new ColorRect(*this, rectFromRelativeCoordinates(0.65, 0.2, 0.3, 0.15), {1.0, 0.0, 0.0, 1.0}), jumpButtonEvents);
	
	Button *shootButton = new Button(*this, shootArea, shootButtonEvents);
	
	buttonList.push_back(leftButton);
	buttonList.push_back(rightButton);
	buttonList.push_back(jumpButton);
	buttonList.push_back(shootButton);
	

	

	
	TileSprite *tile = new TileSprite(*this, CGRectMake(-16.0*5.0, -16.0*4.0, 16.0, 16.0), "level", 30);
	
	std::vector<int> tileIndexes = {
		 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1,-1,-1,-1,-1,-1, 0, 0, 0, 0, 0, 0,-1,-1,-1,-1,-1,-1,-1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1,-1, 5, 6, 7,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1,-1, 2, 3, 4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, 1, 1, 1, 1, 1, 1,
 		 1, 1, 1, 1, 1, 1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, 1, 1, 1, 1, 1, 1,
		 0, 0, 0, 0, 0, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, 0, 0, 0, 0, 0, 0
	};
	tile->setTiles(tileIndexes);
	tile->velocity = CGPointMake(100.0, 0.0);
	tile->friction = 0.0;
	tile->weight = 0.0;
	
	// hit level
	
	DrawRect *rect;
	
	rect = new DrawRect(*this, CGRectMake(0.0, 0.0, 16.0*20.0, 31.0));
	levelCollideList.push_back(rect);
	
	rect = new DrawRect(*this, CGRectMake(96.0, 48.0, 96.0, 15.0));
	levelCollideList.push_back(rect);
	
	rect = new DrawRect(*this, CGRectMake(0.0, 0.0, 16.0, viewSize.height));
	levelCollideList.push_back(rect);

	rect = new DrawRect(*this, CGRectMake(16.0*19.0, 0.0, 16.0, viewSize.height));
	levelCollideList.push_back(rect);
	
	rect = new DrawRect(*this, CGRectMake(38.0, 90.0, 35.0, 5.0));
	levelCollideList.push_back(rect);
	
	/*
	for(int i = 0; i < levelCollideList.size(); i++)
	{
		ColorRect *rect = (ColorRect*)levelCollideList.at(i);
		rect->color = {1.0, 0.0, 0.0, 0.5};
		layers[kLayersForegroundColor].push_back(rect);
	}
	*/
	
	layers[kLayersLevel].push_back(tile);
	
	int coinCoords[4][2] = {{13, 7}, {14,7}, {2,9}, {4,7}};
	
	for(int i = 0; i < 4; i++)
	{
		Coin *coin = new Coin(*this);
		coin->rect.origin.x = 16.0*coinCoords[i][0];
		coin->rect.origin.y = 16.0*coinCoords[i][1];
		layers[kLayersLevel].push_back(coin);
		updateList.push_back(coin);
		collideList.push_back(coin);
	}
	
	collideList.push_back(hero);
	
};

void TestScene::update(double delta)
{
	sequencer.update(delta);
	
	hero->friction = HERO_FRICTION;
	StandardScene::update(delta);
	if(hero->velocity.x > 1.0)
	{
		hero->flipped = false;
	}
	else if(hero->velocity.x < -1.0)
	{
		hero->flipped = true;
	}
	
	CGPoint cameraTarget = {cameraPosition.x, cameraPosition.y};
	
	static CGSize cameraPadding = {(CGFloat)(viewSize.width / 8.0), (CGFloat)(viewSize.height / 8.0)};
	
	if(cameraTarget.x < hero->rect.origin.x - cameraPadding.width)
	{
		cameraTarget.x = hero->rect.origin.x - cameraPadding.width;
	}
	else if(cameraTarget.x > hero->rect.origin.x + cameraPadding.width)
	{
		cameraTarget.x = hero->rect.origin.x + cameraPadding.width;
	}
	
	if(cameraTarget.y < hero->rect.origin.y - cameraPadding.height)
	{
		cameraTarget.y = hero->rect.origin.y - cameraPadding.height;
	}
	else if(cameraTarget.y > hero->rect.origin.y + cameraPadding.height)
	{
		cameraTarget.y = hero->rect.origin.y + cameraPadding.height;
	}
	
	cameraPosition.x += (cameraTarget.x - cameraPosition.x) * 0.1;
	cameraPosition.y += (cameraTarget.y - cameraPosition.y) * 0.1;
	 
}


void TestScene::collide(DrawRect *o1, DrawRect *o2)
{
	
	StandardScene::collide(o1, o2);
	DrawObject *o = getOtherObjectIfOneIsType<Hero>(o1, o2);
	
	if(o && isType<Coin>(o))
	{
		o->alive = false;
	}
	
}


