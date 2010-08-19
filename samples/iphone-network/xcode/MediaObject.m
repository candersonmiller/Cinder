//
//  MediaObject.m
//  mobileFanMob
//
//  Created by C. Anderson Miller on 6/25/10.
//  Copyright 2010 Submarine Rich, LLC. All rights reserved.
//

#import "MediaObject.h"


@implementation MediaObject
@synthesize  _image_url,_video_url,_thumbnail_url;
@synthesize _thumbnailImage,_fullImage;

-(void) setDownloadProgressIndicator:(id)progressIndicatorDelegate{
	delegate1 = progressIndicatorDelegate;
}

-(void) requestFailed:(ASIHTTPRequest*) request{

	NSLog(@"[MediaObject] [Download Test] Request Failed");
	NSLog(@"[MediaObject] [Download Test] STATE: %d", state);

	if( state == UploadingMessage1){
		if([delegate2 respondsToSelector:@selector(downloadError:)] ){
			[delegate2 downloadError:@"disconnected"];
		}
	}
	state = Finished1;
}

- (void)requestFinished:(ASIHTTPRequest *)request 
{ 
//	NSLog(@"[MediaObject] [Download Test] STATE: %d", state);
	
	if(state == DownloadingThumbnail1){
		UIImage *img = [[UIImage alloc] initWithData:[request responseData]];
		_thumbnailImage = img;	
		if([delegate2 respondsToSelector:@selector(thumbnailDownloaded:)] ){
			[delegate2 thumbnailDownloaded:_thumbnailImage];
		}
	}
	
	if(state == DownloadingImage1){
		UIImage *img = [[UIImage alloc] initWithData:[request responseData]];
		[_fullImage release];
		_fullImage = [img retain];
		if([delegate2 respondsToSelector:@selector(fullImageDownloaded:)]){
			[delegate2 fullImageDownloaded:_fullImage];
		}
	}
	
	if(state == Finished1){
		if([delegate2 respondsToSelector:@selector(eventSent:)]){
			[delegate2 eventSent:self];
		}
	}
	
	
	state = Finished1;
	
//	NSLog(@"[MediaObject] [Download Test] Request Finished");
} 

-(void) incrementDownloadProgressBy:(int) value{
	NSLog(@"[MediaObject] [Download Test] Download progress incremented");
}

-(void) incrementUploadProgressBy:(int) value{
	NSLog(@"[MediaObject] [Download Test] Upload progress incremented");
}


-(void) setImage:(UIImage*)fullImageToSend{
	[_fullImage release];
	
	NSLog(@"[MediaObject] Image Compressing");

	UIImage* tempImage = [FreeFoodUtils imageByScalingToSize:CGSizeMake(320, 480) withImage:fullImageToSend];
	_fullImage = [tempImage retain];
}

-(BOOL) hasThumbnail{
	return _thumbnail_url.length > 0;
}
-(BOOL) hasImage{
	return _image_url.length > 0;
}
-(BOOL) hasVideo{
	return _video_url.length > 0;
}


-(void) downloadThumbnail{
	if([self hasThumbnail] && ! _thumbnailImage ){
		[_thumbnailImage release];
		state = DownloadingThumbnail1;
		NSURL* test = [NSURL URLWithString:_thumbnail_url];
//		NSLog(@"[MediaObject] [Download Test] Thumbnail Request Starting");
		forDownloadingThumbnail = [[ASIHTTPRequest alloc] initWithURL:test];
		[forDownloadingThumbnail setDownloadProgressDelegate:delegate1];
		[forDownloadingThumbnail setDelegate:self];
		[forDownloadingThumbnail startAsynchronous];
	}
}

-(void) downloadImage{
	state = DownloadingImage1;
	NSURL* test = [NSURL URLWithString:_image_url];
	NSLog(@"[MediaObject] [Download Test] Full Image Download Request Starting");
	forDownloadingImage = [[ASIHTTPRequest alloc] initWithURL:test];
	[forDownloadingImage setDownloadProgressDelegate:delegate1];
	[forDownloadingImage setDelegate:self];
	[forDownloadingImage startAsynchronous];
}

-(void) downloadVideo{
	state = DownloadingVideo1;
	NSURL* test = [NSURL URLWithString:_video_url];
	NSLog(@"[MediaObject] [Download Test] Video Download Request Starting");
	forDownloadingVideo = [[ASIHTTPRequest alloc] initWithURL:test];
	[forDownloadingVideo setDownloadProgressDelegate:delegate1];
	[forDownloadingVideo setDelegate:self];
	[forDownloadingVideo startAsynchronous];
}

-(void) setImageURL:(NSString*)imageurl{
	[_image_url release];
	_image_url = [[imageurl copy] retain];
}

-(void) setThumbnailURL:(NSString*)thumbnail{
	[_thumbnail_url release];
	_thumbnail_url = [[thumbnail copy] retain];
}

-(void) setVideoURL:(NSString*)video{
	[_video_url release];
	_video_url = [[video copy] retain];
}

-(NSString*)getImageURL{
	return _image_url;
}

-(NSString*)getThumbnailURL{
	return _thumbnail_url;
}

-(NSString*)getVideoURL{
	return _video_url;
}

-(UIImage*) getThumbnail{
	return _thumbnailImage;
}

@end