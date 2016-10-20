//
//  AppDelegate.h
//  Babysitter
//
//  Created by Torrent on 9/30/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIColor+CustomColors.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>{
    CLLocationManager *curLocManager;
}

@property (strong, nonatomic) UIWindow *window;


// global information
@property (nonatomic, readwrite) BOOL g_bPhone4, bGetLoc;
@property (nonatomic, readwrite) NSInteger userId;

@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) CLLocation *startLocation;
@property (nonatomic, retain) NSMutableDictionary *userInfo;
@property (nonatomic, retain) NSMutableArray *favoriteList;

+ (AppDelegate*)sharedInstance;
- (void)showAlertMessage:(NSString*)title message:(NSString*)content buttonTitle:(NSString*)cancelButtonTitle;
+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius;


@end

