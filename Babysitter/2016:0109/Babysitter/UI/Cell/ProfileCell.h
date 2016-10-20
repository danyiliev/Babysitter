//
//  ProfileCell.h
//  Babysitter
//
//  Created by Torrent on 12/25/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *infoLabel;
@property (nonatomic, retain) IBOutlet UITextField *phoneTxtField, *addressTxtField;

@end
