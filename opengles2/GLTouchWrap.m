//
//  GLTouchWrap.m
//  opengles2
//
//  Created by Oskar Öberg on 2013-09-04.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#import "GLTouchWrap.h"

@implementation GLTouchWrap

- (id)init;
{
	self = [super init];
	if(self != nil)
	{
		self.glTouch = new GLTouch;
	}
	return self;
}

- (void)dealloc;
{
	delete self.glTouch;
}

@end
