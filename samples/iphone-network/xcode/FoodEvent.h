/*
 *  FoodEvent.h
 *  flickrTest
 *
 *  Created by C. Anderson Miller on 8/4/10.
 *  Copyright 2010 Submarine Rich, LLC. All rights reserved.
 *
 */


#ifndef _FOOD_EVENT
#define _FOOD_EVENT


#include "cinder/Cinder.h"
#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "cinder/gl/Texture.h"
#include "cinder/ImageIo.h"
#include "cinder/URL.h"
#include "cinder/Xml.h"
#include <vector>
#include <iostream>
#include <map>
#include <string>
#include "Venue.h"


using namespace ci;
using namespace ci::app;
using namespace std;

class FoodEvent {
public:
	FoodEvent();
	FoodEvent( cinder::XmlElement& _element);
	
	void render(float w, float h);
	void renderFocused(float w, float h);
	void parse( cinder::XmlElement& _element );
	
	void passCircle( gl::Texture _circle );
	
	Url getPhotoURL();
	void loadPhoto();
	bool verified();
	
private:
		int foodevent_id;
		
		float geolat;
		float geolong;
		Url photo_url;
		Url thumbnail_url;
		
		std::string text;
		
		gl::Texture fullImage;
		gl::Texture circle;
		Venue theVenue;
		



};

#endif