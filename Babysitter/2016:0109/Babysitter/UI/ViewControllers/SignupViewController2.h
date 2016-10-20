//
//  SignupViewController2.h
//  Babysitter
//
//  Created by Torrent on 12/19/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController2 : UIViewController<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, retain) IBOutlet UIView *containerView;
@property (nonatomic, retain) IBOutlet UITextField *usernameTxtField, *firstnameTxtField, *lastnameTxtField, *creditTxtField, *phoneTxtField;
@property (nonatomic, retain) IBOutlet UITextView *descTxtView;

@property (nonatomic, retain) NSString *email, *pass, *address, *imagePath;

- (void)signUp;

@end
