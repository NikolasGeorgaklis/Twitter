//
//  ComposeViewController.m
//  twitter
//
//  Created by Nikolas Georgaklis on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetBox;
- (IBAction)didTapTweet:(id)sender;
- (IBAction)didTapClose:(id)sender;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)didTapTweet:(id)sender {
    [[APIManager shared] postStatusWithText:self.tweetBox.text completion:^(Tweet *tweet, NSError *error) {
        if (error){
            NSLog(@"Error composing tweet.");
        }
        else{
            NSLog(@"Tweet composition success");
            }
    }];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
