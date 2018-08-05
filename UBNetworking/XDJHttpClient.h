//
//  XDJBaseRequest.h
//  NetWorking
//
//  Created by James on 2017/12/18.
//  Copyright © 2017年 James. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDJDownloadPlugin.h"

@class XDJBaseRequestDataModel;
@protocol XDJRequestCommonNeedsDelegate,XDJReponseCommonNeedsDelegate;

@interface XDJHttpClient : NSObject

@property (strong, nonatomic) XDJDownloadPlugin *downloadPlugin;

+ (instancetype)sharedInstance;


/**
 *  根据dataModel发起网络请求，并根据dataModel发起回调
 *
 *
 *  @return 网络请求task哈希值
 */
- (NSNumber *)callRequestWithRequestModel:(XDJBaseRequestDataModel *)requestModel needs:(id<XDJRequestCommonNeedsDelegate,XDJReponseCommonNeedsDelegate>)needs beforeResume:(void(^)(NSMutableURLRequest *request))block;

/**
 *  取消网络请求
 */
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList;

@end

