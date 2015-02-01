//
//  Stories.m
//  Tumblrbot
//
//  Created by Shwetha Gopalan on 8/21/14.
//  Copyright (c) 2014 Matthew Bischoff. All rights reserved.
//

#import "Stories.h"


@implementation Stories
{
	NSArray* _posts;
}

@synthesize  posts = _posts;

NSString* __sharedStoriesLock__ = @"__sharedStoriesLock__";
Stories* __sharedStories__ = nil;

- (id)init {
	BOOL alreadyCreated = NO;
	@synchronized(__sharedStoriesLock__) {
		alreadyCreated = __sharedStories__ != nil;
	}
	
	if (alreadyCreated) {
		return nil;
	}
	
	if (self = [super init]) {
		
	}
	
	return self;
}

+ (Stories*)sharedStories {
	@synchronized(__sharedStoriesLock__) {
		if (!__sharedStories__) {
			// read from file first
			__sharedStories__ = [NSKeyedUnarchiver unarchiveObjectWithFile:[Stories storiesFilePath]];
			
			// if file doesn't exist, create a blank object
			if (!__sharedStories__) {
				__sharedStories__ = [[Stories alloc] init];
				
				// create file
				[__sharedStories__ saveToDisk];
			}
		}
	}
	
	return __sharedStories__;
}

+ (void)cleanupSharedStories {
	@synchronized(__sharedStoriesLock__) {
		__sharedStories__ = nil;
	}
}

- (void)encodeWithCoder:(NSCoder*)aCoder {
	NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
	
	if (self.posts) {
		dictionary[@"posts"] = self.posts;
	}
	
	[aCoder encodeObject:dictionary forKey:@"dictionary"];
}

- (id)initWithCoder:(NSCoder*)aDecoder {
	if (self = [super init]) {
		NSMutableDictionary* dictionary = [aDecoder decodeObjectForKey:@"dictionary"];
		
		// default value is nil
		_posts = dictionary[@"posts"];
		
	}
	
	return self;
}

+ (NSString*)storiesFilePath {
	NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	
	NSString *filePath = [NSString stringWithFormat:@"%@/sharedStories.data", filePaths[0]];
	
	return filePath;
}

+ (void)removeStoriesFile {
	[[NSFileManager defaultManager] removeItemAtPath:[self storiesFilePath] error:nil];
}

- (void)saveToDisk {
	NSError *error;
	
	// make sure the parent folder exists
	NSString *storiesFilePath = [Stories storiesFilePath];
	NSString *parentFolder = [storiesFilePath stringByDeletingLastPathComponent];
	if ([[NSFileManager defaultManager] fileExistsAtPath:parentFolder] == NO) {
		if ([[NSFileManager defaultManager] createDirectoryAtPath:parentFolder
									  withIntermediateDirectories:YES
													   attributes:nil
															error:&error] == NO) {
			NSLog(@"Error creating path to save stories: %@", error);
			return;
		}
	}
	
	NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
	if (![data writeToFile:storiesFilePath
				   options:NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication
					 error:&error]) {
		NSLog(@"Error saving stories: %@", error);
	}
}

- (NSArray*)posts {
	@synchronized(__sharedStoriesLock__)
	{
		return _posts;
	}
}

- (void)setPosts:(NSArray *)posts {
	@synchronized(__sharedStoriesLock__)
	{
		[self willChangeValueForKey:@"posts"];
		
		_posts = posts;
		
		[self saveToDisk];
		
		[self didChangeValueForKey:@"posts"];
	}
}

@end
