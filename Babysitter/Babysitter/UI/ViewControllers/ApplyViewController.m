//
//  ApplyViewController.m
//  Babysitter
//
//  Created by Torrent on 10/5/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import "ApplyViewController.h"
#import "AppDelegate.h"

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self setupNavBar];
    [self setDateFormat];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
}


#pragma mark - Inital setup methods
- (void)setupNavBar{
    NSString *fullName = [NSString stringWithFormat:@"%@ %@",
                          self.jobObject[@"parent"][@"firstname"],
                          self.jobObject[@"parent"][@"lastname"]];
    self.title = fullName;
    
    // right button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ApplyButtonItem"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(Apply)];
    [rightItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // left button
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(Back)];
    [leftItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setupUI{
    // job contents
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.priceTxtField.text = [NSString stringWithFormat:@"$%@", [_jobObject objectForKey:JOB_TERM_FIELD]];
    
    // round rect for information overlay view
    self.coverLetterTxtView.layer.cornerRadius = 10;
    self.coverLetterTxtView.layer.masksToBounds = YES;
}

#pragma mark - Set date format
- (void)setDateFormat{
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
}

#pragma mark - Navigation bar button item events
- (IBAction)Back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Apply{
    NSLog(@"_jobObject == %@", [AppDelegate sharedInstance].userInfo);
    [self applyJob];
}

#pragma mark - IBAction methods
- (IBAction)SetStartTime:(id)sender{
    [_dateSetView setHidden:NO];
    pickerKeyword = @"start";
    
    [_priceTxtField resignFirstResponder];
    [_coverLetterTxtView resignFirstResponder];
}

- (IBAction)SetEndTime:(id)sender{
    [_dateSetView setHidden:NO];
    pickerKeyword = @"end";
    
    [_priceTxtField resignFirstResponder];
    [_coverLetterTxtView resignFirstResponder];    
}

- (IBAction)DoneDatePicker:(id)sender{
    if ([pickerKeyword isEqualToString:@"start"]) {
        _startTime = _datePicker.date;
        [_startTimeButton setTitle:[dateFormatter stringFromDate:_startTime] forState:UIControlStateNormal];
    }else if ([pickerKeyword isEqualToString:@"end"]) {
        _endTime = _datePicker.date;
        [_endTimeButton setTitle:[dateFormatter stringFromDate:_endTime] forState:UIControlStateNormal];
    }
    
    [_dateSetView setHidden:YES];
    pickerKeyword = nil;
}

- (IBAction)CancelDatePicker:(id)sender{
    [_dateSetView setHidden:YES];
    pickerKeyword = nil;
}

#pragma mark - RESTful web service methods
- (void)applyJob{
    NSString *token = [[AppDelegate sharedInstance].userDefaults objectForKey:@"token"];
    NSString *starTime = [self.jobObject objectForKey:JOB_TIME_FIELD];
    NSString *endTime = [self.jobObject objectForKey:JOB_DEADLINE_FIELD];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", BASIC_URL, APPLY];
    NSLog(@"cover letter:%@", _coverLetterTxtView.text);
    
    if ((_priceTxtField.text.length < 1) ||
        (_coverLetterTxtView.text.length < 1) ||
        starTime == nil ||
        endTime == nil){
        [[AppDelegate sharedInstance] showAlertMessage:@"Error" message:@"Please fill out the information." buttonTitle:@"Ok"];
    }else{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:urlString
           parameters:@{@"babysitter_id": [NSString stringWithFormat:@"%lu", (long)[AppDelegate sharedInstance].userId],
                        @"job_id": _jobObject[@"id"],
                        @"price": [_priceTxtField.text substringFromIndex:1] ,
                        @"price_type": _jobObject[@"price_type"],
                        @"start_time": starTime,
                        @"end_time": endTime,
                        @"cover_letter": _coverLetterTxtView.text,
                        @"access_token": token
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"JSON: %@", responseObject);
                  
                  if ([responseObject[@"result"] intValue] == 1){
                      // success in web service call return
                      [[AppDelegate sharedInstance] showAlertMessage:@"Success" message:responseObject[@"message"] buttonTitle:@"Ok"];
                  }else{
                      // failure response
                      NSLog(@"Failure");
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
        
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(goBack) userInfo:nil repeats:NO];
    }
}

- (void)goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITextField & Keyboard Delegates
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_priceTxtField resignFirstResponder];
}

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
        rect.origin.y -= 120;
        
    }
    else{
        // revert back to the normal state.
        rect.origin.y += 120;
        
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

@end
