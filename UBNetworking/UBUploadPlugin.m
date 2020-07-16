//
//  UBUploadPlugin.m
//  LenzNetworking
//
//  Created by Zero on 2020/7/15.
//  Copyright © 2020 Zero. All rights reserved.
//

#import "UBUploadPlugin.h"

@implementation UBUploadPlugin

- (NSURLSessionTask *)task:(AFHTTPSessionManager *)manager
                     model:(UBNetworkingUploadTask *)model
                     needs:(id<UBHttpNeeds>)needs
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:needs.commonParameters];
    [params addEntriesFromDictionary:model.params];
    
    params = (NSMutableDictionary *)[needs beforeRequest:params];

    NSError *serializationError = nil;
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:model.url relativeToURL:manager.baseURL] absoluteString] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (model.data) {
            [formData appendPartWithFileData:model.data
                                        name:model.name
                                    fileName:model.fileName
                                    mimeType:model.mimeType];
        } else {
            NSError *error;
            NSURL *fileURL = [NSURL fileURLWithPath:model.filePath];
            [formData appendPartWithFileURL:fileURL
                                       name:model.name
                                   fileName:model.fileName
                                   mimeType:model.mimeType
                                       error:&error];
        }

    } error:&serializationError];
    for (NSString *headerField in needs.headers.keyEnumerator) {
        [request setValue:needs.headers[headerField] forHTTPHeaderField:headerField];
    }
    if (serializationError) {
        if (model.completion) {
            model.completion(nil, nil, serializationError);
        }
        return nil;
    }
    
    return [manager uploadTaskWithStreamedRequest:request progress:model.uploadProgress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (model.completion) {
                model.completion(nil, response, error);
            }
        } else {
            responseObject = [needs afterResponse:responseObject];
            if (needs.errorHandler) {
                [needs.errorHandler resultHandlerWithRequestDataModel:model response:response responseObject:responseObject errorHandler:^(BOOL needCallback,NSError *newError) {
                    if (!needCallback) {
                        return;
                    }
                    
                    if (model.completion) {
                        model.completion(responseObject, response, newError);
                    }
                }];
            } else {
                if (model.completion) {
                    model.completion(responseObject, response, nil);
                }
            }

        }
    }];
}
@end
