//
//  ContractViewController.m
//  Babysitter
//
//  Created by Torrent on 11/6/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import "ContractViewController.h"
#import "ContractDetailViewController.h"
#import "AppDelegate.h"
#import "ContractCell.h"

@interface ContractViewController (){
    NSMutableArray *babysitters, *contracts, *jobs, *parents;
}

@end

@implementation ContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self setupNavBar];
    [self setupTableView];
    [self setInitUI];
    [self getContracts];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setInitUI{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.contractTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contractTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contractTableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UI methods
- (void)setupNavBar {
    // Navbar color
    [self.navigationController.navigationBar setAlpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor offWhite];
    [self.navigationController setNavigationBarHidden:NO];
    
    // Adjust nav bar title based on current view identifier
    self.navigationController.navigationBar.topItem.title = CONTRACT_TITLE;
    // Set title
    self.title = CONTRACT_TITLE;
    
    self.navigationController.navigationBar.alpha = 1;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorPrimary];
}

- (void)setupTableView{
    self.contractList = [[NSArray alloc] init];
}

#pragma mark - RESTful web service methods
- (void)getContracts{
    NSInteger userId = [AppDelegate sharedInstance].userId;
    NSString *token = [[AppDelegate sharedInstance].userDefaults objectForKey:@"token"];
    
    [SVProgressHUD show];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/babysitter/%lu/contracts", BASIC_URL, userId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString
      parameters:@{@"access_token": token}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             
             if ([responseObject[@"result"] intValue] == 1){
                 // success in web service call return
                 if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                     self.contractList = [NSMutableArray arrayWithObject:responseObject[@"data"]];
                 }else if ([responseObject[@"data"] isKindOfClass:[NSArray class]]){
                     self.contractList = [NSMutableArray arrayWithArray:responseObject[@"data"]];
                 }
                 
                 [_contractTableView reloadData];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kJOB_CELL_HEIGHT - 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contractList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ContractCell";
    ContractCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ContractCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_contractList && _contractList.count > 0){
        NSMutableDictionary *contract = [_contractList objectAtIndex:indexPath.row];
        NSDictionary *jobInfo = contract[@"jobinfo"];
        NSDictionary *babysitterInfo = contract[@"babysitter_info"];
        
        // image
        NSString *photoUrl = babysitterInfo[PHOTO_FIELD];
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *result = [photoUrl stringByAddingPercentEncodingWithAllowedCharacters:set];
        [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:result]];
     
        // price
        NSString *priceType = [jobInfo objectForKey:@"price_type"];
        if (!priceType || priceType == [NSNull null])
            priceType = @"hour";
        cell.termLabel.text = [NSString stringWithFormat:@"$%@ / %@", [jobInfo objectForKey:JOB_TERM_FIELD], priceType];

        // name
        NSString *fullName = [NSString stringWithFormat:@"%@ %@",
                              babysitterInfo[@"firstname"],
                              babysitterInfo[@"lastname"]];
        cell.nameLabel.text = fullName;

        cell.descLabel.text = [jobInfo objectForKey:JOB_DESC_FIELD];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ContractDetailViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:@"ContractDetailViewController"];
    dest.contractObject = [self.contractList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dest animated:YES];
}

@end
