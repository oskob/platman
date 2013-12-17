//
//  Renderer.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-08-23.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include <vector>
#include "Scene.h"
#include "DrawObject.h"
#include "DrawRect.h"
#include "Button.h"


#ifndef __opengles2__StandardScene__
#define __opengles2__StandardScene__

#define VBO_PARTICLES_MAX_COUNT 1000
#define VBO_LINES_MAX_COUNT 100
#define SCENE_LAYERS_COUNT 10

typedef enum kLayers
{
	kLayersBackgroundColorFixed,
	kLayersBackgroundColor,
	kLayersBackgroundFixed,
	kLayersBackgroundParallax1,
	kLayersBackgroundParallax2,
	kLayersBackgroundParallax3,
	kLayersBackground,
	kLayersHero,
	kLayersLevel,
	kLayersSprites,
	kLayersForeground,
	kLayersForegroundColor,
	kLayersForegroundColorFixed,
	kLayersForegroundFixed,
	kLayersMax
}kLayers;

class StandardScene : public Scene
{
private:
	template <class T> void checkListForDeadObjects(std::vector<T>&list, std::vector<DrawObject*>&deadList, bool force);
	void setupVBOs();
	void setupPrograms();
	
public:
	CGPoint cameraPosition;
	std::vector<DrawObject*> layers[kLayersMax];
	std::vector<DrawRect*> physicsList;
	std::vector<DrawObject*> updateList;
	std::vector<DrawRect*> collideList;
	std::vector<DrawRect*> levelCollideList;
	std::vector<Button*> buttonList;

	StandardScene(CGSize viewSize);
	~StandardScene();
	virtual void cleanUp(bool force = false);
	virtual void update(double delta);
	virtual void draw(double delta);
	virtual void collide(DrawRect *o1, DrawRect *o2);
	virtual DrawRect* objectAtPoint(CGPoint pont);

};

#endif /* defined(__opengles2__Scene__) */
