//
//  FreeFoodEvent.m
//  mobileFreeFood
//
//  Created by dinner on 7/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FreeFoodEvent.h"

@interface FreeFoodEvent()
-(void) parseFoodEventJson:(NSString*)incomingJson;
-(void) createFromDict:(NSDictionary*)dict;
@end

@implementation FreeFoodEvent

@synthesize event_id,event_text,event_TimeStamp,event_geoLat,event_geoLong,event_Rating;



-(void) render{
	if([event_id intValue] > 0 && [event_id intValue] < 8000000){
		float leftX = -74.0295f;
		float rightX = -73.8190f;
		float lowY = 40.8026f;
		float highY = 40.6832f;
		float screenY = 768;
		float screenX = 1024;
		float yPosition = abs(  (([event_geoLat floatValue] - lowY) / ( highY - lowY)) * screenY);
		float xPosition = abs( ([event_geoLong floatValue] - leftX) / (leftX - rightX)) * screenX;
		
		
		
		
		//NSLog(@"event: %@ xPosition %f yPosition %f",event_id,xPosition, yPosition);
		
		Vec2f center = getWindowCenter();
		center.normalize();
		
		gl::color(Color(1.0f, 0.0f, 1.0f ));
		gl::drawSolidCircle( center + Vec2f(xPosition,yPosition),5.0f);
		gl::color(Color(0.0f, 0.0f, 0.0f ));
		gl::drawSolidCircle( center + Vec2f(xPosition,yPosition),3.0f);
	}
}




-(void) setEventID:(NSString*)eventID {	
	[event_id release];
	event_id = [[eventID copy] retain];
}

-(void) setEventText:(NSString*)eventText {
	[event_text release];
	event_text = [[eventText copy] retain];
}

-(void) setEventGeoLat:(NSString*)geoLat {
	[event_geoLat release];
	event_geoLat = [[geoLat copy] retain];
}

-(void) setEventGeoLong:(NSString*)geoLong {
	[event_geoLong release];
	event_geoLong = [[geoLong copy] retain];
}

-(void) setEventTimestamp:(NSString*)timeStamp {
	[event_TimeStamp release];
	event_TimeStamp = [[timeStamp copy] retain];
	
	[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d M yyyy HH:mm:ss zzz"];
	
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:event_TimeStamp];
	
	[_dateOfEvent release];
	_dateOfEvent = [[NSDate alloc] init];
	_dateOfEvent = [[dateFromString copy] retain];
}

-(void) setVenue:(Venue*)theVenue {
	[foodEventVenue release];
	foodEventVenue = [theVenue retain];
}

-(void) setEventRating:(NSString*)eventRating {
	[event_Rating release];
	event_Rating = [eventRating retain];
}

-(Venue*)getEventVenue {
	
	if (foodEventVenue == nil) {
		foodEventVenue = [[Venue alloc] init];
	}
	return foodEventVenue;
}

-(NSString*) getEventID {
	return event_id;
}
-(NSString*) getEventText {
	return event_text;
}

-(NSString*) getEventGeoLat { 
	return event_geoLat;
}
-(NSString*) getEventGeoLong {
	return event_geoLong;
}

-(NSString*) getEventTimestamp {
	return event_TimeStamp;
}

-(NSString*) getEventRating {
	return event_Rating;
}

-(NSMutableArray*)getFoodEventComments {
	return foodEventComments;
}

-(NSString*) getHumaneTimestamp{
	
	NSString* timeInterval = [NSString stringWithFormat:@"%d",abs([_dateOfEvent timeIntervalSinceNow])];
	//	NSLog(@"[challenge Message] timeinterval:%@", timeInterval);
	int seconds = [timeInterval intValue];
	
	if( seconds < 60 ){ //1 hour
		
		return [NSString stringWithFormat:@"just now"];
	}
	
	if( seconds < 3601){
		int minutes = ceil(seconds / 60);
		return [NSString stringWithFormat:@"%d minutes ago",minutes];
	}
	
	if( seconds < 5400 ){ //90 min
		return [NSString stringWithFormat:@"1 hour ago"];
	}
	
	if( seconds < 84000 ) { // 1 day
		int hours = ceil(seconds / 3600);
		return [NSString stringWithFormat:@"%d hours ago", hours];
	}
	
	if( seconds < 588000 ) { // 1 week
		int days = ceil(seconds / 84000);
		if( days == 1){
			return [NSString stringWithFormat:@"1 day ago"];
		}
		return [NSString stringWithFormat:@"%d days ago", days];
	}
	
	if( seconds < 588000 ) { // 1 week
		int days = ceil(seconds / 84000);
		if( days < 14){
			return [NSString stringWithFormat:@"last week"];
		}
	}
	
	return [NSString stringWithFormat:@"a while ago"];
}


