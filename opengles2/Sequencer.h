//
//  Sequencer.h
//  opengles2
//
//  Created by Oskar Öberg on 2013-11-04.
//  Copyright (c) 2013 Oskar Öberg. All rights reserved.
//

#include "UpdateObject.h"
#include <functional>
#include <vector>

#ifndef __opengles2__Sequencer__
#define __opengles2__Sequencer__

struct Event
{
	std::function<void()> func;
	double time;
};

class Sequencer : UpdateObject
{
private:
	double time;
	std::vector<Event> timedEvents;
	std::vector<std::function<bool(double delta)>> continuousEvents;
public:
	Sequencer();
	
	virtual void update(double delta);
	
	void addTimedEvent(double timeFromNow, std::function<void()> func);
	void addContinuousEvent(std::function<bool(double delta)> func);

};

#endif /* defined(__opengles2__Sequencer__) */
