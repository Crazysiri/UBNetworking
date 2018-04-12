//
//  XDJRequestDefines.h
//  NetWorking
//
//  Created by qiuyoubo on 2017/12/19.
//  Copyright © 2017年 Yasin. All rights reserved.
//

#import <UIKit/UIKit.h>


#ifndef XDJRequestDefines_h
#define XDJRequestDefines_h

#define app_version  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


typedef enum {
    HttpCodeSuccess = 200,
    HttpCodeSuccess201 = 201,
    HttpCodeSuccess202 = 202,
    HttpCodeLoginDated = 401,
    HttpCodeError400   = 400, //
    HTTPCodeTimeAuthenticateError = 403,//时间校验错误
    HttpCodeFailed     = 201, //业务失败
    HttpCode500        = 500,
    HttpCodeOtherError = -1,
}HttpCode;


#endif /* XDJRequestDefines_h */
