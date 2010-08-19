//
//  FreeFoodUtils.m
//  mobileOMGICU
//
//  Created by dinner on 7/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FreeFoodUtils.h"


@implementation FreeFoodUtils

//NSString * const apiaddress = @"http://localhost:8080";
NSString * const apiaddress = @"http://api.freefood4free.org";

-(void) setURLDelegate:(id)url{
	urlConnDelegate = url;
}

+(NSString*) serviceName{
	return @"freeFoodAlpha";
}

+(NSString*) notYet: (NSString*) class_method{
	NSLog(@"[%@] not even implemented a little bit",class_method);
	return @"not even implemented a little bit";
}


+(UIImage*)imageByScalingToSize:(CGSize)targetSize withImage:(UIImage*)sourceImage {


	//UIImage* sourceImage = self; 
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;

	CGImageRef imageRef = [sourceImage CGImage];
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);

	if (bitmapInfo == kCGImageAlphaNone) {
		bitmapInfo = kCGImageAlphaNoneSkipLast;
	}

	CGContextRef bitmap;
	
	if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
	} else {
		bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
	}	

	// In the right or left cases, we need to switch scaledWidth and scaledHeight,
	// and also the thumbnail point
	float pi = 3.1415926535;
	if (sourceImage.imageOrientation == UIImageOrientationLeft) {
		CGContextRotateCTM (bitmap, pi / 2);
		CGContextTranslateCTM (bitmap, 0, -targetHeight);
		
	} else if (sourceImage.imageOrientation == UIImageOrientationRight) {
		CGContextRotateCTM (bitmap, -pi /2 );
		CGContextTranslateCTM (bitmap, -targetWidth, 0);
		
	} else if (sourceImage.imageOrientation == UIImageOrientationUp) {
		// NOTHING
	} else if (sourceImage.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
		CGContextRotateCTM (bitmap, -pi);
	}

	CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage* newImage = [[UIImage imageWithCGImage:ref] retain];

	CGContextRelease(bitmap);
	CGImageRelease(ref);

	return newImage; 
}



+(BOOL) firstRun{
	NSError *theError = [NSError errorWithDomain:@"First Run Retrieval Error" code: 7542 userInfo: nil];
	NSString* isFirstRun = [SFHFKeychainUtils getPasswordForUsername:@"firstrun" andServiceName:[self serviceName] error:&theError];
	if(isFirstRun == nil){
		[SFHFKeychainUtils storeUsername:@"firstrun" andPassword:@"not my first rodeo" forServiceName:[self serviceName] updateExisting:YES error:&theError];
		return YES;
	}else{
		return NO;
	}
}

+(NSString*) getLatitude{
	NSError *theError = [NSError errorWithDomain:@"Latitude Retrieval Error" code: 7542 userInfo: nil];
	NSString *latitude = [SFHFKeychainUtils getPasswordForUsername:@"latitude" andServiceName:[self serviceName] error:&theError];
	if(latitude == nil){
		return [NSString stringWithFormat:@"40.7293"];
	}
	return latitude;
}

+(NSString*) getLongitude{
	NSError *theError = [NSError errorWithDomain:@"Longitude Retrieval Error" code: 7543 userInfo: nil];
	NSString *longitude = [SFHFKeychainUtils getPasswordForUsername:@"longitude" andServiceName:[self serviceName] error:&theError];
	if(longitude == nil){
		return [NSString stringWithFormat:@"-73.9937"];
	}
	return longitude;
	
}


+(NSString*) savedAlert:(NSString*)key{
	NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Alerts" ofType:@"plist"];
	NSDictionary *alerts = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	return [alerts objectForKey:key];
}	

+(NSString*) getUUID{
	
	UIDevice *thisDevice = [UIDevice currentDevice];
	return [thisDevice uniqueIdentifier];
}


+(NSDate*) dateFromString:(NSString*)timestampString{
	[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d M yyyy HH:mm:ss zzz"];
	
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:timestampString];
	
	return dateFromString;
}

/*-(BOOL) phonePaired{
 
 UIDevice *thisDevice = [UIDevice currentDevice];
 NSString *thisDevicesUUID = [thisDevice uniqueIdentifier];
 
 NSString *urlString = [[NSString alloc] init];
 urlString = [NSString stringWithFormat:@"http://api.fanmobapp.com/json/user/%@",thisDevicesUUID];
 NSURL *url = [[NSURL alloc] init];
 [url initWithString:urlString];
 NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
 [urlRequest setHTTPMethod:@"POST"];
 [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
 [urlRequest setHTTPBody:[contentString dataUsingEncoding:NSASCIIStringEncoding]];
 [urlRequest setValue:[NSString stringWithFormat:@"%d",[contentString length]] forHTTPHeaderField:@"Content-Length"];
 //NSURLConnection *connectionResponse = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
 
 
 return YES;
 }*/

//-(FanMobUser*) getUser:(NSString*)username:(NSString*)password{
//	return thisUser;/
//}
//-(id) getCurrentUser{
//	return NO;
//}


