//
//  FreeFoodUtils.h
//  submarine rich
//
//  Created by dinner on 7/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFHFKeychainUtils.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

extern NSString * const apiaddress;

@interface FreeFoodUtils : NSObject {
	id xmlDelegate;
	id urlConnDelegate;
}

-(void) setURLDelegate:(id)url;
+(NSString*) notYet: (NSString*) class_method;
+(NSString*) getLatitude;
+(NSString*) getLongitude;
+(NSString*) getUUID;
+(NSString*) serviceName;
+(NSString*) savedAlert:(NSString*)key;

+(BOOL) firstRun;
+(UIImage*)imageByScalingToSize:(CGSize)targetSize withImage:(UIImage*) sourceImage;
+(NSDate*) dateFromString:(NSString*)timestampString;

-(NSURLConnection*) easyURLRequest:(NSString*) _urlString:(NSMutableDictionary*)params;
-(NSURLConnection*) easyURLRequestGET:(NSString*) _urlString:(NSMutableDictionary*)params;

-(ASIFormDataRequest*) easyURLPostWithFeedback:(NSString*) _urlString:(NSMutableDictionary*) params;

@end