-(void) createFromDict:(NSDictionary*)dict {
	NSString* key;	
	for(key in dict){
		if([key isEqualToString:@"venue"]){
			Venue* tempVenue = [[Venue alloc] init];
			[tempVenue createFromDict:[dict objectForKey:key]];
			[self setVenue:tempVenue];
		}
		
		if([key isEqualToString:@"comments"]){
			NSArray *commentsArray = [dict objectForKey:key];
			foodEventComments = [[NSMutableArray alloc] init];
			for (int i = 0; i < [commentsArray count]; i++) {
				NSDictionary *singleComment = [commentsArray objectAtIndex:i];
				Comment *tempComment = [[Comment alloc] init];
				[tempComment createFromDict:singleComment];
				[foodEventComments addObject:tempComment];
			}
		}
		
		if([key isEqualToString:@"foodevent_id"]){
			[self setEventID:[dict objectForKey:key]];
		}
		
		if([key isEqualToString:@"text"]){
			[self setEventText:[dict objectForKey:key]];
		}
		
		if([key isEqualToString:@"rating"]){
			[self setEventRating:[dict objectForKey:key]];
		}
		
		if([key isEqualToString:@"geolat"]){
			[self setEventGeoLat:[dict objectForKey:key]];
		}
		
		if([key isEqualToString:@"geolong"]){
			[self setEventGeoLong:[dict objectForKey:key]];
		}
		
		if([key isEqualToString:@"timestamp"]){
			_dateOfEvent = [[FreeFoodUtils dateFromString:[dict objectForKey:key]]retain];
		}
		
		if([key isEqualToString:@"photo_url"]){
			[self setImageURL:[dict objectForKey:key]];
		}
		
		if([key isEqualToString:@"thumbnail_url"]){
			[self setThumbnailURL:[dict objectForKey:key]];
			//			NSLog(@"[FreeFoodEvent] thumnailURL:%@",[dict objectForKey:key]);
		}
	}
	
}


-(void) sendEvent:(NSString*)eventMessage eventVenue:(Venue*)eventVenue {
	//-(void) sendMessage:(NSString*)mobID:(NSString*) messageToSend;
	
	if(_fullImage){
		//		NSLog(@"[FreeFoodEvent] 1");
		state = UploadingEvent;
		if( event_text) [event_text release];
		event_text = [eventMessage copy];
		
		if(eventVenue != nil) event_id = [[eventVenue getVenueID] copy];
		
		FreeFoodUtils *appSettings = [[FreeFoodUtils alloc] init];
		[appSettings setURLDelegate:self];
		NSString* urlString = [[NSString alloc]init];
		urlString = [NSString stringWithFormat:@"%@/events/add",apiaddress];
		NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
		[params setObject:[FreeFoodUtils getUUID] forKey:@"uuid"];
		[params setObject:event_text forKey:@"text"];
		
		if(eventVenue != nil) [params setObject:event_id forKey:@"venue_id"];
		else {
			[params setObject:[FreeFoodUtils getLatitude] forKey:@"geolat"];
			[params setObject:[FreeFoodUtils getLongitude] forKey:@"geolong"];
		}
		[params setObject:_fullImage forKey:@"photo"];
		ASIFormDataRequest* theRequest = [appSettings easyURLPostWithFeedback:urlString:params];
		[theRequest startAsynchronous];
		[theRequest setDelegate:self];
		//		[theRequest setUploadProgressDelegate:delegate1];
		
		
	}else{
		//		NSLog(@"[FreeFoodEvent] 1");
		
		if(event_text) [event_text release];
		event_text = [eventMessage copy];
		
		if(eventVenue != nil) event_id = [[eventVenue getVenueID] copy];
		
		FreeFoodUtils *appSettings = [[FreeFoodUtils alloc] init];
		[appSettings setURLDelegate:self];
		
		NSString* urlString = [[NSString alloc]init];
		urlString = [NSString stringWithFormat:@"%@/events/add",apiaddress];
		NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
		[params setObject:[FreeFoodUtils getUUID] forKey:@"uuid"];
		[params setObject:event_text forKey:@"text"];
		
		if(eventVenue != nil) [params setObject:event_id forKey:@"venue_id"];
		else {
			[params setObject:[FreeFoodUtils getLatitude] forKey:@"geolat"];
			[params setObject:[FreeFoodUtils getLongitude] forKey:@"geolong"];
		}
		
		if([appSettings easyURLRequest:urlString:params]){
			dataFromInternet = [[NSMutableData alloc]init];
		}else{
			NSLog(@"[FreeFoodEvent] failed to submit request");
			if([delegate respondsToSelector:@selector(eventError:)] ){
				[delegate eventError:@"disconnected"];
			}
		}
	}
}

