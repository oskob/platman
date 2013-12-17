//
//  BenchScene.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-08-29.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "StandardScene.h"

#ifndef __opengles2__BenchScene__
#define __opengles2__BenchScene__

class BenchScene : public StandardScene
{
	int texName;
public:
	BenchScene(CGSize viewSize);
	void draw();
	void update();
};

#endif /* defined(__opengles2__BenchScene__) */
