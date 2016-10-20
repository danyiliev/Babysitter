//
//  SignupViewController2.m
//  Babysitter
//
//  Created by Torrent on 12/19/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import "SignupViewController2.h"
#import "AppDelegate.h"

@interface SignupViewController2 ()

@end

@implementation SignupViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.descTxtView.textColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self setupUI];
    [self setupNavBar];
}

#pragma mark - UI methods
- (void)goBackToRoot{
    [SVProgressHUD dismiss];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setupUI{
    // Make add image button as circle shape
    self.containerView.layer.borderWidth = 0.7;
    self.containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.containerView.layer.cornerRadius = 10;
    self.containerView.layer.masksToBounds = YES;
}

- (void)setupNavBar {
    // Navbar color
    self.navigationController.navigationBar.tintColor = [UIColor offWhite];
    [self.navigationController setNavigationBarHidden:NO];
    
    // Adjust nav bar title based on current view identifier
    self.navigationController.navigationBar.topItem.title = SIGNUP_TITLE;
    // Set title
    self.title = SIGNUP_TITLE;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(CreateProfile:)];
    [rightItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationController.navigationBar.alpha = 1;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorPrimary];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)CreateProfile:(id)sender{
    [self signUp];
}

#pragma mark - RESTful web service methods
- (void)signUp{
    [SVProgressHUD show];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", BASIC_URL, SIGNUP];
    
    // get latitude and longitude string
    NSString *lonString = [NSString stringWithFormat:@"%f", [AppDelegate sharedInstance].startLocation.coordinate.longitude];
    NSString *latString = [NSString stringWithFormat:@"%f", [AppDelegate sharedInstance].startLocation.coordinate.latitude];
    // save image to local path
    if (_imagePath && _email && _pass
        && _firstnameTxtField.text && _lastnameTxtField.text && _phoneTxtField.text&& _addressTxtField.text){
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSURL *filePath = [NSURL fileURLWithPath:_imagePath];

        NSDictionary *param = @{
                                @"username":_email,
                                @"firstname":_firstnameTxtField.text,
                                @"lastname":_lastnameTxtField.text,
                                @"email": _email,
                                @"address": _addressTxtField.text,
                                @"credit_card": @"123",
                                @"latitude" : latString,
                                @"longitude" : lonString,
                                @"phone": _phoneTxtField.text,
                                @"user_status": @"Yes",
                                @"description": _descTxtView.text,
                                @"password": _pass,
                                @"image_url": filePath,
                                @"city": _cityTxtField.text,
                                @"state": _stateTxtField.text,
                                @"qbid"
                                @"dob": @"2010/10/10"};

        [manager POST:urlString
           parameters:param
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileURL:filePath name:@"image_url" error:nil];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                [SVProgressHUD dismiss];

                if ([responseObject[@"result"] intValue] == 1) {
                    // success in web service call return
                    [[AppDelegate sharedInstance] showAlertMessage:@"" message:@"Successfully signed up" buttonTitle:@"Ok"];
                }else{
                    // failure response
                    NSString *key = [[responseObject[@"message"] allKeys] firstObject];
                    [[AppDelegate sharedInstance] showAlertMessage:@"Error" message:[[responseObject[@"message"] objectForKey:key] firstObject] buttonTitle:@"Ok"];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [SVProgressHUD dismiss];
                
            }
         ];
        
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(goBackToRoot) userInfo:nil repeats:NO];
    }else{
        [[AppDelegate sharedInstance] showAlertMessage:@"Warning" message:@"No image!" buttonTitle:@"Ok"];
    }
}

#pragma mark - UITextField & Keyboard Delegates
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_usernameTxtField resignFirstResponder];
    [_firstnameTxtField resignFirstResponder];
    [_lastnameTxtField resignFirstResponder];
    [_creditTxtField resignFirstResponder];
    [_phoneTxtField resignFirstResponder];
    [_addressTxtField resignFirstResponder];

//    [self keyboardWillHide];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    [self keyboardWillShow];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    // capitalize the first letter
    if (textField == _firstnameTxtField || textField == _lastnameTxtField){
        NSString *str = textField.text;
        NSMutableString *result = [str mutableCopy];
        [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                                   options:NSStringEnumerationByWords
                                usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                    [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                          withString:[[substring substringToIndex:1] uppercaseString]];
                                }];
        textField.text = result;
    }
    
//    [self keyboardWillHide];
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
//        [self keyboardWillHide];
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UITextView delegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self keyboardWillShow];

    textView.text = @"";
    textView.textColor = [UIColor blackColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self keyboardWillHide];
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
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
        rect.origin.y -= 200;
        
    }
    else{
        // revert back to the normal state.
        rect.origin.y += 200;
        
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}



@end
