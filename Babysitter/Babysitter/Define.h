//
//  Define.h
//  Babysitter
//
//  Created by Torrent on 10/3/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#ifndef Define_h
#define Define_h

#import <SDWebImage/UIImageView+WebCache.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define kJOB_CELL_HEIGHT 90
#define kOFFSET_KEYBOARD 190
#define kBOARD_WIDTH 1.5

#define JOB_DETAIL_VC @"JobDetailViewController"
#define JOB_APPLY_VC @"ApplyViewController"
#define JOB_FAVORITE_VC @"FavoriteViewController"

#define SIGNUP_TITLE @"Create Account"
#define JOBS_TITLE @"Jobs"
#define FAVROTIE_TITLE @"Favorite"
#define CONTRACT_TITLE @"Contract"
#define PROFILE_TITLE @"Profile"

#define PHOTO_FIELD @"image_url"
#define USERNAME_FIELD @"username"
#define LOCATION_FIELD @"location"
#define JOB_TERM_FIELD @"price"
#define JOB_DESC_FIELD @"description"
#define JOB_TIME_FIELD @"start_time"
#define JOB_DEADLINE_FIELD @"deadline"

#pragma mark - API INFORMATION

#define CLIENT_ID @"f3d259ddd3ed8ff3843839b"
#define CLIENT_SECRET @"4c7f6f8fa93d59c45502c0ae8c4a95b"
#define BASIC_URL2 @"http://88.80.131.133/babysitter/public"
#define BASIC_URL @"http://keydoz.com"

#define SIGNUP @"api/babysitter"
#define LOGIN @"api/babysitterlogin"
#define FORGOTPASS @"api/password/reset"
#define GET_USERID @"api/userid"
#define ADD_FAVORITE @"api/job/favorite"

#define DIS_FAVORITE @"api/job/disfavorite"

#define APPLY @"api/applyJob"
#define END_CONTRACT @"api/feedback/parent"
#define EMAIL_SEND @"api/email"

#define IMAGE_UPLOAD @"http://manifestinfotech.com/webservices/babysitter/uploadPic"


#define BABYSITTER_GETCONTRACTS @"http://manifestinfotech.com/webservices/babysitter/getContracts"
#define BABYSITTER_GETBABYSITTER @"http://manifestinfotech.com/webservices/babysitter/getBabysitterInfo"

#define BABYSITTER_ADDFAVORITE @"http://manifestinfotech.com/webservices/babysitter/addFavoriteJob"
#define BABYSITTER_GETFAVROTIES @"http://manifestinfotech.com/webservices/babysitter/getFavoriteJobs"

#define PARENT_GETPARENT @"http://manifestinfotech.com/webservices/parents/getParentInfo"
#define BABYSITTER_GETJOBINFO @"http://manifestinfotech.com/webservices/babysitter/getJob"
#define BABYSITTER_GETCONTRACTINFO @"http://manifestinfotech.com/webservices/babysitter/getContract"

#endif /* Define_h */
