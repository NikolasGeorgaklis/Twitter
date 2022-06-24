//
//  TweetCell.m
//  twitter
//
//  Created by Nikolas Georgaklis on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapMsg:(id)sender {
}

- (IBAction)didTapFavorite:(id)sender {
    // TODO: Update the local tweet model
    if (self.tweet.favorited){
        self.tweet.favorited = false;
        self.tweet.favoriteCount -= 1;
    }
    else{
        self.tweet.favorited = true;
        self.tweet.favoriteCount += 1;
    }
    // TODO: Update cell UI
    [self refreshData];
    // TODO: Send a POST request to the POST favorites/create endpoint
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
         if(error){
              NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
         }
     }];
    
}

- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted){
        self.tweet.retweeted = false;
        self.tweet.retweetCount -= 1;
    }
    else{
        self.tweet.retweeted = true;
        self.tweet.retweetCount += 1;
    }
    
    //Update cell
    [self refreshData];
    
    // Send a POST request to the POST favorites/create endpoint
    if (self.tweet.retweeted){
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            } else if (tweet) {
                NSLog(@"Successfully retweeted the following Tweet: \n%@", tweet.text);
            }
        }];
    } else {
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            } else if (tweet) {
                NSLog(@"Successfully unretweeted the following Tweet: \n%@", tweet.text);
            }
        }];
    }
}


- (IBAction)didTapReply:(id)sender {
}


- (void)refreshData{
    self.tweetContent.text = self.tweet.text;
    self.username.text = self.tweet.user.name;
    self.authorName.text = self.tweet.user.screenName;
    self.tweetDate.text = self.tweet.createdAtString;
    NSURL *url = [NSURL URLWithString:self.tweet.user.profilePicture];
    [self.pfp setImageWithURL:url];
    self.retweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favorites.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];

    
    UIImage *favoriteIcon = self.tweet.favorited ? [UIImage imageNamed:@"favor-icon-red.png"] : [UIImage imageNamed:@"favor-icon.png"];
    
    UIImage *retweetIcon = self.tweet.retweeted ? [UIImage imageNamed:@"retweet-icon-green.png"] : [UIImage imageNamed:@"retweet-icon.png"];
    
    [self.btnFavorite setImage:favoriteIcon forState:UIControlStateNormal];
    [self.btnRetweet setImage:retweetIcon forState:UIControlStateNormal];
    
}
@end
