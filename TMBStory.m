//
//  TMBStory.m
//  Tumblrbot
//
//  Created by Shwetha Gopalan on 8/18/14.
//  Copyright (c) 2014 Matthew Bischoff. All rights reserved.
//

#import "TMBStory.h"

@implementation TMBStory

NSString* const kTMBBlogName = @"blog_name";
NSString* const kTMBImageURL = @"url";
NSString* const kTMBNotes = @"note_count";
NSString* const kTMBTags = @"tags";
NSString* const kTMBLikes = @"liked";
NSString* const kTMBFollowed = @"followed";
NSString* const kTMBTime = @"date";
NSString* const kTMBReblogKey = @"reblog_key";
NSString* const kTMBPostID = @"id";

NSString* const kTMBPhoto = @"photo";

NSString* const kTMBPhotos = @"photos";
NSString* const kTMBOriginalSize = @"original_size";

- (instancetype)initWithBlogName:(NSString*)blogName
					 andImageURL:(NSURL*)imageURL
				   numberOfNotes:(NSString*)numberOfNotes
							tags:(NSArray*)tags
						   likes:(NSString*)likes
					   followers:(NSString*)followers
							time:(NSString*)time
					   reblogKey:(NSString*)reblogKey
						  postid:(NSString*)postid
{
	if (self = [super init]) {
		_blogName = blogName;
		_storyImageURL = imageURL;
		_numberOfNotes = numberOfNotes;
		_tags = tags;
		_likes = likes;
		_followers = followers;
		_time = time;
		_reblogKey = reblogKey;
		_postid = postid;
	}
	
	return self;
}

+ (instancetype)storyWithBlogName:(NSString*)blogName
					  andImageURL:(NSURL*)imageURL
					numberOfNotes:(NSString*)numberOfNotes
							 tags:(NSArray*)tags
							likes:(NSString*)likes
						followers:(NSString*)followers
							 time:(NSString*)time
						reblogKey:(NSString*)reblogKey
						   postid:(NSString*)postid
{
	return [[TMBStory alloc] initWithBlogName:blogName
								  andImageURL:imageURL
								numberOfNotes:numberOfNotes
										 tags:tags
										likes:likes
									followers:followers
										 time:time
									reblogKey:reblogKey
									   postid:postid];
}

+ (instancetype)storyFromJSONDictionary:(NSDictionary*)dict {
	NSString *name = dict[kTMBBlogName];
	
	NSArray *images = dict[kTMBPhotos];
	NSDictionary *imageDict = images[0];
	NSDictionary *imageMetadata = imageDict[kTMBOriginalSize];
	NSURL *imageURL = [NSURL URLWithString:imageMetadata[kTMBImageURL]];
	
	NSString *notes = [NSString stringWithFormat:@"%@", dict[kTMBNotes]];
	
	NSArray *tags = dict[kTMBTags];
	
	NSString *likes = [NSString stringWithFormat:@"%@", dict[kTMBLikes]];
	
	NSString *followers = [NSString stringWithFormat:@"%@", dict[kTMBFollowed]];
	
	NSString *time = dict[kTMBTime];
	
	NSString *reblogKey = dict[kTMBReblogKey];
	
	NSString *postID = [NSString stringWithFormat:@"%@", dict[kTMBPostID]];
	
	TMBStory *story = [[TMBStory alloc] initWithBlogName:name
											 andImageURL:imageURL
										   numberOfNotes:notes
													tags:tags
												   likes:likes
											   followers:followers
													time:time
											   reblogKey:reblogKey
					   postid:postID];
	
	return story;
	
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super init]) {
		NSMutableDictionary* dictionary = [aDecoder decodeObjectForKey:@"dictionary"];
		
		// default value is nil
		_blogName = dictionary[kTMBBlogName];
		_storyImageURL = dictionary[kTMBImageURL];
		_numberOfNotes = dictionary[kTMBNotes];
		_tags = dictionary[kTMBTags];
		_likes = dictionary[kTMBLikes];
		_followers = dictionary[kTMBFollowed];
		_time = dictionary[kTMBTime];
		_reblogKey = dictionary[kTMBReblogKey];
		_postid = dictionary[kTMBPostID];
		_storyImage = dictionary[kTMBPhoto];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
	
	if (self.blogName) {
		dictionary[kTMBBlogName] = self.blogName;
	}
	
	if (self.storyImageURL) {
		dictionary[kTMBImageURL] = self.storyImageURL;
	}
	
	if (self.numberOfNotes) {
		dictionary[kTMBNotes] = self.numberOfNotes;
	}
	
	if (self.tags) {
		dictionary[kTMBTags] = self.tags;
	}
	
	if (self.likes) {
		dictionary[kTMBLikes] = self.likes;
	}
	
	if (self.followers) {
		dictionary[kTMBFollowed] = self.followers;
	}
	
	if (self.time) {
		dictionary[kTMBTime] = self.time;
	}
	
	if (self.reblogKey) {
		dictionary[kTMBReblogKey] = self.reblogKey;
	}
	
	if (self.postid) {
		dictionary[kTMBPostID] = self.postid;
	}
	
	if (self.storyImage) {
		dictionary[kTMBPhoto] = self.storyImage;
	}
	
	[aCoder encodeObject:dictionary forKey:@"dictionary"];
}

@end
