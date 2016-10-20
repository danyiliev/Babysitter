//
//  FavoriteViewController.m
//  Babysitter
//
//  Created by Torrent on 10/5/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import "FavoriteViewController.h"
#import "JobDetailViewController.h"

#import "AppDelegate.h"
#import "JobFeedCell.h"

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.favList = [[NSMutableArray alloc] init];
    
    //unselected icon tint color
    [[UIView appearanceWhenContainedIn:[UITabBar class], nil] setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self setInitUI];
    [self setupNavBar];
    [self getFavorites];
}

- (void)setInitUI{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _favTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _favTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    _favTableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UI methods
- (void)setupNavBar {
    // Navbar color
    [self.navigationController.navigationBar setAlpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor offWhite];
    [self.navigationController setNavigationBarHidden:NO];
    
    // Adjust nav bar title based on current view identifier
    self.navigationController.navigationBar.topItem.title = FAVROTIE_TITLE;
    // Set title
    self.title = FAVROTIE_TITLE;
    
    self.navigationController.navigationBar.alpha = 1;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorPrimary];
}

#pragma mark - RESTful web service methods
- (void)getFavorites{
    NSInteger userId = [AppDelegate sharedInstance].userId;
    NSString *token = [[AppDelegate sharedInstance].userDefaults objectForKey:@"token"];

    [SVProgressHUD show];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/babysitter/%lu/favorites", BASIC_URL, userId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString
      parameters:@{@"babysitter_id": [NSString stringWithFormat:@"%lu", userId],
                   @"access_token": token}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             
             if ([responseObject[@"result"] intValue] == 1){
                 // success in web service call return
                 self.favList = responseObject[@"data"];
                 [self.favTableView reloadData];
             }else{
                 // failure response
             }
             
             [SVProgressHUD dismiss];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             [SVProgressHUD dismiss];
         }
     ];
}

#pragma mark - UITableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.favList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"JobFeedCell";
    JobFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[JobFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.favList && self.favList.count > 0){
        NSMutableDictionary *jobObject = [self.favList objectAtIndex:indexPath.row];
        
        // image
        NSString *photoUrl = jobObject[@"parent"][PHOTO_FIELD];
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *result = [photoUrl stringByAddingPercentEncodingWithAllowedCharacters:set];
        [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:result]];

        // name
        NSString *fullName = [NSString stringWithFormat:@"%@ %@",
                              jobObject[@"parent"][@"firstname"],
                              jobObject[@"parent"][@"lastname"]];
        cell.nameLabel.text = fullName;

        // price
        NSString *priceType = [jobObject objectForKey:@"price_type"];
        if (!priceType || priceType == [NSNull null])
            priceType = @"hour";
        cell.termLabel.text = [NSString stringWithFormat:@"$%@ / %@", [jobObject objectForKey:JOB_TERM_FIELD], priceType];
        cell.termLabel.textAlignment = NSTextAlignmentRight;

        // feedback score - star rating
        cell.starRatingCtrl.starImage = [UIImage imageNamed:@"disabledStar_small"];
        cell.starRatingCtrl.starHighlightedImage = [UIImage imageNamed:@"enabledStar_small"];
        cell.starRatingCtrl.maxRating = 5.0;
        cell.starRatingCtrl.horizontalMargin = 5;
        cell.starRatingCtrl.editable = YES;
        cell.starRatingCtrl.rating = [jobObject[@"parent"][@"feedback_score"] floatValue];
        cell.starRatingCtrl.displayMode=EDStarRatingDisplayAccurate;
        cell.scoreLabel.text = [NSString stringWithFormat:@"%.2f", cell.starRatingCtrl.rating];

        cell.descLabel.text = [jobObject objectForKey:JOB_DESC_FIELD];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kJOB_CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JobDetailViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:JOB_DETAIL_VC];
    dest.jobObject = [self.favList objectAtIndex:indexPath.row];
    dest.bFavorite = YES;
    [self.navigationController pushViewController:dest animated:YES];
}

@end
