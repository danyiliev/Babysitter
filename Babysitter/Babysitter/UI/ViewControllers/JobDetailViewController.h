//
//  JobDetailViewController.h
//  Babysitter
//
//  Created by Torrent on 10/4/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"

@interface JobDetailViewController : UIViewController

@property (nonatomic, readwrite) BOOL bFavorite;
@property (nonatomic ,retain) NSDictionary *jobObject;

@property (nonatomic, retain) IBOutlet UIImageView *posterPhotoView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel, *locLabel, *jobPriceLabel, *startTimeLabel, *endTimeLabel, *scoreLabel;
@property (nonatomic, retain) IBOutlet UITextView *jobDescTxtView;
@property (nonatomic, retain) IBOutlet EDStarRating *starRatingCtrl;

- (IBAction)Like:(id)sender;
- (IBAction)Apply:(id)sender;

@end
