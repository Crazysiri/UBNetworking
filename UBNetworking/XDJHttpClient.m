//
//  XDJBaseRequest.m
//  NetWorking
//
//  Created by qiuyoubo on 2017/12/18.
//  Copyright © 2017年 Yasin. All rights reserved.
//

#import "XDJHttpClient.h"
#import "AFURLSessionManager.h"

#import "XDJBaseRequestDataModel.h"
#import "XDJRequestGenerator.h"
#import "XDJBaseNetErrorHandler.h"


@interface XDJHttpClient () {
    Class _errorHandlerClass;
}
//afnetworking
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
//根据requestid 存放 task
@property (nonatomic ,strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recodedRequestId;

//根据Requestid存放requestModel
@property (strong ,nonatomic) NSMutableDictionary *requestModelDict;

@end


@implementation XDJHttpClient

#pragma mark - life cycle
#pragma mark - public methods
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static XDJHttpClient *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XDJHttpClient alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self registerErrorHandlerClass:[XDJBaseNetErrorHandler class]];
    }
    return self;
}

- (void)registerErrorHandlerClass:(Class)aClass {
    _errorHandlerClass = aClass;
}


/**
 *  根据dataModel发起网络请求，并根据dataModel发起回调
 *
 *
 *  @return 网络请求task哈希值
 */
- (NSNumber *)callRequestWithRequestModel:(XDJBaseRequestDataModel *)requestModel beforeResume:(void(^)(NSMutableURLRequest *request))block {
    XDJRequestGenerator *generator = [XDJRequestGenerator shared];
    NSMutableURLRequest *request = [generator  requestWithDataModel:requestModel];
    typeof(self) __weak weakSelf = self;
    AFURLSessionManager *sessionManager = self.sessionManager;
    AFJSONResponseSerializer *Serializer = sessionManager.responseSerializer;
    NSMutableSet *set = [NSMutableSet set];
    id <XDJRequestCommonNeedsDelegate> needs = [generator needs];
    for (NSString *string in [needs contentTypes]) {
        [set addObject:string];
    }
    Serializer.acceptableContentTypes = set;
    
    __weak typeof(_errorHandlerClass) weakClass = _errorHandlerClass;

    __block NSURLSessionDataTask *task = [sessionManager dataTaskWithRequest:request uploadProgress:requestModel.uploadProgressBlock downloadProgress:requestModel.downloadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response,id  _Nullable responseObject, NSError * _Nullable error) {
        if (error || !responseObject || ([responseObject[@"code"] integerValue] != 200)) {
            NSLog(@"请求：%@ object:%@ error:%@",requestModel.url,responseObject,error);
        }
        
        if (error.code == -999 || task.state == NSURLSessionTaskStateCanceling) {
            // 如果这个operation 是被cancel的，那就不用处理回调了。
        } else {
            NSNumber *requestID = [NSNumber numberWithUnsignedInteger:task.hash];
            [weakSelf.dispatchTable removeObjectForKey:requestID];
            
            //在这里做网络错误的解析，只是整理成error(包含重新发起请求，比如重新获取签名后再次请求),不做任何UI处理(包含reload，常规reload不在这里处理)，
            //解析完成后通过调用requestModel.responseBlock进行回调
            [weakClass resultHandlerWithRequestDataModel:requestModel responseURL:response responseObject:responseObject error:error errorHandler:^(BOOL needCallback,NSError *newError) {
                if (!needCallback) {
                    return;
                }
                
                if (requestModel.responseBlock)
                    requestModel.responseBlock(responseObject, newError);
            }];
        }
    }];
    
    if (block) {
        block(request);
    }
    [task resume];

    NSNumber *requestID = [NSNumber numberWithUnsignedInteger:task.hash];
    [self.dispatchTable setObject:task forKey:requestID];
    return requestID;
}

/**
 *  取消网络请求
 */
- (void)cancelRequestWithRequestID:(NSNumber *)requestID{
    NSURLSessionDataTask *task = [self.dispatchTable objectForKey:requestID];
    [task cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}
- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList{
    typeof(self) __weak weakSelf = self;
    [requestIDList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionDataTask *task = [weakSelf.dispatchTable objectForKey:obj];
        [task cancel];
    }];
    [self.dispatchTable removeObjectsForKeys:requestIDList];
}







- (AFURLSessionManager *)getCommonSessionManager
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForResource = 20;
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    return sessionManager;
}

#pragma mark - progress observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    //拿到进度
    //    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
        
        XDJBaseRequestDataModel *model = progress.userInfo[@"model"];
        if (model.uploadProgressBlock)
        model.uploadProgressBlock(progress);
    }
    
}

#pragma mark - getters and setters
- (AFURLSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [self getCommonSessionManager];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _sessionManager;
}
- (NSMutableDictionary *)dispatchTable{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}



@end

