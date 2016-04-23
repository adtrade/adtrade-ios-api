//
//  HttpRequest.h
//  
//
//  Created by William Locke on 4/6/15.
//  Copyright (c) 2015 Adtrade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATHTTPRequest : NSObject

@property BOOL shouldPassHttpMethodAsParameter;

typedef void (^ completionHandler)(NSURLResponse *response, NSData *data, NSError *error);
-(BOOL)sendRequestWithUrl:(NSString *)url
               httpMethod:(NSString *)httpMethod
                   withParams:(NSMutableDictionary *)params
                    files:(NSMutableArray *)files
        completionHandler:(completionHandler)completionHandler;

-(BOOL)sendRequestWithUrl:(NSString *)url
               httpMethod:(NSString *)httpMethod
                   withParams:(NSMutableDictionary *)params
                    files:(NSMutableArray *)files
    httpAuthenticationKey:(NSString *)httpAuthenticationKey
        completionHandler:(completionHandler)completionHandler;

-(BOOL)sendRequestWithUrl:(NSString *)url
               httpMethod:(NSString *)httpMethod
                   withParams:(NSMutableDictionary *)params
                    files:(NSMutableArray *)files
    httpAuthenticationKey:(NSString *)httpAuthenticationKey
             headerFields:(NSDictionary *)headerFields
        completionHandler:(completionHandler)completionHandler;

-(NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)__request;

@end

