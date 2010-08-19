//
//  FreeFoodEvent.h
//  mobileFreeFood
//
//  Created by dinner on 7/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Venue.h"

#include <math.h>
#import "FreeFoodUtils.h"
#import "ASIHTTPRequest.h"
#import "MediaObject.h"
#import "Comment.h"
#include "cinder/Cinder.h"
#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "cinder/gl/Texture.h"
#include "cinder/ImageIo.h"

@class FreeFoodEvent;

typedef enum { Idle , DownloadingThumbnail, DownloadingImage, FoodEventFinished, UploadingEvent } EventDownloadState;

@protocol FreeFoodEventDelegate <NSObject>
@optional
- (void) singleEventRequested:(FreeFoodEvent*)singleEvent;
- (void) eventSent:(FreeFoodEvent*)foodEventSent;
- (void) eventError:(NSString*)reason;
@end

using namespace ci;
using namespace ci::app;
using namespace std;

@interface FreeFoodEvent : MediaObject {
	
	Venue *foodEventVenue;
	
	NSString *event_id;
	NSString *event_text;
	NSString *event_geoLat;
	NSString *event_geoLong;
	NSString *event_TimeStamp;
	
	NSString *event_Rating;
	
	NSMutableArray *foodEventComments;
	
	NSDate* _dateOfEvent;
	
	id<FreeFoodEventDelegate> delegate;
	
	NSMutableData *dataFromInternet;
	
}

@property (nonatomic, retain)NSString* event_id;
@property (nonatomic, retain)NSString* event_text;
@property (nonatomic, retain)NSString* event_TimeStamp;
@property (nonatomic, retain)NSString* event_geoLat;
@property (nonatomic, retain)NSString* event_geoLong;
@property (nonatomic,retain) NSString *event_Rating;

-(void) setEventID:(NSString*)eventID;
-(void) setEventText:(NSString*)eventText;
-(void) setEventTimestamp:(NSString*)timeStamp;
-(void) setEventGeoLat:(NSString*)geoLat;
-(void) setEventGeoLong:(NSString*)geoLong;
-(void) setEventRating:(NSString*)eventRating;

-(NSString*) getEventID;
-(NSString*) getEventText;
-(NSString*) getEventTimestamp;

-(NSString*) getEventGeoLat;
-(NSString*) getEventGeoLong;
-(NSString*) getEventRating;

-(NSString*) getHumaneTimestamp;

-(Venue*)getEventVenue; 
-(NSMutableArray*)getFoodEventComments;

-(void) setDelegate:(id)aDelegate;

-(void) sendEvent:(NSString*)eventMessage eventVenue:(Venue*)eventVenue;
-(void) retrieveSingleEvent:(NSString*)singleEventId;

-(void) render;

@end
