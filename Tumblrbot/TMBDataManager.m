//
//  TMBDataManager.m
//  Tumblrbot
//
//  Created by Shwetha Gopalan on 8/18/14.
//  Copyright (c) 2014 Matthew Bischoff. All rights reserved.
//

#import "TMBDataManager.h"
#import "TMBStory.h"
#import "Reachability.h"

@implementation TMBDataManager

NSString *__sharedDMLock__ = @"__sharedDataManagerLock__";
NSMutableDictionary *__sharedDMDictionary__ = nil;

+ (TMBDataManager*)sharedDataManager {
	static dispatch_once_t predicate;
	static TMBDataManager* sharedInstance = nil;
	dispatch_once(&predicate, ^{
		sharedInstance = [[TMBDataManager alloc] init];
	});
	
	return sharedInstance;
}

- (BOOL)callServerAPIForFetchingStories
{
	__block BOOL success = YES;
	NSMutableArray* storyArray = [NSMutableArray array];
	
	// Check for reachability before calling the API
	Reachability *reachability = [Reachability reachabilityForInternetConnection];
	if(reachability.currentReachabilityStatus == NotReachable || reachability.connectionRequired) {
		return NO;
	} else {
		JXHTTPOperation *operation = [[TMAPIClient sharedInstance] dashboardRequest:@{}];
		[operation setDidFinishLoadingBlock:^(JXHTTPOperation *op){
			NSError *error = nil;
			id jsonData = [NSJSONSerialization JSONObjectWithData:op.responseData options:NSJSONReadingMutableLeaves error:&error];
			if([NSJSONSerialization isValidJSONObject:jsonData]) {
				NSLog(@"Got data successfully");
				NSDictionary *posts = jsonData[@"response"];
				NSArray *postsArray = posts[@"posts"];
				for (NSDictionary *post in postsArray) {
					[storyArray addObject:post];
				}
				
				[[NSNotificationCenter defaultCenter] postNotificationName:@"PostsReceived" object:self userInfo:@{@"posts" : storyArray}];
				success = YES;
				
			} else {
				if(error) {
					NSLog(@"Error fetching posts : %@", error.localizedDescription);
					success = NO;
				}
			}
		}];
		[operation start];
	}
		
	return success;
}

// This doesn't seem to be working correctly.
//- (BOOL)callServerAPIForFetchingAvatarForBlogName:(NSString*)blogName
//{
//	__block BOOL success = YES;
//	
//	// Check for reachability before calling the API
//	Reachability *reachability = [Reachability reachabilityForInternetConnection];
//	if(reachability.currentReachabilityStatus == NotReachable || reachability.connectionRequired) {
//		return NO;
//	} else {
//		[[TMAPIClient sharedInstance] avatar:blogName size:30 callback:^(id result, NSError *error) {
//			id jsonData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
//			if([NSJSONSerialization isValidJSONObject:jsonData]) {
//				NSLog(@"Got avatar successfully");
//				NSURL *url = jsonData[@"avatar_url"];
//				
//				[[NSNotificationCenter defaultCenter] postNotificationName:@"AvatarReceived" object:self userInfo:@{@"blogName" : blogName, @"avatarURL" : url}];
//				success = YES;
//				
//			} else {
//				if(error) {
//					NSLog(@"Error fetching avatar : %@", error.localizedDescription);
//					success = NO;
//				}
//			}
//		}];
//	}
//	
//	return success;
//}

- (BOOL)callServerAPIForLikeOnPostID:(NSString*)postID reblogKey:(NSString*)reblogKey
{
	__block BOOL success = YES;
	// Check for reachability before calling the API
	Reachability *reachability = [Reachability reachabilityForInternetConnection];
	if(reachability.currentReachabilityStatus == NotReachable || reachability.connectionRequired) {
		return NO;
	} else {
		JXHTTPOperation *operation = [[TMAPIClient sharedInstance] likeRequest:postID reblogKey:reblogKey];
		[operation setDidFinishLoadingBlock:^(JXHTTPOperation *op){
			NSError *error = nil;
			id jsonData = [NSJSONSerialization JSONObjectWithData:op.responseData options:NSJSONReadingMutableLeaves error:&error];
			if([NSJSONSerialization isValidJSONObject:jsonData]) {
				NSLog(@"Posted a like successfully");
				[[NSNotificationCenter defaultCenter] postNotificationName:@"PostLiked" object:self];
				success = YES;
			} else {
				if(error) {
					NSLog(@"Error posting a like : %@", error.localizedDescription);
					success = NO;
				}
			}
		}];
		[operation start];
	}
	
	return success;
}


@end
