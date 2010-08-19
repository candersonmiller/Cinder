//
//  Venue.h
//  submarine rich
//
//  Created by dinner on 7/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FreeFoodUtils.h"
#import "JSON.h"

@class Venue;
@protocol VenueDelegate <NSObject>
@optional
- (void) venueInfoReturned:(Venue*)venueReturned;
- (void) error:(NSString*) reason;
@end

@interface Venue : NSObject {
	id<VenueDelegate> delegate;

	NSString *venueID;
	NSString *venueName;
	NSString *venueAddress;
	NSString *venueLat;
	NSString *venueLong;
	NSString *venueCity;
	NSString *venueState;
	NSString *venueZip;
	NSString *venueCrossStreet;
	
	NSMutableData *dataFromInternet;		
}

@property (nonatomic, retain) NSString *venueID;
@property (nonatomic, retain) NSString *venueName;
@property (nonatomic, retain) NSString *venueAddress;
@property (nonatomic, retain) NSString *venueLat;
@property (nonatomic, retain) NSString *venueLong;
@property (nonatomic, retain) NSString *venueCity;
@property (nonatomic, retain) NSString *venueState;
@property (nonatomic, retain) NSString *venueZip;
@property (nonatomic, retain) NSString *venueCrossStreet;

-(void) setDelegate:(id<VenueDelegate>)aDelegate;

-(void) retrieveVenueInfo:(NSString*)IDofVenue;

/* Setter/Getter Methods */
-(void) setVenueID:(NSString*)venue_id;
-(void) setVenueName:(NSString*)venue_name;
-(void) setVenueAddress:(NSString*)venue_address;
-(void) setVenueZip:(NSString*) venue_zip;
-(void) setVenueState:(NSString*) venue_state;
-(void) setVenueLat:(NSString*) venue_lat;
-(void) setVenueLong:(NSString*) venue_long;
-(void) setVenueCity:(NSString*) venue_city;
-(void) setVenueCrossStreet:(NSString*) venue_crossStreet;

-(NSString*) getVenueID;
-(NSString*) getVenueName;
-(NSString*) getVenueAddress;
-(NSString*) getVenueZip;
-(NSString*) getVenueState;
-(NSString*) getVenueLat;
-(NSString*) getVenueLong;
-(NSString*) getVenueCity;
-(NSString*) getVenueCrossStreet;

-(void) createFromDict:(NSDictionary*)dict;



@end