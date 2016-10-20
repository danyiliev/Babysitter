//
//  ContractDetailViewController.m
//  Parent
//
//  Created by Torrent on 11/27/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import "ContractDetailViewController.h"
#import "AppDelegate.h"
#import "Define.h"

@interface ContractDetailViewController ()

@end

@implementation ContractDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self setupNavBar];
    [self setupUI];
    [self setDateFormat];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Set date format
- (void)setDateFormat{
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
}

#pragma mark - Inital setup methods
- (void)setupNavBar{
    NSDictionary *babysitterInfo = self.contractObject[@"babysitter_info"];
    // name
    NSString *fullName = [NSString stringWithFormat:@"%@ %@",
                          babysitterInfo[@"firstname"],
                          babysitterInfo[@"lastname"]];
    self.title = fullName;
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    // left button
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(Back)];
    [leftItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupUI{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSDictionary *jobInfo = _contractObject[@"jobinfo"];
    
    // profile image
    NSString *photoUrl = [AppDelegate sharedInstance].userInfo[PHOTO_FIELD];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *result = [photoUrl stringByAddingPercentEncodingWithAllowedCharacters:set];
    [self.posterPhotoView sd_setImageWithURL:[NSURL URLWithString:result]];
    
    // job contents
    self.titleLabel.text = [jobInfo objectForKey:@"title"];
    self.jobDescTxtView.text = [jobInfo objectForKey:JOB_DESC_FIELD];
    self.locLabel.text = [jobInfo objectForKey:LOCATION_FIELD];
    
    // price
    NSString *priceType = [jobInfo objectForKey:@"price_type"];
    if (!priceType || priceType == [NSNull null])
        priceType = @"hour";
    self.jobPriceLabel.text = [NSString stringWithFormat:@"$%@ / %@", [jobInfo objectForKey:JOB_TERM_FIELD], priceType];

    // start time & deadline
    NSString *starTime = [jobInfo objectForKey:JOB_TIME_FIELD];
    NSString *endTime = [jobInfo objectForKey:JOB_DEADLINE_FIELD];
    self.startTimeLabel.text = starTime;
    self.endTimeLabel.text = endTime;
    
    // static - feedback score - star rating
    self.starRatingCtrl_small.starImage = [UIImage imageNamed:@"disabledStar_small"];
    self.starRatingCtrl_small.starHighlightedImage = [UIImage imageNamed:@"enabledStar_small"];
    self.starRatingCtrl_small.maxRating = 5.0;
    self.starRatingCtrl_small.horizontalMargin = 5;
    self.starRatingCtrl_small.editable = YES;
    self.starRatingCtrl_small.rating = [jobInfo[@"parent"][@"feedback_score"] floatValue];
    self.starRatingCtrl_small.displayMode=EDStarRatingDisplayAccurate;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.2f", [jobInfo[@"parent"][@"feedback_score"] floatValue]];
    
    // interactive - feedback score - star rating
    _starRatingCtrl.starImage = [UIImage imageNamed:@"disabledStar"];
    _starRatingCtrl.starHighlightedImage = [UIImage imageNamed:@"enabledStar"];
    _starRatingCtrl.maxRating = 5.0;
    _starRatingCtrl.delegate = self;
    _starRatingCtrl.horizontalMargin = 5;
    _starRatingCtrl.editable = YES;
    _starRatingCtrl.rating= 1.0;
    _starRatingCtrl.displayMode=EDStarRatingDisplayAccurate;
    
    [self starsSelectionChanged:_starRatingCtrl rating:1.0];
    _starRatingCtrl.returnBlock = ^(float rating ){
        NSLog(@"ReturnBlock: Star rating changed to %.1f", rating);
        
        // For the sample, Just reuse the other control's delegate method and call it
        [self starsSelectionChanged:_starRatingCtrl rating:rating];
    };
}

#pragma mark - Navigation bar button item events
- (IBAction)Back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBAction methods
- (IBAction)SendInvoice:(id)sender{
    NSDictionary *parentInfo = self.contractObject[@"parent_info"];
    NSDictionary *senderInfo = [AppDelegate sharedInstance].userInfo;

    [self sendEmail:parentInfo[@"email"] toName:parentInfo[USERNAME_FIELD] senderEmail:senderInfo[@"email"] senderName:senderInfo[USERNAME_FIELD] subject:@"Invoice" content:_invoiceTxtView.text];
    
    [self.invoiceView setHidden:YES];
}

- (IBAction)ShowInvoice:(id)sender{
    [self.invoiceView setHidden:NO];
}

- (IBAction)EndContract:(id)sender{
    [self endContract];
}

- (IBAction)Feedback:(id)sender{
    [self leaveFeedback];
    [self.feedbackView setHidden:YES];

    [_scoreTxtField resignFirstResponder];
    [_reviewTxtView resignFirstResponder];
}

#pragma mark - Webservice related method
- (void)sendEmail:(NSString*)toEmail toName:(NSString*)receiverName senderEmail:(NSString*)fromEmail senderName:(NSString*)senderName subject:(NSString*)subject content:(NSString*)content{

    NSString *token = [[AppDelegate sharedInstance].userDefaults objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", BASIC_URL, EMAIL_SEND];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString
       parameters:@{@"from": fromEmail,
                    @"from_name": senderName,
                    @"to": toEmail,
                    @"to_name": receiverName,
                    @"subject": subject,
                    @"content": content,
                    @"access_token": token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              
              if ([responseObject[@"result"] intValue] == 1){
                  // success in web service call return
                  [[AppDelegate sharedInstance] showAlertMessage:@"Congratulation" message:@"Invoice is sent successfully." buttonTitle:@"Ok"];

              }else{
                  // failure response
                  NSString *key = [[responseObject[@"message"] allKeys] firstObject];
                  [[AppDelegate sharedInstance] showAlertMessage:@"Error" message:[[responseObject[@"message"] objectForKey:key] firstObject] buttonTitle:@"Ok"];
              }
              [SVProgressHUD dismiss];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [SVProgressHUD dismiss];
          }
     ];
}

- (void)endContract{
    NSString *token = [[AppDelegate sharedInstance].userDefaults objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/contract/%@/end", BASIC_URL, _contractObject[@"id"]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString
       parameters:@{@"contract_id": _contractObject[@"id"],
                    @"babysitter_id": _contractObject[@"babysitter_id"],
                    @"babyparent_id": _contractObject[@"babyparent_id"],
                    @"score": _scoreTxtField.text,
                    @"review": _reviewTxtView.text,
                    @"access_token": token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              
              if ([responseObject[@"result"] intValue] == 1){
                  // success in web service call return
                  [self.feedbackView setHidden:NO];
              }else{
                  // failure response
                  NSString *key = [[responseObject[@"message"] allKeys] firstObject];
                  [[AppDelegate sharedInstance] showAlertMessage:@"Error" message:[[responseObject[@"message"] objectForKey:key] firstObject] buttonTitle:@"Ok"];
              }
              
              [SVProgressHUD dismiss];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
              [SVProgressHUD dismiss];
          }
     ];
}

- (void)leaveFeedback{
    NSString *token = [[AppDelegate sharedInstance].userDefaults objectForKey:@"token"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", BASIC_URL, END_CONTRACT];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString
       parameters:@{@"contract_id": _contractObject[@"id"],
                    @"babysitter_id": _contractObject[@"babysitter_id"],
                    @"babyparent_id": _contractObject[@"babyparent_id"],
                    @"score": _scoreTxtField.text,
                    @"review": _reviewTxtView.text,
                    @"access_token": token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              
              if ([responseObject[@"result"] intValue] == 1){
                  // success in web service call return
                  [[AppDelegate sharedInstance] showAlertMessage:@"Success" message:@"Contract is ended successfully" buttonTitle:@"Ok"];
                  
              }else{
                  // failure response
                  NSString *key = [[responseObject[@"message"] allKeys] firstObject];
                  [[AppDelegate sharedInstance] showAlertMessage:@"Error" message:[[responseObject[@"message"] objectForKey:key] firstObject] buttonTitle:@"Ok"];
              }
              
              [SVProgressHUD dismiss];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
              [SVProgressHUD dismiss];
          }
     ];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - EDStarRatingProtocol
-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating{
    NSString *ratingString = [NSString stringWithFormat:@"%.1f", rating];
    _scoreTxtField.text = ratingString;
}

#pragma mark - MFMailComposerViewDelegate methods
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.invoiceView setHidden:YES];
    [self.feedbackView setHidden:YES];
}

#pragma mark - UITextField & Keyboard Delegates
// Set the currency symbol if the text field is blank when we start to edit.
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.text.length  == 0){
        textField.text = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // Make sure that the currency symbol is always at the beginning of the string:
    if (![newText hasPrefix:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol]]){
        return NO;
    }
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

#pragma mark - UITextView delegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
    [self keyboardWillShow];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self keyboardWillHide];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - Keyboard related methods
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
        rect.origin.y -= 100;
        
    }
    else{
        // revert back to the normal state.
        rect.origin.y += 100;
        
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

@end
