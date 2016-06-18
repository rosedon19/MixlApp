//
//  Config.m

#define SERVER_URL @"http://ec2-52-50-37-37.eu-west-1.compute.amazonaws.com"
#define API_KEY @" "

#define API_URL (SERVER_URL @"/api")
#define API_URL_USER_SIGNUP (SERVER_URL @"/api/register")
#define API_URL_USER_FBLOGIN (SERVER_URL @"/api/fblogin")
#define API_URL_USER_LOGIN (SERVER_URL @"/api/login")

#define API_URL_SETTINGS            (SERVER_URL @"/api/preference")
#define API_URL_SETTINGS_DELETE     (SERVER_URL @"/api/deleteaccount")
#define API_URL_PROFILE_UPDATE      (SERVER_URL @"/api/user")
#define API_URL_LOCATION_UPDATE     (SERVER_URL @"/api/location")
#define API_URL_NEARBY              (SERVER_URL @"/api/nearby")
#define API_URL_FRIEND              (SERVER_URL @"/api/friend")
#define API_URL_SEARCH              (SERVER_URL @"/api/search")
#define API_URL_USER                (SERVER_URL @"/api/user")
#define API_URL_USER_INVITE         (SERVER_URL @"/api/invite")
#define API_URL_USER_ACCEPT_INVITE  (SERVER_URL @"/api/acceptinvite")
#define API_URL_CITY                (SERVER_URL @"/api/cities")
#define API_URL_STATES              (SERVER_URL @"/api/states")
#define API_URL_GALLERY             (SERVER_URL @"/api/gallery-images")
#define API_URL_OFFER               (SERVER_URL @"/api/offer")
#define API_URL_RECEIVEINVITE       (SERVER_URL @"/api/receiveinvite")
#define API_URL_CLAIM               (SERVER_URL @"/api/claimoffer")
#define API_URL_SEND_MESSAGE        (SERVER_URL @"/api/messages")
#define API_URL_CHAT_HISTORY        (SERVER_URL @"/api/chat-history")
#define API_URL_UPLOAD_PHOTO        (SERVER_URL @"/api/upload-photo")

#define API_URL_LOCATION_SETTINGS (SERVER_URL @"/api/location_settings")
#define API_URL_USER_SETTINGS_LOCATION_ID (SERVER_URL @"/api/user_settings_location_id")

// MEDIA CONFIG
#define MEDIA_INTRO_URL (SERVER_URL @"/assets/intro/")
#define MEDIA_INTRO_URL_GET_STARTED @"#getStarted"

#define MEDIA_USER_SELF_DOMAIN_PREFIX @"wf_media_user_"
#define MEDIA_AVATAR_SELF_DOMAIN_PREFIX @"wf_avatar_"
#define MEDIA_BARK_PHOTO_SELF_DOMAIN_PREFIX @"wf_media_bark_photo_"
#define MEDIA_BARK_VIDEO_SELF_DOMAIN_PREFIX @"wf_media_bark_video_"
#define MEDIA_BARK_VIDEO_THUMB_SELF_DOMAIN_PREFIX @"wf_media_bark_video_thumb_"

#define MEDIA_URL (SERVER_URL @"/assets/media/")
#define MEDIA_URL_USERS (SERVER_URL @"/assets/media/users/")
#define MEDIA_URL_BARK_PHOTOS (SERVER_URL @"/assets/media/bark_photos/")
#define MEDIA_URL_BARK_VIDEOS (SERVER_URL @"/assets/media/bark_videos/")
#define MEDIA_URL_BARK_VIDEO_THUMBS (SERVER_URL @"/assets/media/bark_video_thumbs/")

// Settings Config
#define USER_AGE_MIN 18
#define USER_AGE_MAX 80

// Explore Barks Default Config
#define EXPLORE_BARKS_COUNT_DEFAULT @"100"

// Aviary Config
//#define kAviaryKey @"j8q6p8efaolydstk"
//#define kAviarySecret @"kk4fd7pglcnrgbpd"
#define ADOBE_CLIENT_ID @"05cce7d40c12458bb4f13db89903044c"
#define ADOBE_CLIENT_SECRET @"28e16f52-6acd-4e7a-bdbd-86b0f670d8a4"


// Map View Default Config
#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360


// Utility Values
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]
#define M_PI        3.14159265358979323846264338327950288

