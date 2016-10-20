//
//  ViewController.h
//  Babysitter
//
//  Created by Torrent on 9/30/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *userTxtField, *passTxtField, *emailTxtField;
@property (nonatomic, retain) IBOutlet UIView *loginView, *textOverlayView, *forgotView;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;


- (IBAction)Login:(id)sender;
- (IBAction)Signup:(id)sender;
- (IBAction)ResetPass:(id)sender;
@end

