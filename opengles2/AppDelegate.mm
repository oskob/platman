//
//  AppDelegate.m
//  opengles2
//
//  Created by Oskar Öberg on 2013-08-13.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#include "Sequencer.h"
#include <iostream>
#include <vector>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
	RootViewController *rootVC = [[RootViewController alloc] init];
	
	self.window.rootViewController = rootVC;
	[self.window makeKeyAndVisible];

    return YES;
}
@end
