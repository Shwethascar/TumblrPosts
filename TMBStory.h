//
//  TMBStory.h
//  Tumblrbot
//
//  Created by Shwetha Gopalan on 8/18/14.
//  Copyright (c) 2014 Matthew Bischoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMBStory : NSObject<NSURLSessionDelegate, NSCoding>

@property (nonatomic, copy) NSString *blogName;
@property (nonatomic, strong) NSURL *storyImageURL;
@property (nonatomic, copy) NSString *numberOfNotes;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, copy) NSString *likes;
@property (nonatomic, copy) NSString *followers;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *reblogKey;
@property (nonatomic, copy) NSString *postid;

@property (nonatomic, strong) UIImage* storyImage;

+ (instancetype)storyWithBlogName:(NSString*)blogName
					  andImageURL:(NSURL*)imageURL
					numberOfNotes:(NSString*)numberOfNotes
							 tags:(NSArray*)tags
							likes:(NSString*)likes
						followers:(NSString*)followers
							 time:(NSString*)time
						reblogKey:(NSString*)reblogKey
						   postid:(NSString*)postid;

+ (instancetype)storyFromJSONDictionary:(NSDictionary*)dict;

- (instancetype)initWithBlogName:(NSString*)blogName
					 andImageURL:(NSURL*)imageURL
				   numberOfNotes:(NSString*)numberOfNotes
							tags:(NSArray*)tags
						   likes:(NSString*)likes
					   followers:(NSString*)followers
							time:(NSString*)time
					   reblogKey:(NSString*)reblogKey
						  postid:(NSString*)postid;

@end
