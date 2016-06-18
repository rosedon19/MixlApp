//
//  AppController.m


#import "AppController.h"

static AppController *_appController;

@implementation AppController

+ (AppController *)sharedInstance {
    static dispatch_once_t predicate;
    if (_appController == nil) {
        dispatch_once(&predicate, ^{
            _appController = [[AppController alloc] init];
        });
    }
    return _appController;
}

- (id)init {
    self = [super init];
    if (self) {
        
        // Utility Data
        _appMainColor = RGBA(239, 238, 226, 1.0f);
        _appTextColor = RGBA(41, 43, 48, 1.0f);
        _appThirdColor = RGBA(61, 155, 196, 1.0f);
        
        _vAlert = [[DoAlertView alloc] init];
        _vAlert.nAnimationType = 2;  // there are 5 type of animation
        _vAlert.dRound = 7.0;
        _vAlert.bDestructive = NO;  // for destructive mode
        //        _vAlert.iImage = [UIImage imageNamed:@"logo_top"];
        //        _vAlert.nContentMode = DoContentImage;
        
        
        // Intro Images
        _introSliderImages = (NSMutableArray *) @[
                                                  @"intro1",
                                                  @"intro2",
                                                  @"intro3"
                                                  ];
        
        // Side Menu Bar Pages
        _menuPages = [[NSMutableArray alloc] init];
        _menuPages = [@[
                        [@{@"tag" : @"1", @"title" : @"Profile", @"icon" : @"icon_userprofile"} mutableCopy],
                        [@{@"tag" : @"2", @"title" : @"Chat", @"icon" : @"icon_chat"} mutableCopy],
                        [@{@"tag" : @"3", @"title" : @"People Nearby", @"icon" : @"icon_peoplenearby"} mutableCopy],
                        [@{@"tag" : @"4", @"title" : @"Friends Nearby", @"icon" : @"icon_groupnearby"} mutableCopy],
                        [@{@"tag" : @"5", @"title" : @"Offers", @"icon" : @"icon_offer"} mutableCopy],
                        [@{@"tag" : @"6", @"title" : @"Friend Requests", @"icon" : @"icon_peoplenearby"} mutableCopy],
                        [@{@"tag" : @"7", @"title" : @"Settings", @"icon" : @"icon_setting"} mutableCopy],
                        [@{@"tag" : @"8", @"title" : @"Log out", @"icon" : @"icon_logout"} mutableCopy]
                        ] mutableCopy];
        
        _venuemenuPages = [[NSMutableArray alloc] init];
        _venuemenuPages = [@[
                        [@{@"tag" : @"1", @"title" : @"Profile", @"icon" : @"icon_barprofile"} mutableCopy],
                        [@{@"tag" : @"2", @"title" : @"Offers", @"icon" : @"icon_offer"} mutableCopy],
                        [@{@"tag" : @"3", @"title" : @"People Nearby", @"icon" : @"icon_peoplenearby"} mutableCopy],
                        [@{@"tag" : @"4", @"title" : @"Vouchers Claimed", @"icon" : @"icon_menuclaimed"} mutableCopy],
                        [@{@"tag" : @"5", @"title" : @"Vouchers Pending", @"icon" : @"icon_pendding"} mutableCopy],
                        [@{@"tag" : @"6", @"title" : @"Settings", @"icon" : @"icon_setting"} mutableCopy],
                        [@{@"tag" : @"7", @"title" : @"Log out", @"icon" : @"icon_logout"} mutableCopy]
                        ] mutableCopy];

        
        // Peoples Nearby
        _peoplesNearby = [[NSMutableArray alloc] init];
//        _peoplesNearby = [@[
//                        [@{@"fname" : @"Ravon", @"lname" : @"T.", @"age" : @"28", @"gender" : @"m", @"distance" : @"1", @"image1" : @"user", @"image2" : @"inviteduser", @"description" : @"1skdjfhsdkjfsldksdlfkj"} mutableCopy],
//                        [@{@"fname" : @"John", @"lname" : @"A.", @"age" : @"22", @"gender" : @"f", @"distance" : @"2", @"image1" : @"inviteduser", @"image2" : @"user", @"description" : @"2skdjfhsdkjfsldksdlfkj"} mutableCopy],
//                        [@{@"fname" : @"Roman", @"lname" : @"S.", @"age" : @"21", @"gender" : @"m", @"distance" : @"3", @"image1" : @"user", @"image2" : @"inviteduser", @"description" : @"3skdjfhsdkjfsldksdlfkj"} mutableCopy],
//                        [@{@"fname" : @"Joe", @"lname" : @"T.", @"age" : @"24", @"gender" : @"f", @"distance" : @"4", @"image1" : @"inviteduser", @"image2" : @"user", @"description" : @"4skdjfhsdkjfsldksdlfkj"} mutableCopy],
//                        [@{@"fname" : @"Tom", @"lname" : @"T.", @"age" : @"25", @"gender" : @"m", @"distance" : @"5", @"image1" : @"user", @"image2" : @"inviteduser", @"description" : @"5skdjfhsdkjfsldksdlfkj"} mutableCopy],
//                        [@{@"fname" : @"Alli", @"lname" : @"T.", @"age" : @"27", @"gender" : @"f", @"distance" : @"6", @"image1" : @"inviteduser", @"image2" : @"user", @"description" : @"6skdjfhsdkjfsldksdlfkj"} mutableCopy],
//                        [@{@"fname" : @"August", @"lname" : @"T.", @"age" : @"28", @"gender" : @"m", @"distance" : @"7", @"image1" : @"user", @"image2" : @"inviteduser", @"description" : @"7skdjfhsdkjfsldksdlfkj"} mutableCopy],
//                        [@{@"fname" : @"Douglas", @"lname" : @"T.", @"age" : @"29", @"gender" : @"f", @"distance" : @"8", @"image1" : @"inviteduser", @"image2" : @"user", @"description" : @"8skdjfhsdkjfsldksdlfkj"} mutableCopy]
//                        ] mutableCopy];
        
        // Friends Nearby
        _Friends = [[NSMutableArray alloc] init];
//        _Friends = [@[
//                            [@{@"fname" : @"Ravon", @"lname" : @"T.", @"distance" : @"1", @"status" : @"online", @"image" : @"inviteduser"} mutableCopy],
//                            [@{@"fname" : @"John", @"lname" : @"A.", @"distance" : @"2", @"status" : @"offline", @"image" : @"user"} mutableCopy],
//                            [@{@"fname" : @"Roman", @"lname" : @"S.", @"distance" : @"3", @"status" : @"offline", @"image" : @"inviteduser"} mutableCopy],
//                            [@{@"fname" : @"Joe", @"lname" : @"T.", @"distance" : @"4", @"status" : @"online", @"image" : @"user"} mutableCopy],
//                            [@{@"fname" : @"Tom", @"lname" : @"T.", @"distance" : @"5", @"status" : @"online", @"image" : @"inviteduser"} mutableCopy],
//                            [@{@"fname" : @"Alli", @"lname" : @"T.", @"distance" : @"6", @"status" : @"online", @"image" : @"user"} mutableCopy],
//                            [@{@"fname" : @"August", @"lname" : @"T.", @"distance" : @"7", @"status" : @"offline", @"image" : @"inviteduser"} mutableCopy],
//                            [@{@"fname" : @"Douglas", @"lname" : @"T.", @"distance" : @"8", @"status" : @"offline", @"image" : @"user"} mutableCopy]
//                            ] mutableCopy];
        
        _offersList = [[NSMutableArray alloc] init];
        
        _claimedUsers = [[NSMutableArray alloc] init];
        _claimedUsers = [@[
                           [@{@"fname" : @"Ravon", @"lname" : @"T", @"age" : @"24", @"image" : @"user", @"offername" : @"First drink Free"} mutableCopy],
                         [@{@"fname" : @"Ravon", @"lname" : @"T", @"age" : @"25", @"image" : @"inviteduser", @"offername" : @"First drink Free"} mutableCopy],
                         [@{@"fname" : @"Ravon", @"lname" : @"T", @"age" : @"26", @"image" : @"user", @"offername" : @"First"} mutableCopy]
                         ] mutableCopy];
        
        _notclaimedUsers = [[NSMutableArray alloc] init];
        _notclaimedUsers = [@[
                              [@{@"fname" : @"Ravon", @"lname" : @"T", @"age" : @"24", @"image" : @"user", @"offername" : @"First drink Free", @"time" : @"05:05"} mutableCopy],
                              [@{@"fname" : @"Ravon", @"lname" : @"T", @"age" : @"25", @"image" : @"inviteduser", @"offername" : @"First drink Free", @"time" : @"05:06"} mutableCopy],
                              [@{@"fname" : @"Ravon", @"lname" : @"T", @"age" : @"26", @"image" : @"user", @"offername" : @"First", @"time" : @"05:07"} mutableCopy]
                              ] mutableCopy];
        
        _avatars = [[NSMutableArray alloc] init];
        _avatars = [@[
                      [@{@"tag" : @"01", @"color" : RGBA(255, 114, 113, 1.0f)} mutableCopy],
                      [@{@"tag" : @"02", @"color" : RGBA(255, 191, 55, 1.0f)} mutableCopy],
                      [@{@"tag" : @"03", @"color" : RGBA(253, 242, 92, 1.0f)} mutableCopy],
                      [@{@"tag" : @"04", @"color" : RGBA(186, 248, 53, 1.0f)} mutableCopy],
                      [@{@"tag" : @"05", @"color" : RGBA(72, 222, 89, 1.0f)} mutableCopy],
                      [@{@"tag" : @"06", @"color" : RGBA(5, 230, 174, 1.0f)} mutableCopy],
                      [@{@"tag" : @"07", @"color" : RGBA(50, 252, 238, 1.0f)} mutableCopy],
                      [@{@"tag" : @"08", @"color" : RGBA(162, 222, 255, 1.0f)} mutableCopy],
                      [@{@"tag" : @"09", @"color" : RGBA(98, 190, 255, 1.0f)} mutableCopy],
                      [@{@"tag" : @"10", @"color" : RGBA(190, 184, 255, 1.0f)} mutableCopy],
                      [@{@"tag" : @"11", @"color" : RGBA(255, 150, 198, 1.0f)} mutableCopy],
                      [@{@"tag" : @"12", @"color" : RGBA(198, 213, 220, 1.0f)} mutableCopy]
                      ] mutableCopy];

        // Nav Temporary Data
        _currentNavBark = [[NSMutableDictionary alloc] init];
        _currentNavBarkStat = [[NSMutableDictionary alloc] init];
        _postBarkImage = nil;
        _editProfileImage = nil;
        _currentMenuTag = @"1";
        _avatarUrlTemp = @"";
        _facebookPhotoUrlTemp = @"";
        _statsVelocityHistoryPeriod = @"30";
        
        _isFromSignUpSecondPage = NO;
        _isNewBarkUploaded = NO;
        _isMyProfileChanged = NO;
        
        // Data
        _currentUser = [[NSMutableDictionary alloc] init];
        _receiverUser = [[NSMutableDictionary alloc] init];
        _favoriteUsers = [[NSMutableArray alloc] init];
    }
    return self;
}


+ (NSDictionary*) requestApi:(NSMutableDictionary *)params withFormat:(NSString *)url {
    return [AppController jsonHttpRequest:url jsonParam:params];
}

+ (id) jsonHttpRequest:(NSString*) urlStr jsonParam:(NSMutableDictionary *)params {
    NSString *paramStr = [commonUtils getParamStr:params];
    //NSLog(@"\n\nparameter string : \n\n%@", paramStr);
    NSData *requestData = [paramStr dataUsingEncoding:NSUTF8StringEncoding];

    NSData *data = nil;
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSHTTPURLResponse *response = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestData];
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
//    NSLog(@"\n\nresponse string : \n\n%@", responseString);
    return [[SBJsonParser new] objectWithString:responseString];
}

@end
