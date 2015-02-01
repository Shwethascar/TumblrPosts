//
//  TMBDashboardViewController.h
//  Tumblrbot
//
//  Created by Shwetha Gopalan on 8/18/14.
//  Copyright (c) 2014 Matthew Bischoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface TMBDashboardViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *stories;
@property (nonatomic, strong) UIImage *avatar;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) MBProgressHUD *likedHUD;
@property (nonatomic, strong) MBProgressHUD *loadingHUD;
@property (nonatomic, strong) MBProgressHUD *errorHUD;

@end
