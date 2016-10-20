//
//  ProfileViewController.h
//  Babysitter
//
//  Created by Torrent on 11/6/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"

@interface ProfileViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    // update information
    NSString *address, *phoneNum, *email, *city, *state;
    UIImage *profImage;
    NSString *imagePath;
    UITextField *tempField;
}
@property (nonatomic, retain) IBOutlet UIButton *addImageButton;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UITableView *profileInfoView;
@property (nonatomic, retain) IBOutlet UITextView *descTxtView;
@property (nonatomic, retain) IBOutlet EDStarRating *starRatingCtrl;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;


@property (nonatomic, strong) UIActionSheet *cameraActionSheet;
@property (nonatomic, retain) UIImage *imgToUpload;



@end
