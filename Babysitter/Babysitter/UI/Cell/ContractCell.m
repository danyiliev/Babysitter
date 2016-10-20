
//  ContractCell.m
//  Babysitter
//
//  Created by Torrent on 10/5/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import "ContractCell.h"
#import "Define.h"

@implementation ContractCell

- (void)awakeFromNib {
    // Initialization code
    
    //thumbnail-photo imageview manipulation
    CALayer *roundRect = [self.avatarImgView layer];
    [roundRect setCornerRadius:self.avatarImgView.frame.size.width / 2];
    [roundRect setMasksToBounds:YES];
    
    CGRect borderFrame = CGRectMake(self.avatarImgView.frame.origin.x, self.avatarImgView.frame.origin.y, (self.avatarImgView.frame.size.width), (self.avatarImgView.frame.size.height));
    [roundRect setBackgroundColor:[[UIColor clearColor] CGColor]];
    [roundRect setFrame:borderFrame];
    [roundRect setBorderWidth:kBOARD_WIDTH];
    [roundRect setBorderColor:[[UIColor blueColor] CGColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
