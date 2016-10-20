//
//  ProfileViewController.m
//  Babysitter
//
//  Created by Torrent on 11/6/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "ProfileCell.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self setupNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getMe];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UI methods
- (void)setupUI{
    // Add border
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.borderColor = [UIColor colorPrimary].CGColor;
    self.profileInfoView.layer.borderWidth = 0.7;
    self.profileInfoView.layer.borderColor = [UIColor lightGrayColor].CGColor;

    // round rect for information overlay view
    self.profileInfoView.layer.cornerRadius = 10;
    self.profileInfoView.layer.masksToBounds = YES;
    self.profileInfoView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    // Make add image button as circle shape
    self.imageView.layer.cornerRadius = self.addImageButton.frame.size.height/2;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.imageView.layer.shouldRasterize = YES;
    self.imageView.clipsToBounds = YES;
}

- (void)setUIContents:(NSDictionary*)userInfo{
    // Set photo
    NSString *photoUrl = userInfo[PHOTO_FIELD];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *result = [photoUrl stringByAddingPercentEncodingWithAllowedCharacters:set];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:result]];
    
    // Feedback score - star rating
    self.starRatingCtrl.starImage = [UIImage imageNamed:@"disabledStar"];
    self.starRatingCtrl.starHighlightedImage = [UIImage imageNamed:@"enabledStar"];
    self.starRatingCtrl.maxRating = 5.0;
    self.starRatingCtrl.horizontalMargin = 5;
    self.starRatingCtrl.editable = YES;
    self.starRatingCtrl.rating = [userInfo[@"feedback_score"] floatValue];
    self.starRatingCtrl.displayMode=EDStarRatingDisplayAccurate;
    
    // Job description
//    self.descTxtView.text = userInfo[@"description"];
    [_profileInfoView reloadData];
}

- (void)setupNavBar {
    // Navbar color
    self.navigationController.navigationBar.tintColor = [UIColor offWhite];
    [self.navigationController setNavigationBarHidden:NO];
    
    // Adjust nav bar title based on current view identifier
    self.navigationController.navigationBar.topItem.title = PROFILE_TITLE;
    // Set title
    self.title = PROFILE_TITLE;
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(EditProfile)];
//    [rightItem setTintColor:[UIColor whiteColor]];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationController.navigationBar.alpha = 1;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorPrimary];
}

#pragma mark - Navigation bar button item events
- (IBAction)Back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)EditProfile{
}

#pragma mark - IBAction methods
- (IBAction)AddPhoto:(id)sender{
    self.cameraActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:@"Camera"
                                                otherButtonTitles:@"Photo Album", nil];
    
    // Show the actionsheet
    [self.cameraActionSheet showInView:self.view];
}

#pragma mark - RESTful web service methods
- (void)getMe{
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
                 [self setUIContents:[AppDelegate sharedInstance].userInfo];
             }else{
                 
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }
     ];
}

# pragma mark - getPicture
-(void)getPicture {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)getCamera {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)checkForCamera{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[AppDelegate sharedInstance] showAlertMessage:@"Error" message:@"Device has no camera" buttonTitle:@"OK"] ;
    }else{
        [self getCamera];
    }
}

# pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.imgToUpload = info[UIImagePickerControllerEditedImage];
    [self.addImageButton setBackgroundImage:_imgToUpload forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


# pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == _cameraActionSheet){
        switch (buttonIndex) {
            case 0:
                // launch camera
                [self checkForCamera];
                break;
            case 1:
                // load photo album
                [self getPicture];
                break;
            default:
                break;
        }
    }
}


#pragma mark - UITableView Delegate & Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
        return 44.0;
    else
        return 150;
        
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return 5;
    else
        return 1;

    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID;
    NSDictionary *userInfo = [AppDelegate sharedInstance].userInfo;

    if (indexPath.section == 0) {
        cellID = @"profileCell";
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        [cell.phoneTxtField setHidden:YES];
        [cell.addressTxtField setHidden:YES];
        
        switch (indexPath.row) {
            case 0:
                cell.infoLabel.text = userInfo[@"username"];

                break;
            case 1:
                cell.infoLabel.text = [NSString stringWithFormat:@"%@ %@",
                                  userInfo[@"firstname"], userInfo[@"lastname"]];
                break;
            case 2:
                cell.infoLabel.text = userInfo[@"email"];
                break;
            case 3:
                cell.phoneTxtField.text = userInfo[@"phone"];
                [cell.phoneTxtField setHidden:NO];
                break;
            case 4:
                cell.addressTxtField.text = userInfo[@"address"];
                [cell.addressTxtField setHidden:NO];
                break;
            default:
                break;
        }
        
        return cell;
    }else if (indexPath.section == 1){
        cellID = @"descCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }

        UITextView *descTxtView = (UITextView*)[cell viewWithTag:73];

        descTxtView.frame = CGRectMake(0, 0, cell.contentView.frame.size.width, 300);
        descTxtView.text = userInfo[@"description"];
        [descTxtView setHidden:NO];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    _usernameTxtField.text = userInfo[@"username"];
    //    _firstnameTxtField.text = userInfo[@"firstname"];
    //    _lastnameTxtField.text = userInfo[@"lastname"];
    //    _emailTxtField.text =  userInfo[@"email"];
    //    _addressTxtField.text = userInfo[@"address"];
    
    //    NSString *lastFourDigits = [userInfo[@"credit_card"] substringFromIndex:[userInfo[@"credit_card"] length] - 4];
    //    _creditTxtField.text = [NSString stringWithFormat:@"********%@", lastFourDigits];
}

#pragma mark - UITextField & Keyboard Delegates
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [tempField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    tempField = textField;
    [self keyboardWillShow];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self keyboardWillHide];
    
    if (textField.tag == 71) {
        phoneNum = textField.text;
    }else if (textField.tag == 72){
        address = textField.text;
    }
    
    [textField resignFirstResponder];
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

//method to move the view up/down whenever the keyboard is shown/dismissed
- (void)setViewMovedUp:(BOOL)movedUp{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp){
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= 150;
        
    }
    else{
        // revert back to the normal state.
        rect.origin.y += 150;
        
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

@end
