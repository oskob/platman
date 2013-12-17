//
//  AtlasSprite.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-09-25.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "Sprite.h"
#include <vector>

#ifndef opengles2_AtlasSprite_h
#define opengles2_AtlasSprite_h

typedef struct AtlasSprite : Sprite
{
	int tileIndex,
	cols,
	rows;
	
	CGSize texturePadding;
	
	virtual std::vector<float> textureCoordinates()
	{
		int col = tileIndex % cols,
		row = (int)floorf(tileIndex / cols);
		
		CGRect drawRect = getDrawRect();
		
		float x = (drawRect.size.width*col)/texture.size.width,
		y = (drawRect.size.height*row)/texture.size.height,
		w = drawRect.size.width / texture.size.width,
		h = drawRect.size.height / texture.size.height;
		
		if(flipped)
		{
			return std::vector<float>{
				x+w,
				y+h,
				x,
				y+h,
				x+w,
				y,
				x,
				y
			};
		}
		else
		{
			return std::vector<float>{
				x,
				y+h,
				x+w,
				y+h,
				x,
				y,
				x+w,
				y
			};
		}
	}
	
	AtlasSprite(Scene &scene, CGRect rect, CGSize padding, std::string const& textureName) : Sprite(scene, rect, textureName)
	{
		tileIndex = 0;
		this->padding = padding;
		CGRect drawRect = getDrawRect();
		cols = drawRect.size.width == 0.0 ? 1 : (int)floorf(texture.size.width / drawRect.size.width);
		rows = drawRect.size.height == 0.0 ? 1 : (int)floorf(texture.size.height / drawRect.size.height);
		texturePadding = CGSizeMake((int)texture.size.width % (int)drawRect.size.width, (int)texture.size.height%(int)drawRect.size.height);

	}
	
	virtual ~AtlasSprite() {};
	
	virtual void draw(GLKMatrix4 &projectionMatrix)
	{
		
		int col = tileIndex % cols,
		row = (int)floorf(tileIndex / cols);
		
		CGRect drawRect = getDrawRect();
		
		textureRect = CGRectMake(
			drawRect.size.width*col,
			drawRect.size.height*row,
			drawRect.size.width,
			drawRect.size.height
		);
		
		Sprite::draw(projectionMatrix);
	}
	
	
}AtlasSprite;


#endif
