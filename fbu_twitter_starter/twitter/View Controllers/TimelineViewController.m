//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController
- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    //clear out access tokens
    [[APIManager shared] logout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    // Get timeline
    [self getTimeline];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)getTimeline {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.arrayOfTweets = [tweets mutableCopy];
            [self.tableView reloadData];

        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    cell.tweet = tweet;
    cell.authorName.text = tweet.user.name;
    cell.username.text = tweet.user.screenName;
    cell.tweetDate.text = tweet.createdAtString;
    cell.tweetContent.text = tweet.text;
    cell.retweets.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.favorites.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    
    //update favorite button color accordingly
    UIImage *favoriteIcon = tweet.favorited ? [UIImage imageNamed:@"favor-icon-red.png"] : [UIImage imageNamed:@"favor-icon.png"];
    [cell.btnFavorite setImage:favoriteIcon forState:UIControlStateNormal];
    
    //update favorite button color accordingly
    UIImage *retweetIcon = tweet.retweeted ? [UIImage imageNamed:@"retweet-icon-green.png"] : [UIImage imageNamed:@"retweet-icon.png"];
    [cell.btnRetweet setImage:retweetIcon forState:UIControlStateNormal];



    
    
    //update favorite/retweet counts
    //[cell refreshData];
        
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    cell.pfp.image = [UIImage imageWithData:urlData];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}
- (void)didTweet:(Tweet *)tweet{
    [self.arrayOfTweets addObject:tweet];
    [self.tableView reloadData];
    [self getTimeline];
}

//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"retweetS"]){
        UINavigationController *navigationController = [segue destinationViewController];
            ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
            composeController.delegate = self;
    }
    if([[segue identifier] isEqualToString:@"detailsSeg"]){
        UINavigationController *navigationController = [segue destinationViewController];
        DetailsViewController *tweetDest = (DetailsViewController*)navigationController.topViewController;
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        tweetDest.tweet = tweet;
            
    }
}



@end
