//
//  Sequencer.cpp
//  opengles2
//
//  Created by Oskar Öberg on 2013-11-04.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "Sequencer.h"

Sequencer::Sequencer()
{
	time = 0.0;
}

void Sequencer::update(double delta)
{
	
	time += delta;
	
	int max = 0;
	for(int i = 0; i < timedEvents.size(); i++)
	{
		Event *e = &timedEvents.at(i);
		
		if(e->time < time)
		{
			e->func();
			max = i+1;
		}
		else
		{
			break;
		}
	}
	
	if(max > 0)
	{
		timedEvents.erase(timedEvents.begin(), timedEvents.begin()+max);
	}
	
	for(int i = 0; i < continuousEvents.size(); i++)
	{
		if(!continuousEvents.at(i)(delta))
		{
			continuousEvents.erase(continuousEvents.begin() + i);
		}
	}
	
}

void Sequencer::addTimedEvent(double timeFromNow, std::function<void()> func)
{
	double absTime = time + timeFromNow;
	
	Event e;
	e.time = absTime;
	e.func = func;
	
	bool added = false;
	for(int i = 0; i < timedEvents.size(); i++)
	{
		if(e.time < timedEvents.at(i).time)
		{
			timedEvents.insert(timedEvents.begin()+i, e);
			added = true;
			break;
		}
	}
	
	if(!added)
	{
		timedEvents.push_back(e);
	}
}

void Sequencer::addContinuousEvent(std::function<bool(double delta)> func)
{
	continuousEvents.push_back(func);
}
