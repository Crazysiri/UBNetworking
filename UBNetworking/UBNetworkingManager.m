//
//  UBNetworkingManager.m
//  LenzNetworking
//
//  Created by Zero on 2020/7/15.
//  Copyright © 2020 Zero. All rights reserved.
//

#import "UBNetworkingManager.h"
#import "AFHTTPSessionManager.h"
#import "UBUploadPlugin.h"

static id<UBHttpNeeds> __lenz_http_needs;

@interface UBNetworkingManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) NSMutableDictionary *tasks;
@property (nonatomic, strong) NSNumber *currentTaskId;


@property (nonatomic, strong) UBUploadPlugin *uploadPlugin;


@end

@implementation UBNetworkingManager

+ (id<UBHttpNeeds>)needs {
    return __lenz_http_needs;
}

+ (void)setNeeds:(id<UBHttpNeeds>)needs {
    __lenz_http_needs = needs;
}

+ (id)shared {
    static dispatch_once_t onceToken;
    static UBNetworkingManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UBNetworkingManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.enableDebugLog = NO;
    }
    return self;
}



/**
 *  根据dataModel发起网络请求，并根据dataModel发起回调
 *
 *
 *  @return 网络请求task哈希值
 */
- (NSNumber *)callRequestWithRequestModel:(UBNetworkingTask *)model needs:(id<UBHttpNeeds>)needs {
    if (!needs) {
        needs = self.class.needs;
    }
    //设置 sessionManager
    AFHTTPSessionManager *sessionManager = [self managerFromNeeds:needs];
    
    NSURLSessionTask *task = nil;
    if ([model isKindOfClass:UBNetworkingTask.class]) {
        task = [self taskWithModel:model needs:needs manager:sessionManager];
    } else if ([model isKindOfClass:UBNetworkingUploadTask.class]) {
        task = [self.uploadPlugin task:sessionManager model:(UBNetworkingUploadTask *)model needs:needs];
    }

//        task = [self.downloadPlugin downloadTaskWithRequest:request requestModel:requestModel];
    [task resume];

    NSNumber *requestID = @(task.taskIdentifier);
    [self.tasks setObject:task forKey:requestID];
    return requestID;
}

//创建task
- (NSURLSessionTask *)taskWithModel:(UBNetworkingTask *)model
                              needs:(id<UBHttpNeeds>)need
                            manager:(AFHTTPSessionManager *)manager {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:need.commonParameters];
    [params addEntriesFromDictionary:model.params];
    
    params = (NSMutableDictionary *)[need beforeRequest:params];
    
    typeof(self) __weak weakSelf = self;

    __block NSURLSessionDataTask *task = [manager dataTaskWithHTTPMethod:model.method URLString:model.url parameters:params headers:need.headers uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSNumber *requestID = @(task.taskIdentifier);
        [weakSelf.tasks removeObjectForKey:requestID];
        
        //在这里做网络错误的解析，只是整理成error(包含重新发起请求，比如重新获取签名后再次请求),不做任何UI处理(包含reload，常规reload不在这里处理)，
        //解析完成后通过调用requestModel.responseBlock进行回调
        responseObject = [need afterResponse:responseObject];
        if (need.errorHandler) {
            [need.errorHandler resultHandlerWithRequestDataModel:model response:task.response responseObject:responseObject errorHandler:^(BOOL needCallback,NSError *newError) {
                if (!needCallback) {
                    return;
                }
                
                if (model.completion) {
                    model.completion(responseObject, task.response, newError);
                }
            }];
        } else {
            if (model.completion) {
                model.completion(responseObject, task.response, nil);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -999 || task.state == NSURLSessionTaskStateCanceling) {
            // 如果这个operation 是被cancel的，那就不用处理回调了
            return;
        }
        if (model.completion) {
            model.completion(nil, task.response, error);
        }
        
    }];
    return task;
}


/**
 *  取消网络请求
 */
- (void)cancelByID:(NSNumber *)tid {
    NSURLSessionDataTask *task = [self.tasks objectForKey:tid];
    [task cancel];
    [self.tasks removeObjectForKey:tid];
}

- (void)cancelByIDs:(NSArray<NSNumber *> *)tids {
    typeof(self) __weak weakSelf = self;
    [tids enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionDataTask *task = [weakSelf.tasks objectForKey:obj];
        [task cancel];
    }];
    [self.tasks removeObjectsForKeys:tids];
}



- (UBUploadPlugin *)uploadPlugin {
    if (!_uploadPlugin) {
        _uploadPlugin = [[UBUploadPlugin alloc] init];
    }
    return _uploadPlugin;
}

- (AFHTTPSessionManager *)managerFromNeeds:(id<UBHttpNeeds>)needs {
    
    AFHTTPSessionManager *manager = self.manager;
    AFHTTPRequestSerializer <AFURLRequestSerialization> *requestSerializer = manager.requestSerializer;
    Class class = AFHTTPRequestSerializer.class;
    switch (needs.requestType) {
        case DataTypeJson:
            class = AFJSONRequestSerializer.class;
            break;
        case DataTypePlist:
            class = AFPropertyListRequestSerializer.class;
            break;
        default:
            break;
    }
    
    if (!requestSerializer || ![requestSerializer isKindOfClass:class]) {
        requestSerializer = [class serializer];
        manager.requestSerializer = requestSerializer;
    }
    
    requestSerializer.timeoutInterval = [needs timeout];
    
    
    AFHTTPResponseSerializer <AFURLResponseSerialization> *response = manager.responseSerializer;

    class = AFHTTPResponseSerializer.class;
    switch (needs.responseType) {
        case DataTypeJson:
            class = AFJSONResponseSerializer.class;
            break;
        case DataTypePlist:
            class = AFPropertyListResponseSerializer.class;
            break;
        default:
            break;
    }
    
    if (!response || ![response isKindOfClass:class]) {
        response = [class serializer];
        manager.responseSerializer = response;
    }
    response.acceptableContentTypes = [needs acceptableContentTypes];;
    
    return manager;
}

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [self.class manager];
    }
    return _manager;
}

+ (AFHTTPSessionManager *)manager {
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForResource = 20;
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:NO];

    [sessionManager setSecurityPolicy:securityPolicy];
    return sessionManager;
}

@end