-(void) retrieveSingleEvent:(NSString*)singleEventId {
	
	FreeFoodUtils *appSettings = [[FreeFoodUtils alloc] init];
	[appSettings setURLDelegate:self];
	
	NSString* urlString = [[NSString alloc]init];
	urlString = [NSString stringWithFormat:@"%@/events/detail/%@",apiaddress,singleEventId];	
	
	if([appSettings easyURLRequestGET:urlString:nil]){
		dataFromInternet = [[NSMutableData alloc]init];
	}else{
		NSLog(@"[FreeFoodEvent] failed to retrieve single food event detail");
		if([delegate respondsToSelector:@selector(eventError:)] ){
			[delegate eventError:@"disconnected"];
		}
	}
	//events/detail/17
}

- (void) setDelegate:(id)aDelegate{
	delegate = aDelegate;
	delegate2 = aDelegate;
}

-(void) parseFoodEventJson:(NSString*)incomingJson {
	NSDictionary *registrationStatus = [incomingJson JSONValue];
	
	BOOL validReturn = NO;
	NSString *key;
	if (!validReturn) {
		for (key in registrationStatus) {
			//			NSLog(@"key:%@", key);
			//		NSLog(@"[FreeFoodEvent] in key val pairs:  key: %@   value: %@",key,[registrationStatus valueForKey:key]);
			if([key isEqualToString:@"failure"]){
				if([delegate respondsToSelector:@selector(eventError:)] ){
					[delegate eventError:@"JSON returned but no food events returned"];
				}
			}
			if([key isEqualToString:@"success"]){
				if([delegate respondsToSelector:@selector(eventError:)] ){
					[delegate eventError:[registrationStatus objectForKey:key]];
				}	
			}else {
				validReturn = YES;
			}
		}
	}
	
	if (validReturn){
		[self createFromDict:registrationStatus];
		if([delegate respondsToSelector:@selector(singleEventRequested:)] ){
			[delegate singleEventRequested:self];
		}
	}	
}

@end

@implementation FreeFoodEvent (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	if([[NSString stringWithFormat:@"text/html"] isEqualToString:[response MIMEType]]){
		NSLog(@"[FreeFoodEvent] I think there was an error");
	}
	
	if([[NSString stringWithFormat:@"application/json"] isEqualToString:[response MIMEType]]){
		NSLog(@"[FreeFoodEvent] I think there was awesome - json was returned");
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	NSLog(@"[FreeFoodEvent] appended data %@", dataFromInternet);
	[dataFromInternet appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"[FreeFoodEvent] url error:  %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	NSLog(@"[FreeFoodEvent] connection finished loading");
	//NSLog(@"[fanmobappdelegate] data from internet: %@",dataFromInternet);
	NSString *json_string = [[NSString alloc] initWithData:dataFromInternet encoding:NSUTF8StringEncoding];
	NSLog(@"[FreeFoodEvent] RESULT: %@", json_string);
	[self parseFoodEventJson:json_string];
}

@end