//
//  Comment.m
//  iphone-network
//
//  Created by C. Anderson Miller on 8/19/10.
//  Copyright 2010 Submarine Rich, LLC. All rights reserved.
//

#import "Comment.h"


@implementation Comment

@synthesize comment,timeStamp;

-(void)setComment:(NSString *)foodComment {
	[comment release];
	comment = [[foodComment copy] retain];
	
}

-(void)setTimeStamp:(NSString *)commentTime {
	[timeStamp release];
	timeStamp = [[commentTime copy] retain];
}

-(NSString*)getComment {
	return comment;
}

-(NSString*)getTimeStamp {
	return timeStamp;
}

-(NSString*) getHumaneTimestamp{
	
	NSString* timeInterval = [NSString stringWithFormat:@"%d",abs([_dateOfComment timeIntervalSinceNow])];
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


-(void) setDelegate:(id)aDelegate {
	[delegate release];
	delegate = aDelegate;
}

-(void)postComment:(NSString *)atEventId {
	FreeFoodUtils *appSettings = [[FreeFoodUtils alloc] init];
	[appSettings setURLDelegate:self];
	
	NSString* urlString = [[NSString alloc]init];
	urlString = [NSString stringWithFormat:@"%@/events/comment",apiaddress];	
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:[FreeFoodUtils getUUID] forKey:@"uuid"];
	[params setObject:comment forKey:@"comment"];
	[params setObject:[NSString stringWithFormat:@"%@",atEventId] forKey:@"event_id"];
	
	if([appSettings easyURLRequest:urlString:params]){
		dataFromInternet = [[NSMutableData alloc]init];
	}else{
		NSLog(@"[FoodEventListing] failed to submit request");
		if([delegate respondsToSelector:@selector(commentError:)] ){
			[delegate commentError:@"disconnected"];
		}
	}
}

-(void) createFromDict:(NSDictionary*)dict {
	NSString* key;
	for(key in dict){
		//		NSLog(@"[Comment] key: %@ and:%@",key, [dict objectForKey:key]);
		if([key isEqualToString:@"comment"]){
			[self setComment:[dict objectForKey:key]];
		}
		if([key isEqualToString:@"at"]){
			_dateOfComment = [[FreeFoodUtils dateFromString:[dict objectForKey:key]]retain];
			//			[self setTimeStamp:[NSString stringWithFormat:@"%@", [dict objectForKey:key]]];
		}		
	}
}

-(void) parseCommentJson:(NSString*)incomingJson {
	
	//	id foodEventReturnType = [json_string JSONValue];
	//	BOOL validReturn = NO;
	//	NSString *classType = [NSString stringWithFormat:@"%@",[foodEventReturnType class]];
	BOOL validReturn = NO;
	
	NSDictionary *commentPosted = [incomingJson JSONValue];
	NSString *key;
	for (key in commentPosted) {
		NSLog(@"[Comment] in key val pairs:  key: %@   value: %@",key,[commentPosted valueForKey:key]);
		if([key isEqualToString:@"comment"]){
			validReturn = YES;
			if([delegate respondsToSelector:@selector(commentPosted:)] ){
				[delegate commentPosted:[commentPosted objectForKey:key]];
			}
		}
	}
	if (!validReturn) {
		if([delegate respondsToSelector:@selector(commentError:)] ){
			[delegate commentError:@"comments are riding dirty"];
		}
	}
}

@end

@implementation Comment (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	if([[NSString stringWithFormat:@"text/html"] isEqualToString:[response MIMEType]]){
		NSLog(@"[Comment] I think there was an error");
	}
	
	if([[NSString stringWithFormat:@"application/json"] isEqualToString:[response MIMEType]]){
		NSLog(@"[Comment] I think there was awesome - json was returned");
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	NSLog(@"[Comment] appended data %@", dataFromInternet);
	[dataFromInternet appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"[Comment] url error:  %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	NSLog(@"[Comment] connection finished loading");
	//NSLog(@"[fanmobappdelegate] data from internet: %@",dataFromInternet);
	NSString *json_string = [[NSString alloc] initWithData:dataFromInternet encoding:NSUTF8StringEncoding];
	NSLog(@"[Comment] RESULT: %@", json_string);
	[self parseCommentJson:json_string];
}

@end
