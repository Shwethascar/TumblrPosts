//
//  TMBCustomCollectionViewCell.h
//  Tumblrbot
//
//  Created by Shwetha Gopalan on 8/18/14.
//  Copyright (c) 2014 Matthew Bischoff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMBCustomTableViewCell : UITableViewCell
{
    BOOL configured;
}

@property (weak, nonatomic) IBOutlet UILabel *blogNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *storyNotesLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storyPhotoView;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;

@property (strong, nonatomic) IBOutlet UIView *customCellView;
@property (nonatomic, strong) NSString *constantTag;

@end
