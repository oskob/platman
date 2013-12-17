//
//  AnimationSprite.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-09-25.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "AtlasSprite.h"
#include <string>

#ifndef opengles2_AnimationSprite_h
#define opengles2_AnimationSprite_h


typedef struct AnimationSprite : AtlasSprite
{
	int currentAnimation;
	int currentFrame;
	double frameSpeed;
	double frameDelta;
	
	std::vector<std::vector<int>> animations;
	
	AnimationSprite(Scene &scene, CGRect rect, CGSize padding, std::string const& textureName) : AtlasSprite(scene, rect, padding, textureName)
	{
		texture = scene.getTexture(textureName);
		currentAnimation = 0;
		currentFrame = 0;
		frameSpeed = 1.0/10.0;
		frameDelta = 0.0;
	}
	
	virtual ~AnimationSprite() {}
	
	void setAnimation(int animationIndex)
	{
		if(animationIndex == currentAnimation) return;
		currentFrame = 0;
		currentAnimation = animationIndex;
		frameDelta = frameSpeed;
	}
	
	virtual void update(double delta)
	{
		DrawRect::update(delta);
		frameDelta += delta;
		if(frameDelta >= frameSpeed)
		{
			frameDelta -= frameSpeed;
			currentFrame++;
			if(currentFrame >= animations.at(currentAnimation).size() )
			{
				currentFrame = 0;
			}
			tileIndex = animations.at(currentAnimation).at(currentFrame);
		}
		
	}
	
}AnimationSprite;


#endif
