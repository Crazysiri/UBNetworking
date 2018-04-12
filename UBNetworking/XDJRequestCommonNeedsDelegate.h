//
//  XDJRequestCommonNeedsDelegate.h
//  networking
//
//  Created by James on 2017/12/20.
//  Copyright © 2017年 James. All rights reserved.
//

#ifndef XDJRequestCommonNeedsDelegate_h
#define XDJRequestCommonNeedsDelegate_h


@protocol XDJRequestCommonNeedsDelegate <NSObject>
//每次请求 公共带的headers 比如版本，设备类型，网络类型等等
- (NSDictionary *)headers;

//content types
- (NSArray *)contentTypes;

//公共的超时 时间
- (NSTimeInterval)timeout;

/*
 这里放一些公共参数，比如每次都要传的用户数据等等
 */
- (NSDictionary *)commonParameters;
@end

#endif /* XDJRequestCommonNeedsDelegate_h */
