//
//  DrawPoint.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-09-25.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#ifndef opengles2_DrawPoint_h
#define opengles2_DrawPoint_h



typedef struct DrawPoint : DrawObject
{
	CGPoint origin;
	DrawPoint()
	{
		origin = CGPointZero;
	}
	
}DrawPoint;


#endif
