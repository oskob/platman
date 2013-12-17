//
//  ScalableSprite.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-11-07.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "Sprite.h"

#ifndef opengles2_ScalableSprite_h
#define opengles2_ScalableSprite_h

struct ScalableSprite : DrawRect
{
	Sprite sprite;
	CGSize insets;
	ScalableSprite(Scene &scene, CGRect rect, std::string const& textureName, CGSize insets) : DrawRect(scene, rect), sprite(scene, CGRectMake(0.0, 0.0, 0.0, 0.0), textureName)
	{
		this->insets = insets;
	}
	
	virtual void draw(GLKMatrix4 &projectionMatrix)
	{
		sprite.opacity = opacity;
		for(int i = 0; i < 9; i++)
		{
			switch (i) {
				case 0:
					sprite.rect = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height-insets.height, insets.width, insets.height);
					sprite.textureRect = CGRectMake(0.0, 0.0, insets.width, insets.height);
					break;

				case 1:
					sprite.rect = CGRectMake(rect.origin.x+insets.width, rect.origin.y + rect.size.height-insets.height, rect.size.width-(insets.width*2), insets.height);
					sprite.textureRect = CGRectMake(insets.width, 0.0, 1.0, insets.height);
					break;
					
				case 2:
					sprite.rect = CGRectMake(rect.origin.x+rect.size.width-insets.width, rect.origin.y + rect.size.height-insets.height, insets.width, insets.height);
					sprite.textureRect = CGRectMake(insets.width+1.0, 0.0, insets.width, insets.height);
					break;
					
				case 3:
					sprite.rect = CGRectMake(rect.origin.x, rect.origin.y + insets.height, insets.width, rect.size.height-(insets.height*2.0));
					sprite.textureRect = CGRectMake(0.0, insets.height, insets.width, 1.0);
					break;
					
				case 4:
					sprite.rect = CGRectMake(rect.origin.x + insets.width, rect.origin.y + insets.height, rect.size.width-(insets.width*2.0), rect.size.height-(insets.height*2.0));
					sprite.textureRect = CGRectMake(insets.width, insets.height, 1.0, 1.0);
					break;
				
				case 5:
					sprite.rect = CGRectMake(rect.origin.x + rect.size.width - insets.width, rect.origin.y + insets.height, insets.width, rect.size.height-(insets.height*2.0));
					sprite.textureRect = CGRectMake(insets.width + 1.0, insets.height, insets.width, 1.0);
					break;
					
				case 6:
					sprite.rect = CGRectMake(rect.origin.x, rect.origin.y, insets.width, insets.height);
					sprite.textureRect = CGRectMake(0.0, insets.height+1.0, insets.width, insets.height);
					break;
					
				case 7:
					sprite.rect = CGRectMake(rect.origin.x + insets.width, rect.origin.y, rect.size.width-(insets.width*2.0), insets.height);
					sprite.textureRect = CGRectMake(insets.width, insets.height+1.0, 1.0, insets.height);
					break;
					
				case 8:
					sprite.rect = CGRectMake(rect.origin.x + rect.size.width - insets.width, rect.origin.y, insets.width, insets.height);
					sprite.textureRect = CGRectMake(insets.width + 1.0, insets.height + 1.0, insets.width, insets.width);
					break;
					
				default:
					return;
					break;
			}
			
			sprite.draw(projectionMatrix);
		}
	}
};

#endif
