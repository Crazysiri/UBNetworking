//
//  UBNetworkingTask.m
//  LenzNetworking
//
//  Created by Zero on 2020/7/15.
//  Copyright © 2020 Zero. All rights reserved.
//

#import "UBNetworkingTask.h"

#import "UBNetworkingManager.h"

#import "UBNetworkingAutoCancel.h"

@interface UBNetworkingTask ()

@property (nonatomic, strong) NSNumber *tid;

@property (nonatomic, strong) id <UBHttpNeeds> needs;

@property (nonatomic, weak) NSObject *control;

@end

@implementation UBNetworkingTask

- (void)setCompletion:(UBCompletionBlock)completion {

    if (completion != _completion) {
        __weak typeof(self) weakself = self;

        _completion = ^(id responseObject, NSURLResponse *response, NSError *error) {
            if (completion) {
                completion(responseObject,response,error);
            }
            [weakself.control removeTaskById:weakself.tid];
        };
    }

}

- (void)cancel {
    [UBNetworkingManager.shared cancelByID:self.tid];
}

- (void)resume {
    [self cancel];
    NSNumber *tid = [UBNetworkingManager.shared callRequestWithRequestModel:self needs:self.needs];
    self.tid = tid;
    [self.control setTask:self taskId:tid];
}

/// post的普通请求
+ (UBNetworkingTask *)post_control:(NSObject *)control //control 释放时销毁当前请求
                               url:(NSString *)url //请求的url
                             param:(NSDictionary *)parameters //参数
                        completion:(void(^)(id responseObject,NSURLResponse *response, NSError *error))completion {
    return [self post_control:control needs:nil url:url param:parameters progress:nil completion:completion];
}


/// post的普通请求
+ (UBNetworkingTask *)post_control:(NSObject *)control //control 释放时销毁当前请求
                             needs:(id<UBHttpNeeds>)needs //use default needs if nil
                               url:(NSString *)url //请求的url
                             param:(NSDictionary *)parameters //参数
                          progress:(void(^)(NSProgress *taskProgress))progress //进度progress
                        completion:(void(^)(id responseObject,NSURLResponse *response, NSError *error))completion {
    return [self control:control needs:needs method:@"POST" url:url param:parameters progress:progress completion:completion];
} //结果block

/// get的普通请求
+ (UBNetworkingTask *)get_control:(NSObject *)control //control 释放时销毁当前请求
                              url:(NSString *)url //请求的url
                            param:(NSDictionary *)parameters //参数
                       completion:(void(^)(id responseObject,NSURLResponse *response, NSError *error))completion {
    return [self get_control:control needs:nil url:url param:parameters progress:nil completion:completion];
}
/// get的普通请求
+ (UBNetworkingTask *)get_control:(NSObject *)control //control 释放时销毁当前请求
                            needs:(id<UBHttpNeeds>)needs //use default needs if nil
                              url:(NSString *)url //请求的url
                            param:(NSDictionary *)parameters //参数
                         progress:(void(^)(NSProgress *taskProgress))progress //进度progress
                       completion:(void(^)(id responseObject,NSURLResponse *response, NSError *error))completion {
    return [self control:control needs:needs method:@"GET" url:url param:parameters progress:progress completion:completion];
} //结果block

/// get的普通请求
+ (UBNetworkingTask *)control:(NSObject *)control //control 释放时销毁当前请求
                        needs:(id<UBHttpNeeds>)needs //use default needs if nil
                       method:(NSString *)method
                          url:(NSString *)url //请求的url
                        param:(NSDictionary *)parameters //参数
                     progress:(void(^)(NSProgress *taskProgress))progress //进度progress
                   completion:(void(^)(id responseObject,NSURLResponse *response, NSError *error))completion {
    UBNetworkingTask *task = [UBNetworkingTask new];
    task.url = url;
    task.method = method;
    task.params = parameters;
    task.uploadProgress = progress;
    task.completion = completion;

    task.needs = needs;
    task.control = control;

    [task resume];
    
    return task;
} //结果block
@end


@implementation UBNetworkingUploadTask

- (NSString *)method {
    return @"POST";
}

/// 上传文件data的请求 requestType 默认为 XDJRequestTypePostUpload
+ (UBNetworkingTask *)control:(NSObject *)control
                        needs:(id<UBHttpNeeds>)needs //use default needs if nil
                          url:(NSString *)url
                        param:(NSDictionary *)parameters
                     fileData:(NSData *)fileData
                     dataName:(NSString *)dataName
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                     progress:(void(^)(NSProgress *taskProgress))progress //进度progress
                   completion:(UBCompletionBlock)completion {
    UBNetworkingUploadTask *task = [UBNetworkingUploadTask new];
    task.url = url;
    task.params = parameters;
    task.uploadProgress = progress;
    task.completion = completion;

    task.name = dataName;
    task.fileName = fileName;

    task.mimeType = mimeType;
    task.data = fileData;

    task.needs = needs;
    task.control = control;

    [task resume];
    
    return task;
}

@end
