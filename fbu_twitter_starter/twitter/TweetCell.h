//
//  TweetCell.h
//  twitter
//
//  Created by Nikolas Georgaklis on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pfp;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *tweetContent;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) IBOutlet UILabel *retweets;
@property (weak, nonatomic) IBOutlet UILabel *favorites;
@property (nonatomic) int retweetCount;
@property (nonatomic) int favoriteCount;


- (IBAction)didTapReply:(id)sender;
- (IBAction)didTapRetweet:(id)sender;
- (IBAction)didTapMsg:(id)sender;


@property (weak, nonatomic) Tweet *tweet;
@end

NS_ASSUME_NONNULL_END
