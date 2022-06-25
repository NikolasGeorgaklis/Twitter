//
//  DetailsViewController.m
//  twitter
//
//  Created by Nikolas Georgaklis on 6/24/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//
#import "Tweet.h"
#import "TimelineViewController.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "DateTools.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pfp;
@property (weak, nonatomic) IBOutlet UILabel *tweetContent;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) IBOutlet UILabel *numRetweets;
@property (weak, nonatomic) IBOutlet UILabel *numFavorites;
@property (weak, nonatomic) IBOutlet UIButton *btnRetweet;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;
@property (nonatomic) BOOL *favorited;
@property (nonatomic) BOOL *retweeted;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tweetContent.text = _tweet.text;
    self.username.text = _tweet.user.screenName;
    self.authorName.text = _tweet.user.name;
    self.tweetDate.text = _tweet.createdAtString;
    self.numRetweets.text = [NSString stringWithFormat: @"%d", self.tweet.retweetCount];
    self.numFavorites.text = [NSString stringWithFormat: @"%d", self.tweet.favoriteCount];

    NSString *URLString = _tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];

    self.pfp.image = nil;
    [self.pfp setImageWithURL:url];
    UIImage *favoriteIcon = self.tweet.favorited ? [UIImage imageNamed:@"favor-icon-red.png"] : [UIImage imageNamed:@"favor-icon.png"];
    
    UIImage *retweetIcon = self.tweet.retweeted ? [UIImage imageNamed:@"retweet-icon-green.png"] : [UIImage imageNamed:@"retweet-icon.png"];
    
    [self.btnFavorite setImage:favoriteIcon forState:UIControlStateNormal];
    [self.btnRetweet setImage:retweetIcon forState:UIControlStateNormal];
    
}
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)favorite:(id)sender {
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
    if (self.tweet.favorited) {
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else if (tweet){
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
    } else {
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else if (tweet) {
                NSLog(@"Successfully unfavorited the following Tweet: \n%@", tweet.text);
            }
        }];
    }
    
}
- (IBAction)retweet:(id)sender {
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
-(void)refreshData{
    self.tweetContent.text = self.tweet.text;
    self.username.text = self.tweet.user.screenName;
    self.authorName.text = self.tweet.user.name;
    self.tweetDate.text = self.tweet.createdAtString;
    NSURL *url = [NSURL URLWithString:self.tweet.user.profilePicture];
    [self.pfp setImageWithURL:url];
    self.numRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.numFavorites.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];

    
    UIImage *favoriteIcon = self.tweet.favorited ? [UIImage imageNamed:@"favor-icon-red.png"] : [UIImage imageNamed:@"favor-icon.png"];
    
    UIImage *retweetIcon = self.tweet.retweeted ? [UIImage imageNamed:@"retweet-icon-green.png"] : [UIImage imageNamed:@"retweet-icon.png"];
    
    [self.btnFavorite setImage:favoriteIcon forState:UIControlStateNormal];
    [self.btnRetweet setImage:retweetIcon forState:UIControlStateNormal];
}

@end
