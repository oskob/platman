//
//  Geom.cpp
//  opengles2
//
//  Created by Oskar Öberg on 2013-09-12.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "Geom.h"

bool GeomCoordinateIsOnScreen(CGPoint point, GLKMatrix4 *projectionMatrix)
{
	GLKVector4 vecOut = GLKMatrix4MultiplyVector4(*projectionMatrix, {50.0, 25.0, 0.0, 1.0});
	return (vecOut.x > -1.0 && vecOut.x < 1.0 && vecOut.y > -1.0 && vecOut.y < 1.0);
}

CGRect GeomCenterRectInRect(CGRect rect, CGSize frame)
{
	return CGRectMake((frame.width-rect.size.width)/2.0, (frame.height-rect.size.height)/2.0, rect.size.width, rect.size.height);
}