//
//  XDJRequestGenerator.h
//  NetWorking
//
//  Created by James on 2017/12/18.
//  Copyright © 2017年 James. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDJRequestCommonNeedsDelegate.h"

@class XDJBaseRequestDataModel;
@interface XDJRequestGenerator : NSObject
@property (strong, nonatomic) id<XDJRequestCommonNeedsDelegate> needs;
+ (id)shared;

- (NSMutableURLRequest *)requestWithDataModel:(XDJBaseRequestDataModel *)model;
@end
