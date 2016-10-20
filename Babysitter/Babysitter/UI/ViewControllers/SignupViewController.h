//
//  SignupViewController.h
//  Babysitter
//
//  Created by Torrent on 10/13/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *emailTxtField, *passTxtField, *confPassTxtField;
@property (nonatomic, retain) IBOutlet UIButton *addImageButton;
@property (nonatomic, retain) IBOutlet UIView *containerView;

@property (nonatomic, strong) UIActionSheet *cameraActionSheet;
@property (nonatomic, retain) UIImage *imgToUpload;
@property (nonatomic, retain) NSString *filePath;

- (void)setupNavBar;
- (void)goBack;

@end
