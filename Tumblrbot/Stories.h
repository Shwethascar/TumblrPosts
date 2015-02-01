//
//  Stories.h
//  Tumblrbot
//
//  Created by Shwetha Gopalan on 8/21/14.
//  Copyright (c) 2014 Matthew Bischoff. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Stories : NSObject<NSCoding>

@property (atomic, strong) NSArray* posts;

+ (Stories*)sharedStories;
+ (void)cleanupSharedStories;
+ (NSString*)storiesFilePath;
+ (void)removeStoriesFile;

@end

