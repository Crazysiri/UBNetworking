//
//  NSString+UtilNetworking.m
//  NetWorking
//
//  Created by James on 16/4/27.
//  Copyright © 2016年 James. All rights reserved.
//

#import "NSString+UtilNetworking.h"
#import <CommonCrypto/CommonDigest.h>

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

- (NSString *)ubnetworking_MD5
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (unsigned int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    
    return outputString;
}

@end
