//
//  HTTPWrapper.h
//  iphone-network
//
//  Created by C. Anderson Miller on 8/19/10.
//  Copyright 2010 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"


typedef enum _RequestState {
	Initialized,
	StartedRequest,
	Requesting,
	Finished,
	Failed
}  RequestState;

@interface HTTPWrapper : NSObject {
	ASIHTTPRequest* theRequest;
	NSString* url;
	int state;
	
	NSMutableData* theData;
	
	BOOL debug;
}

@property (nonatomic,retain) ASIHTTPRequest* theRequest;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSMutableData* theData;
-(void) setURL:(NSString*) _url;
-(void) startRequest;
-(BOOL) isFinished;
-(BOOL) hasData;
-(NSMutableData*) data;

@end
