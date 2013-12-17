//
//  Hero.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-09-25.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "AnimationSprite.h"
#include "Bullet.h"

#ifndef opengles2_Hero_h
#define opengles2_Hero_h



typedef struct Hero : AnimationSprite
{
	typedef enum kHeroAnimation
	{
		kHeroAnimationStand,
		kHeroAnimationWalk,
		kHeroAnimationJump,
		kHeroAnimationFall
	}kHeroAnimation;
	
	double shootInterval;
	double shootCooldown;
	double shootSpread;
	
	Hero(Scene &scene) : AnimationSprite(scene, CGRectMake(0.0, 0.0, 7.0, 16.0), CGSizeMake(4.0, 1.0), "hero")
	{
		tileIndex = 1;
		weight = 300.0;
		frameSpeed = 1.0/10.0;
		shootInterval = 0.1;
		shootCooldown = 0.0;
		shootSpread = 0.3;
		
		std::vector<int> stand({0});
		std::vector<int> walk({1, 2, 3, 2});
		std::vector<int> jump({5});
		std::vector<int> fall({6});
		
		animations.reserve(4);
		animations.push_back(stand);
		animations.push_back(walk);
		animations.push_back(jump);
		animations.push_back(fall);
		
	}
	
	virtual ~Hero() {}
	
	virtual void draw(GLKMatrix4 &projectionMatrix)
	{
		AnimationSprite::draw(projectionMatrix);
	}
		
	virtual void update(double delta)
	{
		AnimationSprite::update(delta);
		if(velocity.y > 0.1)
		{
			setAnimation(kHeroAnimationJump);
		}
		else if(velocity.y < -0.1)
		{
			setAnimation(kHeroAnimationFall);
		}
		else if(abs(velocity.x) > 5.0)
		{
			setAnimation(kHeroAnimationWalk);
		}
		else if(onGround)
		{
			setAnimation(kHeroAnimationStand);
		}
		
		if(shootCooldown > 0.0)
		{
			shootCooldown -= delta;
			if(shootCooldown < 0.0)
			{
				shootCooldown = 0.0;
			}
		}
	}
	
	void shoot()
	{
		if(shootCooldown > 0.0)
		{
			return;
		}
		shootCooldown = shootInterval;
		
		StandardScene &tScene = (StandardScene&)scene;
		
		
		CGPoint pStart = CGPointMake(rect.origin.x, rect.origin.y+10.0);
		CGPoint pEnd = pStart;
		
		float bulletStepX = flipped ? -10.0 : 10.0;
		float bulletStepY = (RANDOM * shootSpread) - shootSpread/2.0;
		float bulletDistanceX = 0.0;
		
		DrawRect *collideObject = NULL;
		
		while(collideObject == NULL && abs(bulletDistanceX) < 500)
		{
			bulletDistanceX += bulletStepX;
			pEnd.x = pStart.x + bulletDistanceX;
			pEnd.y += bulletStepY;
			collideObject = tScene.objectAtPoint(pEnd);
		}
		
		if(collideObject)
		{
			pEnd.x = flipped ? collideObject->rect.origin.x + collideObject->rect.size.width : collideObject->rect.origin.x;
		}
		
		Bullet *bullet = new Bullet(scene);
		bullet->a = pStart;
		bullet->b = pEnd;
		
		tScene.layers[kLayersForegroundColor].push_back(bullet);
		tScene.updateList.push_back(bullet);
		
	}
}Hero;


#endif
