# UBNetworking
封装了 网络请求 af4.x

1.header seach path 添加 "${PODS_ROOT}/UBNetworking/UBNetworking"

2.引 头文件 #import "UBNetworking.h"

3.自定义业务类型 header 见demo networkingSettings/RequestDefines.h
    比如 版本号，设备类型，业务错误码定义等。
    
4.自定义业务错误处理类 见demo networkingSettings/NetErrorHandler
    继承自 XDJBaseNetErrorHandler 实现唯一的方法，写自己的业务逻辑即可
    
5.自定义公共参数类（header，body等）见demo networkingSettings/RequestCommonNeeds
    实现 XDJRequestCommonNeedsDelegate 方法
    
6.最后一步：
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
[XDJDataEngine initializeWithErrorHandlerClass:[NetErrorHandler class] commonNeeds:[[RequestCommonNeeds alloc]init]];
}

7.使用：
//control 参数的意思，如果object释放，那么立即结束请求（当然此处只是例子，AppDelegate不会释放，一般设置成viewController）
NSObject *object = self;
XDJDataEngine *engine =  [XDJDataEngine control:object url:@"http://baidu.com" param:nil requestType:XDJRequestTypeGet progressBlock:nil complete:^(id responseObject, NSError *error) {

}];
engine.BeforeResumeBlock = ^(NSMutableURLRequest *request) {
//这里在请求之前可以设置一下request
};

