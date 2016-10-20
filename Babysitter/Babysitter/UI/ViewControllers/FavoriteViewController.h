//
//  FavoriteViewController.h
//  Babysitter
//
//  Created by Torrent on 10/5/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    NSMutableArray *filteredListContent;
}

@property (nonatomic, retain) IBOutlet UITableView *favTableView;
@property (nonatomic, retain) IBOutlet UITextField *searchTxtField;

@property (nonatomic, retain) NSMutableArray *favList;

@end