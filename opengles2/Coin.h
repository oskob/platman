//
//  Coin.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-09-30.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#ifndef opengles2_Coin_h
#define opengles2_Coin_h

typedef struct Coin : AnimationSprite
{
	Coin(Scene &scene) : AnimationSprite(scene, CGRectMake(0.0, 0.0, 8.0, 12.0), CGSizeMake(4.0, 2.0), "level")
	{
		frameSpeed = 1.0/5.0;
		std::vector<int> rotate({8, 9, 10, 11});
		animations.push_back(rotate);
		tileIndex = 8;
	};
	
	virtual void update(double delta)
	{
		AnimationSprite::update(delta);
	}
	
}Coin;



#endif
