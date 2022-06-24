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

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pfp;
@property (weak, nonatomic) IBOutlet UILabel *tweetContent;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *username;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tweetContent.text = _tweet.text;
    self.username.text = _tweet.user.screenName;
    self.authorName.text = _tweet.user.name;
    
    NSString *URLString = _tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    
    self.pfp.image = nil;
    [self.pfp setImageWithURL:url];
    
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

@end
