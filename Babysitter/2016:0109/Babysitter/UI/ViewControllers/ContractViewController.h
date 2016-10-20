//
//  ContractViewController.h
//  Babysitter
//
//  Created by Torrent on 11/6/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray *contractList;

@property (nonatomic, retain) IBOutlet UITableView *contractTableView;

@end
