//
//  RootViewController.m
//  opengles2
//
//  Created by Oskar Öberg on 2013-08-13.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include <vector>
#include <map>
#include <set>
#import <OpenGLES/EAGL.h>

#import "RootViewController.h"
#import "GLUtils.h"
#import "GLTouchWrap.h"

#include "Scene.h"
#include "BenchScene.h"
#include "TestScene.h"

@interface RootViewController()
{
	std::unique_ptr<Scene> currentScene;
}

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKView *glView;
@property (nonatomic, strong) NSMutableArray *trollfaceRects;
@property (nonatomic) CGSize viewSize;
@property (nonatomic) BOOL updatedTouches;

@property (nonatomic, strong) NSMutableDictionary *touches;

@end

@implementation RootViewController

- (void)viewDidLoad;
{
	[super viewDidLoad];

	self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	
	if(!self.context)
	{
		NSLog(@"Failed to load ES 2.0 context");
		return;
	}
	
	self.touches = [NSMutableDictionary dictionary];
	self.viewSize = CGSizeMake(240.0, 160.0);
	self.updatedTouches = NO;
	self.glView = [[GLKView alloc] init];
	self.glView.context = self.context;
	self.glView.delegate = self;
	
	self.view = self.glView;
	self.view.multipleTouchEnabled = YES;
	
	self.preferredFramesPerSecond = 60;
	
	[EAGLContext setCurrentContext:self.context];
	
	[self.glView setDrawableDepthFormat:GLKViewDrawableDepthFormatNone];
	
	currentScene = std::unique_ptr<Scene>(new TestScene(self.viewSize));

}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect;
{
	if(currentScene)
	{
		currentScene->draw(self.timeSinceLastDraw > 0.1 ? 0.1 : self.timeSinceLastDraw);
	}
	else
	{
		glClear(GL_COLOR_BUFFER_BIT);
		glClearColor(0.0, 0.0, 0.0, 1.0);
	}
}

- (void)update;
{
	if(currentScene)
	{
		currentScene->update(self.timeSinceLastUpdate > 0.1 ? 0.1 : self.timeSinceLastUpdate);
	}
	
	[self cleanUpTouches];
	self.updatedTouches = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
	for(UITouch *touch in touches)
	{
		[self.touches setObject:[[GLTouchWrap alloc] init] forKey:[NSValue valueWithNonretainedObject:touch]];
		[self updateGLTouchFromTouch:touch state:GLTouchStateNew];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
	if(self.updatedTouches) return;
	self.updatedTouches = YES;
	for(UITouch *touch in touches)
	{
		[self updateGLTouchFromTouch:touch state:GLTouchStateNormal];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
	for(UITouch *touch in touches)
	{
		[self updateGLTouchFromTouch:touch state:GLTouchStateEnded];
		
		CGPoint p = [touch locationInView:self.view];
		
		if(p.x < 50.0 && p.y < 50.0)
		{
			if(!currentScene)
			{
				currentScene = std::unique_ptr<Scene>(new TestScene(self.viewSize));
			}
			else
			{
				currentScene = NULL;
			}
		}
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
{
	for(UITouch *touch in touches)
	{
		[self updateGLTouchFromTouch:touch state:GLTouchStateEnded];
	}
}

- (void)updateGLTouchFromTouch:(UITouch*)touch state:(GLTouchState)state;
{
	if(!currentScene) return;
	GLTouch *glTouch = [[self.touches objectForKey:[NSValue valueWithNonretainedObject:touch]] glTouch];
	glTouch->previousLocation = glTouch->location;
	glTouch->location = [self sceneLocationFromTouch:touch];

	glTouch->state = state;
	if(state == GLTouchStateNew)
	{
		glTouch->startLocation = glTouch->location;
		glTouch->state = GLTouchStateNew;
		currentScene->touches.insert(glTouch);
	}
}

- (void)cleanUpTouches;
{
	for(NSValue *p in self.touches.allKeys)
	{
		GLTouchState state = [[self.touches objectForKey:p] glTouch]->state;
		if(state == GLTouchStateEnded)
		{
			if(currentScene)
			{
				currentScene->touches.erase([[self.touches objectForKey:p] glTouch]);
				[self.touches removeObjectForKey:p];
			}
		}
		else if(state == GLTouchStateNew)
		{
			[[self.touches objectForKey:p] glTouch]->state = GLTouchStateNormal;
		}
	}
}

- (CGPoint)sceneLocationFromTouch:(UITouch*)touch;
{
	CGPoint point = [touch locationInView:self.view];
	point.x *= self.viewSize.width/self.view.bounds.size.width;
	point.y = (self.view.bounds.size.height-point.y) * (self.viewSize.height/self.view.bounds.size.height);
	return point;
}

@end
