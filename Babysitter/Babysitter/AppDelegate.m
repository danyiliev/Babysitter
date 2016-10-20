//
//  AppDelegate.m
//  Babysitter
//
//  Created by Torrent on 9/30/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation UIDevice( SystemVersion )

-( BOOL )isSystemVersionLowerThan:( NSString * )versionToCompareWith
{
    if( versionToCompareWith.length == 0 )
        return NO;
    
    NSString *deviceSystemVersion = [self systemVersion];
    NSArray *systemVersionComponents = [deviceSystemVersion componentsSeparatedByString: @"."];
    
    uint16_t deviceMajor = 0;
    uint16_t deviceMinor = 0;
    uint16_t deviceBugfix = 0;
    
    NSUInteger nDeviceComponents = systemVersionComponents.count;
    if( nDeviceComponents > 0 )
        deviceMajor = [( NSString * )systemVersionComponents[0] intValue];
    if( nDeviceComponents > 1 )
        deviceMinor = [( NSString * )systemVersionComponents[1] intValue];
    if( nDeviceComponents > 2 )
        deviceBugfix = [( NSString * )systemVersionComponents[2] intValue];
    
    NSArray *versionToCompareWithComponents = [versionToCompareWith componentsSeparatedByString: @"."];
    
    uint16_t versionToCompareWithMajor = 0;
    uint16_t versionToCompareWithMinor = 0;
    uint16_t versionToCompareWithBugfix = 0;
    
    NSUInteger nVersionToCompareWithComponents = versionToCompareWithComponents.count;
    if( nVersionToCompareWithComponents > 0 )
        versionToCompareWithMajor = [( NSString * )versionToCompareWithComponents[0] intValue];
    if( nVersionToCompareWithComponents > 1 )
        versionToCompareWithMinor = [( NSString * )versionToCompareWithComponents[1] intValue];
    if( nVersionToCompareWithComponents > 2 )
        versionToCompareWithBugfix = [( NSString * )versionToCompareWithComponents[2] intValue];
    
    return ( deviceMajor < versionToCompareWithMajor )
    || (( deviceMajor == versionToCompareWithMajor ) && ( deviceMinor < versionToCompareWithMinor ))
    || (( deviceMajor == versionToCompareWithMajor ) && ( deviceMinor == versionToCompareWithMinor ) && ( deviceBugfix < versionToCompareWithBugfix ));
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
////////////////////////////////////////////////////////////////////////////////////////////////////
//    // Set navigation text color & shadow                                                       //
//    NSShadow * shadow = [[NSShadow alloc] init];                                                //
//    shadow.shadowColor = [UIColor clearColor];                                                  //
//    shadow.shadowOffset = CGSizeMake(0, -2);                                                    //
//                                                                                                //
//    NSDictionary * navBarTitleTextAttributes =                                                  //
//    @{ NSForegroundColorAttributeName : [UIColor whiteColor],                                   //
//       NSShadowAttributeName          : shadow,                                                 //
//       NSFontAttributeName            : [UIFont systemFontOfSize:14] };                         //
//                                                                                                //
//    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];            //
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor blueColor]];                      //
////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // set the bar background color
    [[UITabBar appearance] setBackgroundImage:[AppDelegate imageFromColor:[UIColor colorPrimary] forSize:CGSizeMake(320, 49) withCornerRadius:0]];

    //selected tint color
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];

    //unselected icon tint color
    [[UIView appearanceWhenContainedIn:[UITabBar class], nil] setTintColor:[UIColor whiteColor]];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];

    // set the selected icon color
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];

    // remove the shadow
    [[UITabBar appearance] setShadowImage:nil];
    
    // Set the dark color to selected tab (the dimmed background)
    [[UITabBar appearance] setSelectionIndicatorImage:[AppDelegate imageFromColor:[UIColor colorPrimary] forSize:CGSizeMake(90, 49) withCornerRadius:0]];

    //Set Tabbar background
    UIImage* tabBarBackground = [UIImage imageNamed:@"menu_bg5.jpg"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];

    // Estimate iphone model size
    if ([[UIScreen mainScreen] bounds].size.height == 480)
        _g_bPhone4 = YES;
    else
        _g_bPhone4 = NO;
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self setLocationManager];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Location Manager Delegate methods
- (void)setLocationManager{
    _bGetLoc = NO;
    
    curLocManager = [[CLLocationManager alloc] init];
    curLocManager.desiredAccuracy = kCLLocationAccuracyBest;
    curLocManager.delegate = self;
    
    // Override point for customization after application launch.
    if (IS_OS_8_OR_LATER){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge

                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [curLocManager requestAlwaysAuthorization];
    }else{
        //register to receive notifications
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    [curLocManager startUpdatingLocation];
    self.startLocation = nil;
}

-(void)resetDistance:(id)sender{
    self.startLocation = nil;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//    NSLog(@"didFailWithError: %@", error);
    _bGetLoc = NO;
    
    [self setLocationManager];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location_updated = [locations lastObject];
//    NSLog(@"%.3f, %.3f",location_updated.coordinate.latitude, location_updated.coordinate.longitude);
    
    float newLat = [[NSString stringWithFormat:@"%.3f", location_updated.coordinate.latitude] floatValue];
    float newLon = [[NSString stringWithFormat:@"%.3f", location_updated.coordinate.longitude] floatValue];
    float oldLat = [[NSString stringWithFormat:@"%.3f", _startLocation.coordinate.latitude] floatValue];
    float oldLon = [[NSString stringWithFormat:@"%.3f", _startLocation.coordinate.longitude] floatValue];
    
    if (newLat != oldLat || newLon != oldLon){
        _bGetLoc = NO;
    }
    
    self.startLocation = location_updated;
    if (!_bGetLoc) {
        NSLog(@"%.3f, %.3f", _startLocation.coordinate.latitude, _startLocation.coordinate.longitude);
        _bGetLoc = YES;
    }
}

#pragma mark - App Engine methods

+ (AppDelegate*)sharedInstance{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
}
    
- (void)showAlertMessage:(NSString*)title message:(NSString*)content buttonTitle:(NSString*)cancelButtonTitle{
    if( [[UIDevice currentDevice] isSystemVersionLowerThan: @"8"] ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                        message: content
                                                       delegate: nil
                                              cancelButtonTitle: cancelButtonTitle
                                              otherButtonTitles: nil];
        [alert show];
    }else{
        // nil titles break alert interface on iOS 8.0, so we'll be using empty strings
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: title == nil ? @"": title
                                                                       message: content
                                                                preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle: cancelButtonTitle
                                                                style: UIAlertActionStyleDefault
                                                              handler: nil];
        [alert addAction: defaultAction];
        
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController: alert animated: YES completion: nil];
    }
}

@end
