//
//  TileSprite.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-09-25.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#ifndef opengles2_TileSprite_h
#define opengles2_TileSprite_h


typedef struct TileSprite : DrawRect
{
	std::vector<int> tileIndexes;
	AtlasSprite sprite;
	CGSize tileSize;
	int tileGridWidth;
	
	TileSprite(Scene &scene, CGRect rect, const char *textureName, int tileGridWidth) : DrawRect(scene, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)), sprite(scene, CGRectMake(0.0, 0.0, rect.size.width, rect.size.height), CGSizeZero, textureName)
	{
		this->tileSize = tileSize;
		this->tileGridWidth = tileGridWidth;
	}
	
	~TileSprite()
	{
	
	}
	
	virtual void draw(GLKMatrix4 &projectionMatrix)
	{
		// to optimize, use a VBO for all the texCoords and draw entire tile set in one draw
		sprite.opacity = this->opacity;
		for(int i = 0; i < tileIndexes.size(); i++)
		{
			if(tileIndexes[i] == -1) continue;	
			int row = tileGridWidth == 0 ? 0 : floorf(i / tileGridWidth);
			int col = i % tileGridWidth;
			sprite.rect = CGRectMake(rect.origin.x + (rect.size.width*col) , rect.origin.y + (row * rect.size.height), rect.size.width, rect.size.height);
			sprite.tileIndex = tileIndexes[i];
			sprite.draw(projectionMatrix);
		}
	}
	
	void setTiles(std::vector<int>tileIndexes)
	{
		this->tileIndexes = tileIndexes;
	}
	
}TileSprite;

#endif
