//
//  NSString+UtilNetworking.m
//  NetWorking
//
//  Created by James on 16/4/27.
//  Copyright © 2016年 James. All rights reserved.
//

#import "NSString+UtilNetworking.h"

@implementation NSString (UtilNetworking)
+ (BOOL)isEmptyString:(NSString *)string
{
    if (!string) {
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    return string.length == 0;
}
@end
