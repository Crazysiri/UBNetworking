//
//  UBMonitorNetworking.m
//  LenzBusiness
//
//  Created by 武得亮 on 2018/12/18.
//  Copyright © 2018 LenzTech. All rights reserved.
//

#import "UBMonitorNetworking.h"

#import "AFNetworking.h"

@implementation UBMonitorNetworking

#pragma mark - ------------- 监测网络状态 -------------
+ (NSString *)monitorNetworking
{
    
    __block NSString *lenzNetworking = @"";
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可达");
                break;
            case 1:
            {
                NSLog(@"GPRS网络");
                //发通知，带头搞事
            }
                break;
            case 2:
            {
                NSLog(@"wifi网络");
            }
                break;
            default:
                break;
        }
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"有网");
        }else{
            NSLog(@"没网");
            lenzNetworking = @"NoNetworking";
        }
    }];
    
    return lenzNetworking;
}

@end
