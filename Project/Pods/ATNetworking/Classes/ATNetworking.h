//
//  ATNetworking.h
//
//  Created by William Locke on 4/9/15.
//  Copyright (c) 2015 Adtrade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATWebApiResponse.h"

@class ATHTTPRequest;


@interface ATNetworking : NSObject


@property (nonatomic, copy) NSString *baseUrl;
@property (strong, nonatomic) ATHTTPRequest *httpRequest;
@property (strong, nonatomic) NSString *httpAuthenticationKey;
@property (strong, nonatomic) NSMutableDictionary *headerFields;
@property (strong, nonatomic) NSString *serializationFormat;
@property Class webApiResponseClass;

@property (strong, nonatomic) NSMutableArray *httpRequests;

+(ATNetworking *)sharedInstance;

typedef void (^ ATWebApiResponseHandler)(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSURLResponse *response, NSDictionary *data);


-(void)requestURL:(NSString *)url
completionHandler:(ATWebApiResponseHandler)completionHandler;

-(void)requestURL:(NSString *)url
       withParams:(NSDictionary *)params
completionHandler:(ATWebApiResponseHandler)completionHandler;

-(void)requestURL:(NSString *)url
       withParams:(NSDictionary *)params
       httpMethod:(NSString *)httpMethod
          headers:(NSMutableDictionary *)headers
completionHandler:(ATWebApiResponseHandler)completionHandler;

-(void)requestURL:(NSString *)url
       withParams:(NSDictionary *)params
       httpMethod:(NSString *)httpMethod
          headers:(NSMutableDictionary *)headers
completionHandler:(ATWebApiResponseHandler)completionHandler;

-(void)requestURL:(NSString *)url
           withParams:(NSDictionary *)params
            files:(NSMutableArray *)files
       httpMethod:(NSString *)httpMethod
          options:(NSDictionary *)options
completionHandler:(ATWebApiResponseHandler)completionHandler;

-(void)requestURL:(NSString *)url
           withParams:(NSMutableDictionary *)params
            files:(NSMutableArray *)files
       httpMethod:(NSString *)httpMethod
     headerFields:(NSMutableDictionary *)headerFields
          options:(NSMutableDictionary *)options
completionHandler:(ATWebApiResponseHandler)completionHandler;


- (id)initWithBaseUrl:(NSString *)baseUrl;


@end
