//
//  UBNetworkingTask.h
//  LenzNetworking
//
//  Created by Zero on 2020/7/15.
//  Copyright © 2020 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UBHttpNeeds.h"

@interface UBNetworkingTask : NSObject

//GET,POST
@property (copy,nonatomic) NSString *method;

@property (copy,nonatomic) NSString *url;

@property (copy,nonatomic) NSDictionary *params;

@property (nonatomic,copy) UBCompletionBlock completion;

@property (nonatomic,copy)  UBProgressBlock uploadProgress;


- (void)resume;

- (void)cancel;


/// post的普通请求
+ (UBNetworkingTask *)post_control:(NSObject *)control //control 释放时销毁当前请求
                               url:(NSString *)url //请求的url
                             param:(NSDictionary *)parameters //参数
                        completion:(void(^)(id responseObject,NSURLResponse *response, NSError *error))completion;
/// post的普通请求
+ (UBNetworkingTask *)post_control:(NSObject *)control //control 释放时销毁当前请求
                             needs:(id<UBHttpNeeds>)needs //use default needs if nil
                               url:(NSString *)url //请求的url
                             param:(NSDictionary *)parameters //参数
                          progress:(void(^)(NSProgress *taskProgress))progress //进度progress
                        completion:(UBCompletionBlock)completion; //结果block

/// get的普通请求
+ (UBNetworkingTask *)get_control:(NSObject *)control //control 释放时销毁当前请求
                              url:(NSString *)url //请求的url
                            param:(NSDictionary *)parameters //参数
                       completion:(void(^)(id responseObject,NSURLResponse *response, NSError *error))completion;
/// get的普通请求
+ (UBNetworkingTask *)get_control:(NSObject *)control //control 释放时销毁当前请求
                            needs:(id<UBHttpNeeds>)needs //use default needs if nil
                              url:(NSString *)url //请求的url
                            param:(NSDictionary *)parameters //参数
                         progress:(void(^)(NSProgress *taskProgress))progress //进度progress
                       completion:(UBCompletionBlock)completion; //结果block
@end

@interface UBNetworkingUploadTask : UBNetworkingTask

/*
 method 为 POST
 */

@property (copy,nonatomic) NSString *name;

@property (copy,nonatomic) NSString *fileName;

@property (copy,nonatomic) NSString *mimeType;

@property (copy,nonatomic) NSData *data;

@property (copy,nonatomic) NSString *filePath;


/// 上传文件
+ (UBNetworkingTask *)control:(NSObject *)control
                        needs:(id<UBHttpNeeds>)needs //use default needs if nil
                          url:(NSString *)url
                        param:(NSDictionary *)parameters
                     fileData:(NSData *)fileData
                     dataName:(NSString *)dataName
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                     progress:(void(^)(NSProgress *taskProgress))progress //进度progress
                   completion:(UBCompletionBlock)completion; //结果block

@end
