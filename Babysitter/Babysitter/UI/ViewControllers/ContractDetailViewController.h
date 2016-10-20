//
//  ContractDetailViewController.h
//  Parent
//
//  Created by Torrent on 11/27/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "EDStarRating.h"

@interface ContractDetailViewController : UIViewController<MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate, EDStarRatingProtocol>{
    NSDateFormatter *dateFormatter;
    MFMailComposeViewController *mailPicker;    
}

@property (nonatomic ,retain) NSDictionary *contractObject;

@property (nonatomic, retain) IBOutlet UIImageView *posterPhotoView;
@property (nonatomic, retain) IBOutlet UILabel *locLabel, *jobPriceLabel, *startTimeLabel, *endTimeLabel, *titleLabel, *scoreLabel;
@property (nonatomic, retain) IBOutlet UITextView *jobDescTxtView;
@property (nonatomic, retain) IBOutlet EDStarRating *starRatingCtrl_small;

//feedback view
@property (nonatomic, retain) IBOutlet UIView *feedbackView;
@property (nonatomic, retain) IBOutlet EDStarRating *starRatingCtrl;
@property (nonatomic, retain) IBOutlet UITextField *scoreTxtField;
@property (nonatomic, retain) IBOutlet UITextView *reviewTxtView;

//invoice view
@property (nonatomic, retain) IBOutlet UIView *invoiceView;
@property (nonatomic, retain) IBOutlet UITextView *invoiceTxtView;

@end
