//
//  XDJNetErrorHandler.h
//  networking
//
//  Created by qiuyoubo on 2017/12/20.
//  Copyright © 2017年 qiuyoubo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XDJBaseRequestDataModel;

@interface XDJBaseNetErrorHandler : NSObject
+ (void)resultHandlerWithRequestDataModel:(XDJBaseRequestDataModel *)requestDataModel responseURL:(NSURLResponse *)responseURL responseObject:(id)responseObject error:(NSError *)error errorHandler:(void(^)(BOOL needCallback, NSError *newError))errorHandler;

@end