-(NSURLConnection*) easyURLRequest:(NSString*) _urlString:(NSMutableDictionary*)params{
	NSLog(@"[FreeFoodUtils] starting easyurl request");
	NSString* urlString = [[NSString alloc] init];
	urlString = [NSString stringWithFormat:@"%@",_urlString];
	NSURL *url = [[NSURL alloc] init];
	[url initWithString:urlString];
	
	NSArray* keys = [params allKeys];
	NSMutableString* contentString = [[NSMutableString alloc] initWithString:@""];
	
	for(int i = 0; i < [keys count]; i++){
		if(i < [keys count] - 1){
			[contentString appendString:[NSString stringWithFormat:@"%@=%@&",[keys	objectAtIndex:i],[params objectForKey:[keys	objectAtIndex:i]]]];
		}else {
			[contentString appendString:[NSString stringWithFormat:@"%@=%@",[keys	objectAtIndex:i],[params objectForKey:[keys	objectAtIndex:i]]]];
		}
		
	}
	
	//NSLog(@"easy url request getting used");
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[urlRequest setHTTPBody:[contentString dataUsingEncoding:NSASCIIStringEncoding]];
	[urlRequest setValue:[NSString stringWithFormat:@"%d",[contentString length]] forHTTPHeaderField:@"Content-Length"];
	NSURLConnection *connectionResponse = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:urlConnDelegate];
	
	
	//NSLog(@"content string: %@",contentString);
	
	/* Curl Based Debug String */
	NSMutableString* temp1 = [[NSMutableString alloc] initWithString:contentString];
	NSString* temp2 = [temp1 stringByReplacingOccurrencesOfString:@"&" withString:@" -d "];
	NSLog(@"%@",[NSString stringWithFormat:@"[FreeFoodUtils] curl -d %@ %@", temp2, _urlString]);
	NSLog(@"[FreeFoodUtils] finishing easyurl request");
	//[url release];
	return connectionResponse;
}


-(NSURLConnection*) easyURLRequestGET:(NSString*) _urlString:(NSMutableDictionary*)params{
	
	NSString* urlString = [[NSString alloc] init];
	urlString = [NSString stringWithFormat:@"%@",_urlString];
	NSURL *url = [[NSURL alloc] init];
	[url initWithString:urlString];
	
	NSArray* keys = [params allKeys];
	NSMutableString* contentString = [[NSMutableString alloc] initWithString:@""];
	
	for(int i = 0; i < [keys count]; i++){
		if(i < [keys count] - 1){
			[contentString appendString:[NSString stringWithFormat:@"%@=%@&",[keys	objectAtIndex:i],[params objectForKey:[keys	objectAtIndex:i]]]];
		}else {
			[contentString appendString:[NSString stringWithFormat:@"%@=%@",[keys	objectAtIndex:i],[params objectForKey:[keys	objectAtIndex:i]]]];
		}
		
	}
	
	//NSLog(@"easy url request getting used");
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	[urlRequest setHTTPMethod:@"GET"];
	[urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[urlRequest setHTTPBody:[contentString dataUsingEncoding:NSASCIIStringEncoding]];
	[urlRequest setValue:[NSString stringWithFormat:@"%d",[contentString length]] forHTTPHeaderField:@"Content-Length"];
	NSURLConnection *connectionResponse = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:urlConnDelegate];
	
	
	//NSLog(@"content string: %@",contentString);
	
	/* Curl Based Debug String */
	//contentString = [contentString stringByReplacingOccurrencesOfString:@"&" withString:@" -d "];
	//NSLog(@"%@",[NSString stringWithFormat:@"curl -d %@ %@", contentString, _urlString]);
	
	//[url release];
	return connectionResponse;
}

-(ASIFormDataRequest*) easyURLPostWithFeedback:(NSString*) _urlString:(NSMutableDictionary*) params{
	//NSLog(@"[FreeFoodUtils] step 1a");
	ASIFormDataRequest* toReturn = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:_urlString]];
	toReturn.requestMethod = @"POST";
	
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//NSLog(@"[FreeFoodUtils] step 1b");
	NSData *_imageData;
	
	NSArray* keys = [params allKeys];
	//NSLog(@"[FreeFoodUtils] step 1c");
	for(int i = 0; i < [keys count]; i++){
		if([[params objectForKey:[keys objectAtIndex:i]] isKindOfClass:[UIImage class]]){
			//NSLog(@"[FreeFoodUtils] step 1d");
			_imageData = UIImagePNGRepresentation([params objectForKey:[keys objectAtIndex:i]]);
			[toReturn setData:_imageData forKey:@"picture"];
			
		}else{
			//NSLog(@"[FreeFoodUtils] step 1e");
			//NSLog(@"[FreeFoodUtils] %@",[keys objectAtIndex:i]);
			[toReturn setPostValue:[params objectForKey:[keys objectAtIndex:i]] forKey:[keys objectAtIndex:i]];
		}
	}
	//NSLog(@"[FreeFoodUtils] step 1f");
	
	return toReturn;
}

@end