#define FONT_GOTHAM_NORMAL(s) [UIFont fontWithName:@"GothamRounded-Book" size:s]
#define FONT_GOTHAM_BOLD(s) [UIFont fontWithName:@"GothamRounded-Bold" size:s]


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_6_OR_ABOVE (IS_IPHONE && SCREEN_MAX_LENGTH >= 667.0)

/////////////////////////////////////////////////////////////////////////////////////////////////

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define APP_DidReceivePush @"APP_DidReceivePush"
#define APP_FriendRequestPush @"APP_FriendRequestPush"
#define APP_UserInviteAcceptPush @"APP_FriendRequestPush"
#define APP_UserInviteResultPush @"APP_UserInviteResultPush"
#define APP_DidReceiveMessagePush @"APP_DidReceiveMessage"

#define APP_ReloadIssueMessage @"APP_ReloadIssueMessage"

// NSUserDefaults Keys
#define kUDAppLastStartTime         @"appLastStartTime"
#define kUDUserID                   @"userid"
#define kUDFacebookID               @"facebookId"
#define kUDEmail                    @"email"
#define kUDPhone                    @"phone"
#define kUDFirstName                @"fname"
#define kUDLastName                 @"lname"
#define kUDProfileImage             @"profile_image"
#define kUDAuthToken                @"auth_token"
#define kUDPushDeviceToken          @"pushDeviceToken"
#define kUDPaymentMethod            @"paymentMethod"

// NSNotification Names
#define     kPNPublishMessageNotification           @"PNPublishMessageNotification"
#define     kPNDidReceiveMessageNotification        @"PNDidReceiveMessageNotification"

// NSNotification UserInfo Keys
#define     kNUChatMessage                          @"chatMessage"
#define     kNUTimeToken                            @"timeToken"
#define     kNUSender                               @"sender"

// PN Message Keys
#define     kPMMessage                              @"message"
#define     kPMSender                               @"sender"


#define     CROPIMAGE_SIZE_WIDTH                    300
#define     CROPIMAGE_SIZE_HEIGHT                   300

typedef enum{
    SIDEBAR_PROFILE_ITEM = 0,
    SIDEBAR_CHAT_ITEM,
    SIDEBAR_PEOPLENEARBY_ITEM,
    SIDEBAR_FRIENDSNEARBY_ITEM,
    SIDEBAR_OFFERS_ITEM,
    SIDEBAR_FRIENDREQUESTS_ITEM,
    SIDEBAR_SETTINGS_ITEM,
    SIDEBAR_LOGOUT_ITEM
}SIDEBAR_ITEMS;

typedef enum{
    PUSH_FRIENDREQUEST = 1,
    PUSH_USERINVITE,
    PUSH_USERINVITEACCEPT,
    PUSH_CHATMESSAGE,
    PUSH_OFFER,
    PUSH_ACCEPTOFFER
}PUSH_ITEMS;

#define     SIDEBAR_WIDTH_RATE                      0.6f

//webservice post param keywords
#define     USERINFO_HASH_KEY                       @"hashed_shared_key"
#define     USERINFO_FIRSTNAME_KEY                  @"first_name"
#define     USERINFO_LASTNAME_KEY                   @"last_name"
#define     USERINFO_EMAIL_KEY                      @"email"
#define     USERINFO_PASSWORD_KEY                   @"password"
#define     USERINFO_ZIPCODE_KEY                    @"zip_code"
#define     USERINFO_DEVICETOKEN_KEY                @"device_token"
#define     USERINFO_DEVICEMODEL_KEY                @"device_model"
#define     USERINFO_DEVICEUID_KEY                  @"device_uid"
#define     USERINFO_USERNAME_KEY                   @"username"
#define     USERINFO_AVATAR_KEY                     @"avatar"
#define     USERINFO_HASHEDPASSWORK_KEY             @"hashed_password"
#define     USERINFO_USER_KEY                       @"user"
#define     USERINFO_SUBSCRIBER_KEY                 @"subscriber"

//Garage Types
#define     GARAGE_TYPES    @[@"Driveway",@"Private",@"Parking Lot",@"Public"]

//Neigborhood
#define     NEIGBORHOODS    @[@"Pacific Heights",@"Mission District",@"Nob Hill",@"Russion Hill",@"SOMA",@"Financial District",@"Castro",@"USF",@"Haight Ashbury",@"Lower Haight",@"Noe Valley",@"North Beach"]

