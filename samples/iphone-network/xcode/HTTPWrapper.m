//
//  HTTPWrapper.m
//  iphone-network
//
//  Created by C. Anderson Miller on 8/19/10.
//  Copyright 2010 Submarine Rich, LLC. All rights reserved.
//

#import "HTTPWrapper.h"


@implementation HTTPWrapper
@synthesize theRequest, url, theData;

-(id)init
{
	debug = YES;
	
    if (self = [super init])
    {
		// Initialization code here
		theData = nil;
		state = Initialized;
    }
	
	if(debug) NSLog(@"[HTTPWrapper] successfully initialized");
    return self;
}

-(void) setURL:(NSString*) _url
{
	url = [[NSString alloc] init];
	url = [_url copy];
	if(debug) NSLog(@"[HTTPWrapper] successfully set URL");
}


-(void) startRequest
{
	theRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	[theRequest setDelegate:self];
	[theRequest startAsynchronous];
}

-(BOOL) isFinished{
	return state == Finished;
}

-(BOOL) isFailed{
	return state == Failed;
}

-(BOOL) hasData{
	return theData > 0;
}

-(NSMutableData*) data{
	return theData;
}

-(void) requestFailed:(ASIHTTPRequest*) request{
	if(debug) NSLog(@"[HTTPWrapper] Request Failed");
	state = Failed;
}

- (void) requestStarted: (ASIHTTPRequest*) request{
	if(debug) NSLog(@"[HTTPWrapper] request started");
	state = StartedRequest;
}

- (void)requestFinished:(ASIHTTPRequest *)request 
{ 
	state = Finished;
	//NSLog(@"[HTTPWrapper] data back %@",[request responseData]);
	theData = [[NSMutableData alloc] initWithData:[request responseData]];
	if(debug) NSLog(@"[HTTPWrapper] Request Finished");
} 


@end
