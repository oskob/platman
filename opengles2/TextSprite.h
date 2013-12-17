//
//  TextSprite.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-10-08.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include <string>
#include "TileSprite.h"

#ifndef opengles2_TextSprite_h
#define opengles2_TextSprite_h

const int newLineIndex = -2;

typedef struct TextSprite : DrawRect
{
	AtlasSprite letterSprite;
	float letterSpacing;
	float lineSpacing;
	CGSize textSize;
	std::vector<int> indexes;
	std::vector<int> letterWidths;
	
	TextSprite(Scene &scene, CGRect rect, std::string const& textureName, std::string const& text) : DrawRect(scene, rect), letterSprite(scene, CGRectMake(0.0, 0.0, rect.size.width, rect.size.height), CGSizeZero, textureName)
	{
		std::string letters = "abcdefghijklmnopqrstuvwxyz0123456789!., ";
		letterWidths = std::vector<int>({
			10, 10, 10,  9,  9,  9, 10, 10,
			 6, 10,  9, 10, 11, 10, 10,  9,
			11, 10, 10, 10, 11, 11, 16, 10,
			11,  9, 10,  5,  9,  9, 11,  9,
			11, 10, 11, 11,  5,  5,  4,  5
		});
		
		letterSpacing = 1.0;
		lineSpacing = 12.0;
		textSize.width = 0.0;
		textSize = CGSizeZero;
		float lineWidth = 0.0;
		
		for(int i = 0; i < text.length(); i++)
		{
			int index;

			if(*text.substr(i, 1).c_str() == '\n')
			{
				index = newLineIndex;
				textSize.height += rect.size.height + lineSpacing;
				lineWidth = 0.0;
			}
			else
			{
				index = letters.find(text[i]);
			}
			
			if(index != -1)
			{
				if(index >= 0 && index < letterWidths.size()-1)
				{
					lineWidth += letterWidths.at(index);
				}
				if(lineWidth > textSize.width) textSize.width = lineWidth;
				indexes.push_back(index);
			}
		}
		
	}
	
	virtual ~TextSprite()
	{
	}
	
	virtual void draw(GLKMatrix4 &projectionMatrix)
	{
		float x = 0.0;
		float y = 0.0;
		letterSprite.opacity = opacity;
		
		for(int i = 0; i < indexes.size(); i++)
		{
			if(indexes[i] == newLineIndex)
			{
				y -= lineSpacing;
				x = 0.0;
			}
			else
			{
				letterSprite.rect.origin.x = this->rect.origin.x + x;
				letterSprite.rect.origin.y = this->rect.origin.y + y;
				letterSprite.tileIndex = indexes[i];
				letterSprite.draw(projectionMatrix);
			
				x += (float)letterWidths[indexes[i]] + letterSpacing;
			}
		}
	}
	
	virtual void centerInFrame(CGSize frame)
	{
		
		CGRect centered = CGRectMake(0.0, 0.0, textSize.width, textSize.height);
		NSLog(@"%@", NSStringFromCGRect(centered));
		centered = GeomCenterRectInRect(centered, frame);
		
		
		NSLog(@"%@", NSStringFromCGSize(frame));
		NSLog(@"%@", NSStringFromCGRect(centered));
		
		rect.origin.x = centered.origin.x;
		rect.origin.y = centered.origin.y;
	}
	
	
}TextSprite;

#endif
