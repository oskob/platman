//
//  Scene.cpp
//  opengles2
//
//  Created by Oskar Öberg on 2013-08-29.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "Scene.h"
#import "GLUtils.h"

Scene::Scene(CGSize viewSize)
{
	this->viewSize = viewSize;
}
Scene::~Scene()
{
	
	typedef std::map<std::string, GLTexture>::iterator it_type;
	for(it_type iterator = textures.begin(); iterator != textures.end(); iterator++)
	{
		GLTexture *texture = (GLTexture*)&iterator->second;
		glDeleteTextures(1, &texture->name);
	}
	textures.clear();
	
	glDeleteBuffers(kGLVertexBufferMax, &vertexBuffers[0]);
	
	for(int i = 0; i < kGLProgramMax; i++)
	{
		glDeleteProgram(programs[i].name);
	}
	
}

GLTexture Scene::getTexture(std::string const& imageName)
{
	if(textures.find(imageName) == textures.end())
	{
		CGSize size;
		GLuint textureName = GLUtilsLoadTexture(imageName.c_str(), &size);
		GLTexture info;
		info.name = textureName;
		info.size = size;
		textures.insert(std::pair<std::string const& , GLTexture>(imageName, info));
	}
	return textures[imageName];
}

CGRect Scene::rectFromRelativeCoordinates(float x, float y, float width, float height)
{
	return CGRectMake(viewSize.width*x, viewSize.height*y, viewSize.width*width, viewSize.height*height);
}

void Scene::draw(double delta) {}
void Scene::update(double delta) {}