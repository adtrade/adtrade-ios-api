//
//  Created by William Locke on 4/9/15.
//  Copyright (c) 2015 Adtrade. All rights reserved.
//

#import "ATNetworking.h"
#import "ATHTTPRequest.h"

static ATNetworking *_sharedWebApi;

@implementation ATNetworking

+ (ATNetworking *)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (id)init{
    self = [self initWithBaseUrl:@""];
    if (self) {
        
    }
    return self;
}

- (id)initWithBaseUrl:(NSString *)baseUrl
{
    self = [super init];
    if (self) {
        _webApiResponseClass = [ATWebApiResponse class];
        
        _baseUrl = baseUrl;
        _httpRequest = [[ATHTTPRequest alloc] init];
        if(!_serializationFormat){
            _serializationFormat = @"";
        }
    }
    return self;
}


-(void)requestURL:(NSString *)url
completionHandler:(ATWebApiResponseHandler)completionHandler{
    [self requestURL:url withParams:nil files:nil httpMethod:@"GET" headerFields:nil options:nil completionHandler:completionHandler];
}

-(void)requestURL:(NSString *)url
       withParams:(NSDictionary *)params
completionHandler:(ATWebApiResponseHandler)completionHandler{
    [self requestURL:url withParams:params files:nil httpMethod:@"GET" headerFields:nil options:nil completionHandler:completionHandler];
}

-(void)requestURL:(NSString *)url
       withParams:(NSDictionary *)params
       httpMethod:(NSString *)httpMethod
          headers:(NSMutableDictionary *)headers
completionHandler:(ATWebApiResponseHandler)completionHandler{
    [self requestURL:url withParams:params files:nil httpMethod:httpMethod headerFields:headers options:nil completionHandler:completionHandler];
}

-(void)requestURL:(NSString *)url
           withParams:(NSMutableDictionary *)params
       httpMethod:(NSString *)httpMethod
          options:(NSMutableDictionary *)options completionHandler:(ATWebApiResponseHandler)completionHandler{
    [self requestURL:url withParams:params files:nil httpMethod:httpMethod options:options completionHandler:completionHandler];
}

-(void)requestURL:(NSString *)url
           withParams:(NSMutableDictionary *)params
            files:(NSMutableArray *)files
       httpMethod:(NSString *)httpMethod
          options:(NSMutableDictionary *)options completionHandler:(ATWebApiResponseHandler)completionHandler{
    [self requestURL:url withParams:params files:nil httpMethod:httpMethod headerFields:nil options:options completionHandler:completionHandler];
}

-(void)requestURL:(NSString *)url
           withParams:(NSMutableDictionary *)params
            files:(NSMutableArray *)files    
       httpMethod:(NSString *)httpMethod
       headerFields:(NSMutableDictionary *)headerFields
          options:(NSMutableDictionary *)options completionHandler:(ATWebApiResponseHandler)completionHandler{
    if(_baseUrl && [url rangeOfString:@"http"].location != 0){
        url = [_baseUrl stringByAppendingFormat:@"%@%@", url, self.serializationFormat];
    }
    
    ATHTTPRequest *httpRequest = [[ATHTTPRequest alloc] init];
    if (!_httpRequests) {
        _httpRequests = [[NSMutableArray alloc] init];
    }
    [_httpRequests addObject:httpRequest];
    
    [httpRequest sendRequestWithUrl:url
                         httpMethod:httpMethod
                             withParams:params
                              files:files
              httpAuthenticationKey:_httpAuthenticationKey
              headerFields:headerFields
                  completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                      
                      
                      [ATWebApiResponse processResponse:response data:data withCompletionHandler:^(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSDictionary *data) {
                          
                          
                          completionHandler(item, items, error, errorDictionary, response, data);
                      }];
                      
                      [_httpRequests removeObject:httpRequest];
                  }];
}

@end
