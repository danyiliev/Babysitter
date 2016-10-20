//
//  JobDetailViewController.m
//  Babysitter
//
//  Created by Torrent on 10/4/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import "JobDetailViewController.h"
#import "AppDelegate.h"
#import "ApplyViewController.h"

@implementation JobDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavBar];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [SVProgressHUD dismiss];
}

#pragma mark - Inital setup methods
- (void)setupNavBar{    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@",
                          self.jobObject[@"parent"][@"firstname"],
                          self.jobObject[@"parent"][@"lastname"]];
    self.title = fullName;
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    // right button
    if (self.bFavorite) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"FavoriteSelButton"] style:UIBarButtonItemStylePlain target:self action:@selector(Favorite:)];
        [rightItem setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.navigationItem.rightBarButtonItem.tag = 1;
    }else{
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"FavoriteButton"] style:UIBarButtonItemStylePlain target:self action:@selector(Favorite:)];
        [rightItem setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.navigationItem.rightBarButtonItem.tag = 0;
    }
    
    // left button
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(Back)];
    [leftItem setTintColor:[UIColor whiteColor]];
    leftItem.tag = 0;
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupUI{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // profile image
    NSString *photoUrl = self.jobObject[@"parent"][PHOTO_FIELD];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *result = [photoUrl stringByAddingPercentEncodingWithAllowedCharacters:set];
    [self.posterPhotoView sd_setImageWithURL:[NSURL URLWithString:result]];
    
    // price
    NSString *priceType = [_jobObject objectForKey:@"price_type"];
    if (!priceType || priceType == [NSNull null])
        priceType = @"hour";
    self.jobPriceLabel.text = [NSString stringWithFormat:@"$%@ / %@", [_jobObject objectForKey:JOB_TERM_FIELD], priceType];
    
    // start time and deadline
    NSString *starTime = [self.jobObject objectForKey:JOB_TIME_FIELD];
    NSString *endTime = [self.jobObject objectForKey:JOB_DEADLINE_FIELD];
    self.startTimeLabel.text = starTime;//[starTime substringToIndex:[starTime length] - 9];
    self.endTimeLabel.text = endTime;//[endTime substringToIndex:[starTime length] - 9];
    
    // feedback score - star rating
    self.starRatingCtrl.starImage = [UIImage imageNamed:@"disabledStar_small"];
    self.starRatingCtrl.starHighlightedImage = [UIImage imageNamed:@"enabledStar_small"];
    self.starRatingCtrl.maxRating = 5.0;
    self.starRatingCtrl.horizontalMargin = 5;
    self.starRatingCtrl.editable = YES;
    self.starRatingCtrl.rating = [_jobObject[@"parent"][@"feedback_score"] floatValue];
    self.starRatingCtrl.displayMode=EDStarRatingDisplayAccurate;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.2f", [_jobObject[@"parent"][@"feedback_score"] floatValue]];
    
    self.jobDescTxtView.text = [self.jobObject objectForKey:JOB_DESC_FIELD];
    self.locLabel.text = [self.jobObject objectForKey:LOCATION_FIELD];

    self.titleLabel.text = [self.jobObject objectForKey:@"title"];
}

#pragma mark - Navigation bar button item events
- (IBAction)Back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Favorite:(UIBarButtonItem*)sender{
    if (sender.tag == 1)
        [self unFavorite];
    else
        [self addFavorite];
}

#pragma mark - IBAction methods
- (IBAction)Apply:(id)sender{
    ApplyViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:JOB_APPLY_VC];
    dest.jobObject = self.jobObject;
    [self.navigationController pushViewController:dest animated:YES];
}

#pragma mark - RESTful web service methods
- (void)addFavorite{
    NSInteger userId = [AppDelegate sharedInstance].userId;
    NSString *token = [[AppDelegate sharedInstance].userDefaults objectForKey:@"token"];
    NSString *jobId = self.jobObject[@"id"];

    NSString *urlString = [NSString stringWithFormat:@"%@/%@", BASIC_URL, ADD_FAVORITE];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString
       parameters:@{@"babysitter_id": [NSString stringWithFormat:@"%lu", userId],
                    @"job_id": jobId,
                    @"access_token": token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              
              if ([responseObject[@"result"] intValue] == 1){
                  // success in web service call return
                  NSLog(@"success");
                  self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"FavoriteSelButton"];
                  self.navigationItem.rightBarButtonItem.tag = 1;
              }else{
                  // failure response
                  NSLog(@"failure");
              }

          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }
     ];
}

- (void)unFavorite{
    NSInteger userId = [AppDelegate sharedInstance].userId;
    NSString *token = [[AppDelegate sharedInstance].userDefaults objectForKey:@"token"];
    NSString *jobId = self.jobObject[@"id"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", BASIC_URL, DIS_FAVORITE];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString
       parameters:@{@"babysitter_id": [NSString stringWithFormat:@"%lu", (long)userId],
                    @"job_id": jobId,
                    @"access_token": token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              
              if ([responseObject[@"result"] intValue] == 1){
                  // success in web service call return
                  NSLog(@"success");
                  self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"FavoriteButton"];
                  self.navigationItem.rightBarButtonItem.tag = 0;
              }else{
                  // failure response
                  NSLog(@"failure");
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }
     ];
}

@end
