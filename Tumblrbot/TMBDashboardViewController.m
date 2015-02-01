//
//  TMBDashboardViewController.m
//  Tumblrbot
//
//  Created by Shwetha Gopalan on 8/18/14.
//  Copyright (c) 2014 Matthew Bischoff. All rights reserved.
//

#import "TMBDashboardViewController.h"
#import "TMBCustomTableViewCell.h"
#import "TMBStory.h"
#import "TMBDataManager.h"
#import "TMBAppDelegate.h"
#import "Stories.h"

@interface TMBDashboardViewController ()

@end

@implementation TMBDashboardViewController  {
	id _gotPostsObserver;
	id _postedLikeObserver;
	id _gotAvatarObserver;
	
	TMBAppDelegate *appDelegate;
	NSMutableDictionary *avatarDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.tableView setRowHeight:450];
	self.stories = [NSMutableArray array];
	avatarDict = [NSMutableDictionary dictionary];
	
	self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
	self.likedHUD.delegate = self;
	self.loadingHUD.delegate = self;
	
	self.loadingHUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:self.loadingHUD];
	self.loadingHUD.mode = MBProgressHUDModeText;
	self.loadingHUD.labelText = @"Loading...";
	
	self.errorHUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:self.errorHUD];
	self.errorHUD.mode = MBProgressHUDModeText;
	self.errorHUD.labelText = @"You are offline";
	
	appDelegate = (TMBAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[self registerObservers];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.loadingHUD show:YES];
	[self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh {
	runOnUIThread(^{
		TMBDataManager *dataManager = [TMBDataManager sharedDataManager];
		
		// Try loading from disk
		Stories *stories = [Stories sharedStories];
		if (stories.posts) {
			[self.loadingHUD hide:YES];
			[self.stories addObjectsFromArray:stories.posts];
		}
		
		[dataManager callServerAPIForFetchingStories];

	});
}

void runOnUIThread(void(^block)())
{
	if ([NSThread isMainThread]) {
		block();
	} else {
		dispatch_async(dispatch_get_main_queue(), block);
	}
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.stories count];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	TMBCustomTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"customCell"];
	cell.storyPhotoView.image = [UIImage imageNamed:@"noimage300.jpg"];
	
    TMBStory* story = self.stories[indexPath.row];
	cell.blogNameLabel.text = story.blogName;
	cell.avatarImageView.image = self.avatar;
	cell.storyPhotoView.frame = CGRectMake(10, 100, 300, 300);
	cell.storyPhotoView.contentMode = UIViewContentModeScaleAspectFit;
	cell.avatarImageView.image = [UIImage imageNamed:@"icon_tumblr.png"];
	cell.constantTag = [story.storyImageURL absoluteString];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		// retrive image on global queue
		UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:story.storyImageURL]];
		
		// UIImage* avatarImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:avatarDict[story.blogName]]];
		
		dispatch_async(dispatch_get_main_queue(), ^{
		
			TMBCustomTableViewCell *cell = (TMBCustomTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
			
			// assign cell image on main thread
			if (img) {
				cell.storyPhotoView.image = img;
				cell.backgroundColor = [UIColor colorWithPatternImage:cell.storyPhotoView.image];
			}
			else {
				cell.storyPhotoView.image = [UIImage imageNamed:@"noimage300.jpg"];
			}
			
//			if (avatarImg) {
//				cell.avatarImageView.image = avatarImg;
//			}
//			else {
//				cell.avatarImageView.image = [UIImage imageNamed:@"icon_tumblr.png"];
//			}
			
			story.storyImage = img;
		});
		
	});
	
	cell.likeButton.titleLabel.text = story.likes;
	cell.likeButton.highlighted = NO;
	cell.storyNotesLabel.text = [NSString stringWithFormat:@"%@ Notes", story.numberOfNotes];
	[cell.storyNotesLabel sizeToFit];
	
	NSMutableString* tagsString;
	
	for (NSString* tag in story.tags) {
		[tagsString appendString:[NSString stringWithFormat:@"#%@, ", tag]];
	}
	
	cell.tagsLabel.text = tagsString;
	[cell.tagsLabel sizeToFit];
	
	cell.followersLabel.text = [NSString stringWithFormat:@"%@ Followers", story.followers];
	[cell.followersLabel sizeToFit];
	
	cell.timeLabel.text = story.time;
	
    return cell;
}

- (IBAction)likeButtonTapped:(id)sender {
	CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
	NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
	
	TMBStory* currentStory = self.stories[hitIndex.row];
	
	// Call the API to post a like on the current story
	if (![[TMBDataManager sharedDataManager] callServerAPIForLikeOnPostID:currentStory.postid reblogKey:currentStory.reblogKey]) {
		[self.errorHUD show:YES];
		[self.errorHUD hide:YES afterDelay:3.0];
	}
}

- (void)registerObservers {
	__weak typeof(self) weakSelf = self;
	_gotPostsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"PostsReceived"
																		  object:nil
																		   queue:nil
																	  usingBlock:^(NSNotification* notif) {
																		  NSArray* stories = notif.userInfo[@"posts"];
																		  if (stories.count > 0) {
																			  for (NSDictionary *postDict in stories) {
																				  TMBStory *story = [TMBStory storyFromJSONDictionary:postDict];
																				  if (story) {
																					  // Call API to fetch the avatar images
//																					  [[TMBDataManager sharedDataManager] callServerAPIForFetchingAvatarForBlogName:story.blogName];
																					  [weakSelf.stories addObject:story];
																				  }
																			  }
																			  
																		
																			  dispatch_async(dispatch_get_main_queue(), ^{
																				  [weakSelf.refreshControl endRefreshing];
																				  [self.loadingHUD hide:YES];
																				  [weakSelf.tableView reloadData];
																				  // Persist these stories
																				  [weakSelf persistStories];
																			  });
																		  }
																		  
																		  NSLog(@"Loaded posts");
																	  }];
	
	_postedLikeObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"PostLiked"
																			object:nil
																			 queue:nil
																		usingBlock:^(NSNotification* notif) {
																			dispatch_async(dispatch_get_main_queue(), ^{
																				weakSelf.likedHUD = [[MBProgressHUD alloc] initWithView:weakSelf.view];
																				[weakSelf.view addSubview:weakSelf.likedHUD];
																				
																				weakSelf.likedHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart.png"]];
																				
																				// Set custom view mode
																				weakSelf.likedHUD.mode = MBProgressHUDModeCustomView;
																				
																				weakSelf.likedHUD.labelText = @"Liked";
																				
																				[weakSelf.likedHUD show:YES];
																				[weakSelf.likedHUD hide:YES afterDelay:3];
																				
																			});
																			
																			NSLog(@"Liked post");
																		}];

	
	_gotAvatarObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"AvatarReceived"
																			object:nil
																			 queue:nil
																		usingBlock:^(NSNotification* notif) {
																			NSURL* avatarURL = notif.userInfo[@"avatarURL"];
																			NSString* blogName = notif.userInfo[@"blogName"];
																			
																			avatarDict[blogName] = avatarURL;
																			
																			NSLog(@"Liked post");
																		}];
	
	

}

- (void)unregisterObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:_gotPostsObserver];
	[[NSNotificationCenter defaultCenter] removeObserver:_postedLikeObserver];
	[[NSNotificationCenter defaultCenter] removeObserver:_gotAvatarObserver];
}

- (void)persistStories {
	Stories *stories = [Stories sharedStories];
	stories.posts = self.stories;
}

@end
