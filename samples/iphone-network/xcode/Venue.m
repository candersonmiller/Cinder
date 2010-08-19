//
//  Venue.m
//  mobileFreeFood
//
//  Created by dinner on 6/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Venue.h"

@implementation Venue
@synthesize venueID,venueName,venueAddress,venueLat,venueLong,venueCity,venueState,venueZip,venueCrossStreet;



-(void) createFromDict:(NSDictionary*)dict{
	NSString* key;
	for(key in dict){
//		NSLog(@"[Venue] key: %@",key);
		if([key isEqualToString:@"crossstreet"]){
			[self setVenueCrossStreet:[dict objectForKey:key]];
		}
		if([key isEqualToString:@"venue_id"]){
			[self setVenueID:[dict objectForKey:key]];
		}
		if([key isEqualToString:@"name"]){
			[self setVenueName:[dict objectForKey:key]];
		}
		if([key isEqualToString:@"address"]){
			[self setVenueAddress:[dict objectForKey:key]];
		}
		if([key isEqualToString:@"geolat"]){
			[self setVenueLat:[dict objectForKey:key]];
		}
		if([key isEqualToString:@"geolong"]){
			[self setVenueLong:[dict objectForKey:key]];
		}
		if([key isEqualToString:@"state"]){
			[self setVenueState:[dict objectForKey:key]];
		}
		if([key isEqualToString:@"city"]){
			[self setVenueCity:[dict objectForKey:key]];
		}
		if([key isEqualToString:@"zip"]){
			[self setVenueZip:[dict objectForKey:key]];
		}
		
	}
	
}
-(void) setVenueID:(NSString*)venue_id {
	venueID = [[venue_id copy] retain];
}
-(NSString*) getVenueID {
	return venueID;
}

-(void) setVenueName:(NSString*)venue_name {
	venueName = [[venue_name copy] retain];
}
-(NSString*) getVenueName {
	return venueName;
}

-(void) setVenueAddress:(NSString*)venue_address {
	venueAddress = [[venue_address copy] retain];
}
-(NSString*) getVenueAddress {
	return venueAddress;
}

-(void) setVenueZip:(NSString*) venue_zip {
	venueZip = [[venue_zip copy] retain];
}
-(NSString*) getVenueZip {
	return venueZip;
}

-(void) setVenueState:(NSString*) venue_state {
	venueState = [[venue_state copy] retain];
}
-(NSString*) getVenueState {
	return venueState;
}

-(void) setVenueLat:(NSString*) venue_lat {
	venueLat = [[venue_lat copy] retain];
}
-(NSString*) getVenueLat {
	return venueLat;
}

-(void) setVenueLong:(NSString*) venue_long {
	venueLong = [[venue_long copy] retain];
}
-(NSString*) getVenueLong {
	return venueLong;
}

-(void) setVenueCity:(NSString*) venue_city {
	venueCity = [[venue_city copy] retain];
}
-(NSString*) getVenueCity {
	return venueCity;
}

-(void) setVenueCrossStreet:(NSString*) venue_crossStreet {
	venueCrossStreet = [[venue_crossStreet copy] retain];
}

-(NSString*) getVenueCrossStreet {
	return venueCrossStreet;
}

- (void) setDelegate:(id<VenueDelegate>)aDelegate{
	delegate = aDelegate;
}

-(void) retrieveVenueInfo:(NSString*)IDofVenue {

	FreeFoodUtils *appSettings = [[FreeFoodUtils alloc] init];
	[appSettings setURLDelegate:self];

	NSString* urlString = [[NSString alloc]init];
	urlString = [NSString stringWithFormat:@"%@/venues/detail",apiaddress];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	[params setObject:[NSString stringWithFormat:@"%@",IDofVenue] forKey:@"venue_id"];

	if([appSettings easyURLRequest:urlString:params]){
		dataFromInternet = [[NSMutableData alloc]init];
	}else{
		NSLog(@"[Venue] failed to submit request");
		if([delegate respondsToSelector:@selector(error:)] ){
			[delegate error:@"disconnected"];
		}
	}
}

- (void) parseVenueJson:(NSString*) json_string {	
	NSDictionary *singleVenueInfo = [json_string JSONValue];
		NSString *key;
		for (key in singleVenueInfo) {
			if([key isEqualToString:@"venue_id"]){
				venueID = [NSString stringWithFormat:@"%@",[singleVenueInfo objectForKey:key]];
			}
			if([key isEqualToString:@"name"]){
				venueName = [NSString stringWithFormat:@"%@",[singleVenueInfo objectForKey:key]];
			}
			if([key isEqualToString:@"address"]){
				venueAddress = [NSString stringWithFormat:@"%@",[singleVenueInfo objectForKey:key]];
			}
			if([key isEqualToString:@"geolat"]){
				venueLat = [NSString stringWithFormat:@"%@",[singleVenueInfo objectForKey:key]];
			}
			if([key isEqualToString:@"geolong"]){
				venueLong = [NSString stringWithFormat:@"%@",[singleVenueInfo objectForKey:key]];
			}
			if([key isEqualToString:@"city"]){
				venueCity = [NSString stringWithFormat:@"%@",[singleVenueInfo objectForKey:key]];
			}
			if([key isEqualToString:@"state"]){
				venueState = [NSString stringWithFormat:@"%@",[singleVenueInfo objectForKey:key]];
			}
			if([key isEqualToString:@"zip"]){
				venueZip = [NSString stringWithFormat:@"%@",[singleVenueInfo objectForKey:key]];
			}
			if([key isEqualToString:@"crossstreet"]){
				venueCrossStreet = [NSString stringWithFormat:@"%@",[singleVenueInfo objectForKey:key]];
			}
	}
	
	if([delegate respondsToSelector:@selector(venueInfoReturned:)] ){
		[delegate venueInfoReturned:self];
	}
}	
@end

@implementation Venue (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	if([[NSString stringWithFormat:@"text/html"] isEqualToString:[response MIMEType]]){
		NSLog(@"[VENUE] I think there was an error");
	}
	
	if([[NSString stringWithFormat:@"application/json"] isEqualToString:[response MIMEType]]){
		//NSLog(@"[Mob] I think there was awesome - json was returned");
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	//NSLog(@"[Mob] appended data %@", dataFromInternet);
	[dataFromInternet appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"[VENUE] url error:  %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	//NSLog(@"[Mob] connection finished loading");
	//NSLog(@"[freefoodDelegate] data from internet: %@",dataFromInternet);
	NSString *json_string = [[NSString alloc] initWithData:dataFromInternet encoding:NSUTF8StringEncoding];
	//NSLog(@"[Mob] RESULT: %@", json_string);
	[self parseVenueJson:json_string];
}


@end

