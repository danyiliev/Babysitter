//
//  JobsViewController.h
//  Babysitter
//
//  Created by Torrent on 10/3/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    NSMutableArray *filteredListContent;
}

@property (nonatomic, retain) NSArray *jobList;

@property (nonatomic, retain) IBOutlet UITableView *jobsTableView;
@property (nonatomic, retain) IBOutlet UITextField *searchTxtField;

- (void)setupNavBar;
- (void)setInitUI;
- (void)filter;

@end
