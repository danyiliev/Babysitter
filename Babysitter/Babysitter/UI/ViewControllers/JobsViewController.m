//
//  JobsViewController.m
//  Babysitter
//
//  Created by Torrent on 10/3/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import "JobsViewController.h"
#import "JobFeedCell.h"
#import "AppDelegate.h"
#import "JobDetailViewController.h"

@interface JobsViewController ()

@end

@implementation JobsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.tabBarItem.image = [[UIImage imageNamed:@"TabIcon-Jobs"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
        
    if (![AppDelegate sharedInstance].userInfo)
        [self getUserInfo];
    
    [self setupNavBar];
    [self loadIconsTabBar];
    [self setupTableView];
    [self setInitUI];
    
    [self getJobs];
    [self getFavorites];
}

- (void)setInitUI{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _jobsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _jobsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    _jobsTableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UI methods
-(void) loadIconsTabBar{
    UITabBar *tabBar = self.tabBarController.tabBar;
    
    UITabBarItem *firstTab = [tabBar.items objectAtIndex:0];
    UITabBarItem *secondTab = [tabBar.items objectAtIndex:1];
    UITabBarItem *thirdTab = [tabBar.items objectAtIndex:2];
    UITabBarItem *fourthTab = [tabBar.items objectAtIndex:3];
    
    firstTab.image = [[UIImage imageNamed:@"TabIcon-Jobs"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    firstTab.selectedImage = [[UIImage imageNamed:@"TabIcon-Jobs"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    secondTab.image = [[UIImage imageNamed:@"TabIcon-Fav"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    secondTab.selectedImage = [[UIImage imageNamed:@"TabIcon-Fav"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    thirdTab.image = [[UIImage imageNamed:@"TabIcon-Contract"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    thirdTab.selectedImage = [[UIImage imageNamed:@"TabIcon-Contract"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    fourthTab.image = [[UIImage imageNamed:@"TabIcon-Profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    fourthTab.selectedImage = [[UIImage imageNamed:@"TabIcon-Profile"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setupNavBar {
    // Navbar color
    [self.navigationController.navigationBar setAlpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor offWhite];
    [self.navigationController setNavigationBarHidden:NO];
    
    // Adjust nav bar title based on current view identifier
    self.navigationController.navigationBar.topItem.title = JOBS_TITLE;
    // Set title
    self.title = JOBS_TITLE;
    
    self.navigationController.navigationBar.alpha = 1 ;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorPrimary];
}

- (void)setupTableView{
    self.jobList = [[NSArray alloc] init];
}

#pragma mark - RESTful web service methods
- (void)getUserInfo{
    NSInteger userId = [AppDelegate sharedInstance].userId;
    NSString *token = [[AppDelegate sharedInstance].userDefaults objectForKey:@"token"];

    NSString *urlString = [NSString stringWithFormat:@"%@/api/babysitter/%lu", BASIC_URL, userId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString
      parameters:@{@"access_token": token}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             
             if ([responseObject[@"result"] intValue] == 1) {
                 [AppDelegate sharedInstance].userInfo = responseObject[@"data"];
             }else{
                 
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }
     ];
}

- (void)getJobs{
    NSInteger userId = [AppDelegate sharedInstance].userId;
    NSString *token = [[AppDelegate sharedInstance].userDefaults objectForKey:@"token"];
    NSString *lonString = [NSString stringWithFormat:@"%f", [AppDelegate sharedInstance].startLocation.coordinate.longitude];
    NSString *latString = [NSString stringWithFormat:@"%f", [AppDelegate sharedInstance].startLocation.coordinate.latitude];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/babysitter/%lu/jobs", BASIC_URL, (long)userId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString
      parameters:@{@"latitude": latString,
                   @"longitude": lonString,
                   @"access_token": token}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             
             if (responseObject) {
                  // success in web service call return
                  if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                      self.jobList = [NSMutableArray arrayWithObject:responseObject[@"data"]];
                  }else if ([responseObject[@"data"] isKindOfClass:[NSArray class]]){
                      self.jobList = responseObject[@"data"];
                  }
                 
                 filteredListContent = [NSMutableArray arrayWithArray:_jobList];
                 [self.jobsTableView reloadData];
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
                 [AppDelegate sharedInstance].favoriteList = responseObject[@"data"];
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


#pragma mark - Navigation
- (void)gotoNextView:(NSString*)identifier{
}

- (void)filter{
}

#pragma mark - UITableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return filteredListContent.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"JobFeedCell";
    JobFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[JobFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (filteredListContent && filteredListContent.count > 0){
        NSMutableDictionary *jobObject = [filteredListContent objectAtIndex:indexPath.row];
        
        // profile image
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
        
        // applied status
        if ([jobObject[@"applied"] integerValue] == 1) {
            [cell.appliedBadge setHidden:NO];
        }else{
            [cell.appliedBadge setHidden:YES];
        }
        
        cell.descLabel.text = [jobObject objectForKey:JOB_DESC_FIELD];
        cell.locLabel.text = [jobObject objectForKey:@"location"];
        // [NSString stringWithFormat:@"%@, %@", [jobObject[@"parent"] objectForKey:@"city"], [jobObject[@"parent"] objectForKey:@"state"]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kJOB_CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [SVProgressHUD show];

    [_searchTxtField resignFirstResponder];

    JobDetailViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:JOB_DETAIL_VC];
    dest.jobObject = [filteredListContent objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:dest animated:YES];
}

#pragma mark - UITextField & Keyboard Delegates
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_searchTxtField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if ([textField.text isEqualToString:@""]){
        filteredListContent = [NSMutableArray arrayWithArray:_jobList];
    }else{
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"%K.%K contains %@", @"parent", USERNAME_FIELD, textField.text];
        filteredListContent = (NSMutableArray*)[_jobList filteredArrayUsingPredicate:resultPredicate];
    }

    [_jobsTableView reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0){
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0){
        //        [self setViewMovedUp:NO];
    }
}

- (void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0){
        //        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0){
        [self setViewMovedUp:NO];
    }
}

///method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp){
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_KEYBOARD;
    }
    else{
        // revert back to the normal state.
        rect.origin.y += kOFFSET_KEYBOARD;
        //        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

@end
