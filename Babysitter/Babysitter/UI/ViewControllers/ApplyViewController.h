//
//  ApplyViewController.h
//  Babysitter
//
//  Created by Torrent on 10/5/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>{
    NSString *pickerKeyword;
    NSDateFormatter *dateFormatter;
}

@property (nonatomic ,retain) NSDictionary *jobObject;

@property (nonatomic, retain) IBOutlet UIView *dateSetView;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *dateCancelItem, *dateApplyItem;

@property (nonatomic, retain) IBOutlet UIButton *startTimeButton, *endTimeButton;
@property (nonatomic, retain) IBOutlet UITextField *priceTxtField;
@property (nonatomic, retain) IBOutlet UITextView *coverLetterTxtView;

@property (nonatomic, retain) NSDate *startTime, *endTime;

- (IBAction)SetStartTime:(id)sender;
- (IBAction)SetEndTime:(id)sender;
- (IBAction)DoneDatePicker:(id)sender;
- (IBAction)CancelDatePicker:(id)sender;

@end
