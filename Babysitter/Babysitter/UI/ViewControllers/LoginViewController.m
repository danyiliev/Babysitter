//
//  ViewController.m
//  Babysitter
//
//  Created by Torrent on 9/30/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SignupViewController.h"

@interface LoginViewController (){
    AFHTTPRequestOperationManager *manager;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    _userTxtField.text = [[AppDelegate sharedInstance].userDefaults objectForKey:@"email"];
    
    _userTxtField.text = @"danyiliev@outlook.com";
    _passTxtField.text = @"m4WFOCBcDh";
    
    _loginButton.imageView.image = [UIImage imageNamed:@"LoginButton.png"];
    manager = [AFHTTPRequestOperationManager manager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self setupNavBar];
    [self setupUI];
}

#pragma mark - UI methods
- (void)setupUI{
    self.textOverlayView.layer.borderWidth = 0.7;
    self.textOverlayView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.textOverlayView.layer.cornerRadius = 10;
    self.textOverlayView.layer.masksToBounds = YES;
}

- (void)setupNavBar{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Login"]) {
        [SVProgressHUD dismiss];
    }
}

#pragma mark - RESTful web service methods
- (void)login{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", BASIC_URL, LOGIN];
    NSDictionary *loginParam = @{@"username": _userTxtField.text,
                                 @"password": _passTxtField.text,
                                 @"grant_type" : @"password",
                                 @"client_id": CLIENT_ID,
                                 @"client_secret": CLIENT_SECRET};
    NSLog(@"param = %@", loginParam);
    
    [manager POST:urlString
       parameters:@{@"username": _userTxtField.text,
                    @"password": _passTxtField.text,
                    @"grant_type" : @"password",
                    @"client_id": CLIENT_ID,
                    @"client_secret": CLIENT_SECRET}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              [SVProgressHUD dismiss];
              
              if (responseObject) {
                  // success in web service call return
                  NSString *token = responseObject[@"access_token"];

                  [[AppDelegate sharedInstance].userDefaults setObject:responseObject[@"access_token"] forKey:@"token"];
                  [[AppDelegate sharedInstance].userDefaults setObject:_passTxtField.text forKey:@"pass"];
                  [[AppDelegate sharedInstance].userDefaults setObject:_userTxtField.text forKey:@"email"];
                  [[AppDelegate sharedInstance].userDefaults synchronize];

                  [NSThread detachNewThreadSelector:@selector(getUserId:) toTarget:self withObject:token];
              }else{
                  // failure response
                  [[AppDelegate sharedInstance] showAlertMessage:@"Error" message:@"Login is failed" buttonTitle:@"Ok"];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [SVProgressHUD dismiss];
              
              [[AppDelegate sharedInstance] showAlertMessage:@"Error" message:@"Login is failed" buttonTitle:@"Ok"];
          }
     ];
}

- (void)forgotPassword{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", BASIC_URL, FORGOTPASS];

    [manager POST:urlString
       parameters:@{@"client_id": CLIENT_ID,
                    @"client_secret": CLIENT_SECRET,
                    @"email": _emailTxtField.text}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              
              if ([responseObject[@"message"] isEqualToString:@"success"]) {
                  // success in web service call return
                  [[AppDelegate sharedInstance] showAlertMessage:@"Success" message:@"Your password is reset." buttonTitle:@"Ok"];
              }else{
                  // failure response
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }
     ];
}

- (void)getUserId:(NSString*)token{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", BASIC_URL, GET_USERID];
    [SVProgressHUD show];

    [manager GET:urlString
      parameters:@{@"access_token": token}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             [SVProgressHUD dismiss];

             if ([responseObject[@"result"] intValue] == 1) {
                 NSInteger babysitterId = [responseObject[@"data"] integerValue];
                 [AppDelegate sharedInstance].userId = babysitterId;
                 [self performSegueWithIdentifier:@"Login" sender:self];
             }

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [SVProgressHUD dismiss];

             NSLog(@"Error: %@", error);
             
         }
     ];
}

#pragma mark - IBAction methods
- (IBAction)Login:(id)sender{
    NSString *password = [[AppDelegate sharedInstance].userDefaults objectForKey:@"pass"];
    NSString *oldUsername = [[AppDelegate sharedInstance].userDefaults objectForKey:@"email"];
    NSString *newUsername = _userTxtField.text;
    
    if (self.loginView.hidden == YES){
        [self.loginView setHidden:NO];
    }else{
        NSString *token = [[AppDelegate sharedInstance].userDefaults objectForKey:@"token"];
        
        if (token){
            if (![newUsername isEqualToString:oldUsername]){
                [self login];
            }
            else
                if ([self.passTxtField.text isEqualToString:password])
                    [self getUserId:token];
                else
                    [[AppDelegate sharedInstance] showAlertMessage:@"Error" message:@"Login is failed" buttonTitle:@"Ok"];
        }else{
            [self login];
        }
    }
}

- (IBAction)ForgotPassword:(id)sender{
    [self.forgotView setHidden:NO];
}

- (IBAction)ResetPass:(id)sender{
    [self.forgotView setHidden:YES];
    [self forgotPassword];
}

- (IBAction)Signup:(id)sender{
    SignupViewController *signupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"signupVC"];
    [self.navigationController pushViewController:signupVC animated:YES];
}

#pragma mark - UITextField & Keyboard Delegates
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.forgotView setHidden:YES];

    [_userTxtField resignFirstResponder];
    [_passTxtField resignFirstResponder];
    [self keyboardWillHide];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self keyboardWillShow];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self keyboardWillHide];
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [self keyboardWillHide];
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
        rect.origin.y -= 20;
    }
    else{
        // revert back to the normal state.
        rect.origin.y += 20;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

@end
