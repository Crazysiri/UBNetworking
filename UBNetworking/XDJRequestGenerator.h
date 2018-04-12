//
//  XDJRequestGenerator.h
//  NetWorking
//
//  Created by qiuyoubo on 2017/12/18.
//  Copyright © 2017年 Yasin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDJRequestCommonNeedsDelegate.h"

@class XDJBaseRequestDataModel;
@interface XDJRequestGenerator : NSObject
@property (strong, nonatomic) id<XDJRequestCommonNeedsDelegate> needs;
+ (id)shared;

- (NSMutableURLRequest *)requestWithDataModel:(XDJBaseRequestDataModel *)model;
@end
