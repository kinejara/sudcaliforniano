//
//  FeedNews.h
//  Sudcaliforniano
//
//  Created by Villa, Jorge (MONHC-C) on 9/23/14.
//  Copyright (c) 2014 Villa, Jorge (MONHC-C). All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol feedNewsDelegates <NSObject>

-(void)didFinishLoadFeeds:(BOOL)loadVerified;

@end

@interface FeedNews : NSObject <NSXMLParserDelegate>
@property (nonatomic,weak) id <feedNewsDelegates> delegate;

-(NSArray*)getFeedNewsByID:(NSNumber*)municipioID;

- (NSInteger)numberOfFeedsToDisplay;
- (NSString *)FeedTitleForRow:(NSIndexPath *)indexPath;
- (NSString *)FeedDateForRow:(NSIndexPath *)indexPath;
- (NSString *)FeedContentForRow:(NSIndexPath *)indexPath;


@end
