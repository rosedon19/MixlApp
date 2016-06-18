//
//  Connect.h
//  InstantPros
//
//  Created by Kuznetsov Andrey on 31/07/15.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"

typedef void (^SuccessBlock)(id json);
typedef void (^FailureBlock)(NSInteger statusCode, id json);

@interface ServerConnect : AFHTTPSessionManager

+ (ServerConnect *)sharedManager;

- (void)GET:(NSString *)url
 withParams:(NSDictionary*)params
  onSuccess:(SuccessBlock)completionBlock
  onFailure:(FailureBlock)failureBlock;

- (void)POST:(NSString *)url
  withParams:(NSDictionary*)params
   onSuccess:(SuccessBlock)completionBlock
   onFailure:(FailureBlock)failureBlock;

- (void)UploadFiles:(NSString *)url
            withData:(NSArray *)datas
          withParams:(NSDictionary *)params
           onSuccess:(SuccessBlock)completionBlock
           onFailure:(FailureBlock)failureBlock;

@end
