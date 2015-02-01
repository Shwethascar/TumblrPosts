//
//  TMBDataManager.h
//  Tumblrbot
//
//  Created by Shwetha Gopalan on 8/18/14.
//  Copyright (c) 2014 Matthew Bischoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMBDataManager : NSObject

// Singleton Instance
+ (TMBDataManager*)sharedDataManager;

- (BOOL)callServerAPIForFetchingStories;
- (BOOL)callServerAPIForLikeOnPostID:(NSString*)postID reblogKey:(NSString*)reblogKey;
- (BOOL)callServerAPIForFetchingAvatarForBlogName:(NSString*)blogName;

@end
