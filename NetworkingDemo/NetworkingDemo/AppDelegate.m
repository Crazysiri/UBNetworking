//
//  AppDelegate.m
//  NetworkingDemo
//
//  Created by James on 2018/4/12.
//  Copyright © 2018年 James. All rights reserved.
//

#import "AppDelegate.h"
#import "UBNetworking.h"
#import "NetErrorHandler.h"
#import "RequestCommonNeeds.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [XDJDataEngine initializeWithDefaultNeeds:[RequestCommonNeeds new]];
    // Override point for customization after application launch.
    
    //control 参数的意思，如果object释放，那么立即结束请求（当然此处只是例子，AppDelegate不会释放，一般设置成viewController）
    NSObject *object = self;
//   __block XDJDataEngine *engine = [XDJDataEngine control:object url:@"http://baidu.com" param:nil requestType:XDJRequestTypeGet progressBlock:nil complete:^(id responseObject, NSError *error) {
//       NSLog(@"response:%@", engine.response);
//    }];
    

    
    [XDJDataEngine control:nil url:@"https://storage.googleapis.com/golang/go1.8.1.linux-amd64.tar.gz" param:nil beforeRequest:nil downloadProgress:^(NSInteger currentFileLength, NSInteger totalFileLenght) {
        NSLog(@"%f",(float)currentFileLength / totalFileLenght);
    } complete:^(NSString *path, NSURLResponse *response, NSError *error) {
        
    }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
