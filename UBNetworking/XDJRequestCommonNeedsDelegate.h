//
//  XDJRequestCommonNeedsDelegate.h
//  networking
//
//  Created by qiuyoubo on 2017/12/20.
//  Copyright © 2017年 qiuyoubo. All rights reserved.
//

#ifndef XDJRequestCommonNeedsDelegate_h
#define XDJRequestCommonNeedsDelegate_h


@protocol XDJRequestCommonNeedsDelegate <NSObject>
- (NSDictionary *)headers;
- (NSArray *)contentTypes;
- (NSTimeInterval)timeout;
- (NSDictionary *)commonParameters;
@end

#endif /* XDJRequestCommonNeedsDelegate_h */
