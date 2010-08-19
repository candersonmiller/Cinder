//
//  MediaObject.h
//  mobileFanMob
//
//  Created by C. Anderson Miller on 6/25/10.
//  Copyright 2010 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <math.h>
#import "FreeFoodUtils.h"
#import "ASIHTTPRequest.h"

@class MediaObject;

typedef enum { Idle1 , DownloadingVideo1, DownloadingThumbnail1, DownloadingImage1, Finished1, UploadingMessage1 } MediaObjectDownloadState;

@protocol MediaObjectDelegate <NSObject>
@optional
	- (void) thumbnailDownloaded:(UIImage*)image;
	- (void) fullImageDownloaded:(UIImage*)image;
	- (void) downloadError:(NSString*)reason;
@end

@interface MediaObject : NSObject {
	NSString* _image_url;
	NSString* _thumbnail_url;
	NSString* _video_url;
	
	id<MediaObjectDelegate> delegate2;
	
	NSInteger state;
	
	id delegate1;

	ASIHTTPRequest* forDownloadingThumbnail;
	ASIHTTPRequest* forDownloadingImage;
	ASIHTTPRequest* forDownloadingVideo;
	
	UIImage* _thumbnailImage;
	UIImage* _fullImage;
}

@property (nonatomic, retain) NSString* _image_url;
@property (nonatomic, retain) NSString* _thumbnail_url;
@property (nonatomic, retain) NSString* _video_url;
@property (nonatomic, retain) UIImage* _thumbnailImage;
@property (nonatomic, retain) NSDate* _dateOfMessage;
@property (nonatomic, retain) UIImage* _fullImage;

-(BOOL) hasThumbnail;
-(BOOL) hasImage;

-(void) downloadThumbnail;
-(void) downloadImage;

-(void) setImage:(UIImage*)fullImageToSend;
-(void) setDownloadProgressIndicator:(id)progressIndicatorDelegate;

-(void) setImageURL:(NSString*)imageurl;
-(void) setThumbnailURL:(NSString*)thumbnail;
-(void) setVideoURL:(NSString*)video;

-(UIImage*)getThumbnail;
-(NSString*)getImageURL;
-(NSString*)getThumbnailURL;
-(NSString*)getVideoURL;

@end