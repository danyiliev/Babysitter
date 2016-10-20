//
//  JobFeedCell.h
//  Babysitter
//
//  Created by Torrent on 10/3/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"

@interface JobFeedCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *avatarImgView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel, *locLabel, *termLabel, *descLabel, *appliedBadge, *scoreLabel;
@property (nonatomic, retain) IBOutlet EDStarRating *starRatingCtrl;

@end
