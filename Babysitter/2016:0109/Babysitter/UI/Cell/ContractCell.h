//
//  ContractCell.h
//  Babysitter
//
//  Created by Torrent on 10/5/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *avatarImgView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel, *termLabel, *descLabel;

@end
