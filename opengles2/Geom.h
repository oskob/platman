//
//  Geom.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-09-12.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#import <GLKit/GLKit.h>

#ifndef __opengles2__Geom__
#define __opengles2__Geom__


bool GeomCoordinateIsOnScreen(CGPoint point, GLKMatrix4 projectionMatrix);

CGRect GeomCenterRectInRect(CGRect rect, CGSize frame);

#endif /* defined(__opengles2__Geom__) */
