//
//  XDJRequestCommonNeeds.m
//  NetWorking
//
//  Created by qiuyoubo on 2017/12/19.
//  Copyright © 2017年 Yasin. All rights reserved.
//

#import "RequestCommonNeeds.h"
#import "RequestDefines.h"


@implementation RequestCommonNeeds
- (NSDictionary *)headers { //每次请求 公共带的headers
    return @{};
}

- (NSArray *)contentTypes {//content types
    return @[@"application/json", @"text/html",@"text/json",@"text/javascript"];
}

- (NSTimeInterval)timeout { //公共的超时 时间
    return 20.0f;
}

- (NSDictionary *)commonParameters {
    /*
     这里放一些公共参数，比如每次都要传的用户数据等等
     */
    return @{};
}





@end
