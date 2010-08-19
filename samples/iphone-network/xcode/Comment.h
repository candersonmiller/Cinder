//
//  Comment.h
//  mobileFreeFood
//
//  Created by lunch on 7/29/10.
//  Copyright 2010 SUBMARINE RICH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "FreeFoodUtils.h"

@class Comment;
@protocol CommentDelegate <NSObject>
@optional
- (void) commentPosted:(Comment*)sentComment;
- (void) commentError:(NSString*)reason;
@end

@interface Comment : NSObject {
	NSString *comment;
	NSString *timeStamp;
	NSDate* _dateOfComment;

	
	NSMutableData *dataFromInternet;
	id<CommentDelegate>delegate;
}
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *timeStamp;

-(void)setComment:(NSString *)foodComment;
-(void)setTimeStamp:(NSString *)commentTime;
-(NSString*)getComment;
-(NSString*)getTimeStamp;
-(NSString*)getHumaneTimestamp;

-(void)setDelegate:(id)aDelegate;
-(void)postComment:(NSString *)atEventId;
-(void)createFromDict:(NSDictionary*)dict;

@end

