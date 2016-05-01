//
// Created by William Locke on 4/9/15.
// Copyright (c) 2016 Adtrade (http://adtrade.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AdtradeAPI.h"
#import "ATNetworking.h"
#import <AdSupport/AdSupport.h>

NSString * const ATDeviceIdentifierTypeAdvertisingIdentifier = @"advertising_identifier";
NSString * const ATDeviceIdentifierTypeIdentifierForVendor = @"identifier_for_vendor";

@interface AdtradeAPI(){
    NSString *_appID;
    NSString *_deviceID;
}

@end

@implementation AdtradeAPI

+(AdtradeAPI *)sharedInstance{
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init{
    self = [super init];
    if (self) {
        [[ATNetworking sharedInstance] setBaseUrl:@"https://api.adtrade.com/api"];
    }
    return self;
}

-(void)setServer:(NSString *)serverURL{
    [[ATNetworking sharedInstance] setBaseUrl:serverURL];
}

#pragma mark ATNetworking
-(void)requestURL:(NSString *)url
       withParams:(NSMutableDictionary *)params
       httpMethod:(NSString *)httpMethod
          headers:(NSMutableDictionary *)headers
completionHandler:(ATWebApiResponseHandler)completionHandler{
    if(!params){
        params = [NSMutableDictionary new];
    }
    if(!headers){
        headers = [NSMutableDictionary new];
    }
    [headers addEntriesFromDictionary:[self defaultHeaders]];
    [self addDeviceToParams:params];
    [self addAppToParams:params];
    
    [[ATNetworking sharedInstance] requestURL:url withParams:params httpMethod:httpMethod headers:headers completionHandler:completionHandler];
}

#pragma mark Sessions
-(void)createSessionWithSuccess:(void (^ )(NSDictionary *item))success failure:(void (^ )(NSError *error))failure{
    [self requestURL:@"/sessions/" withParams:nil httpMethod:@"POST" headers:nil completionHandler:^(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSURLResponse *response, NSDictionary *data) {
        
        if (item) {
            success(item);
        }else{
            failure(error);
        }
    }];
}

#pragma mark Installs
-(void)createInstallWithSucess:(void (^ )(NSDictionary *item))success failure:(void (^ )(NSError *error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"app":@{@"app_key":self.appKey}}];
    [self requestURL:@"/installs/" withParams:params httpMethod:@"POST" headers:nil completionHandler:^(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSURLResponse *response, NSDictionary *data) {
        
        if (item) {
            _appID = item[@"app"][@"id"];
            _deviceID = item[@"device"][@"id"];
            success(item);
        }else{
            failure(error);
        }
    }];
}

-(void)listInstallsWithSucess:(void (^ )(NSArray *items))success failure:(void (^ )(NSError *error))failure{
    if (!(_deviceID && _appID && self.appKey)) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUserAuthenticationRequired userInfo:@{NSLocalizedDescriptionKey:@"Device ID and App ID are not set"}];
        failure(error);
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"app":@{@"app_key":self.appKey}}];
    [self requestURL:@"/installs/" withParams:params httpMethod:@"GET" headers:nil completionHandler:^(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSURLResponse *response, NSDictionary *data) {
        if (items) {
            success(items);
        }else{
            failure(error);
        }
    }];
}

#pragma mark Apps
-(void)getAppWithSucess:(void (^ )(NSDictionary *item))success failure:(void (^ )(NSError *error))failure{
    if(!self.appKey){
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUserAuthenticationRequired userInfo:@{NSLocalizedDescriptionKey:@"'appKey' is not set"}];
        failure(error);
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"app":@{@"app_key":self.appKey}}];
    [self requestURL:@"/apps/" withParams:params httpMethod:@"GET" headers:nil completionHandler:^(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSURLResponse *response, NSDictionary *data) {
        if (item) {
            success(item);
        }else{
            failure(error);
        }
    }];
}

#pragma mark Impressions
-(void)createImpressionWithSucess:(void (^ )(NSDictionary *item))success failure:(void (^ )(NSError *error))failure{
    [self requestURL:@"/impressions/" withParams:nil httpMethod:@"POST" headers:nil completionHandler:^(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSURLResponse *response, NSDictionary *data) {
        if (item) {
            success(item);
        }else{
            failure(error);
        }
    }];
}

-(void)deleteImpressionWithID:(nonnull NSString *)impressionID uniqueToken:(nonnull NSString *)uniqueToken sucess:(void (^ )(NSDictionary *item))success failure:(void (^ )(NSError *error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"impression":@{@"id":[NSString stringWithFormat:@"%@", impressionID], @"unique_token":[NSString stringWithFormat:@"%@", uniqueToken]}}];
    [self requestURL:[NSString stringWithFormat:@"/impressions/%@", impressionID] withParams:params httpMethod:@"DELETE" headers:nil completionHandler:^(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSURLResponse *response, NSDictionary *data) {
        if (item) {
            success(item);
        }else{
            failure(error);
        }
    }];
}

-(void)updateImpression:(nonnull NSDictionary *)impression sucess:(void (^ )(NSDictionary *item))success failure:(void (^ )(NSError *error))failure{
    impression = [self updateCamelcaseToUnderscoreInDictionary:impression];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary: @{@"impression":impression}];
    [self requestURL:[NSString stringWithFormat:@"/impressions/%@", impression[@"id"]] withParams:params httpMethod:@"PUT" headers:nil completionHandler:^(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSURLResponse *response, NSDictionary *data) {
        if (item) {
            success(item);
        }else{
            failure(error);
        }
    }];
}

#pragma mark Clicks
-(void)deleteClickForImpression:(NSDictionary *)impression sucess:(void (^ )(NSDictionary *item))success failure:(void (^ )(NSError *error))failure{
    NSString *impressionID = [NSString stringWithFormat:@"%@", impression[@"id"] ? impression[@"id"] : impression[@"identifier"]];
    impression = [self updateCamelcaseToUnderscoreInDictionary:impression];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary: @{ @"impression":@{@"id":impressionID, @"unique_token":[NSString stringWithFormat:@"%@", impression[@"unique_token"]]}}];
    [self addDeviceToParams:params];
    
    [self requestURL:@"/clicks/" withParams:params httpMethod:@"DELETE" headers:nil completionHandler:^(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSURLResponse *response, NSDictionary *data) {
        if (item) {
            success(item);
        }else{
            failure(error);
        }
    }];
}

-(void)createClickForImpression:(nonnull NSDictionary *)impression sucess:(void (^ )(NSDictionary *item))success failure:(void (^ )(NSError *error))failure{
    impression = [self updateCamelcaseToUnderscoreInDictionary:impression];
    NSString *impressionID = impression[@"id"] ? impression[@"id"] : impression[@"identifier"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary: @{ @"impression":@{@"id":impressionID, @"unique_token":impression[@"unique_token"]}}];
    [self addDeviceToParams:params];
    
    [self requestURL:@"/clicks/" withParams:params httpMethod:@"POST" headers:nil completionHandler:^(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSURLResponse *response, NSDictionary *data) {
        if (item) {
            success(item);
        }else{
            failure(error);
        }
    }];
}

#pragma mark Purchases
-(void)createPurchase:(nonnull NSDictionary *)purchase sucess:(void (^)(NSDictionary *item))success failure:(void (^)(NSError *))failure{
    purchase = [purchase isKindOfClass:[NSDictionary class]] ? purchase : [NSDictionary new];
    purchase = [self updateCamelcaseToUnderscoreInDictionary:purchase];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"purchase":purchase}];
    [self requestURL:@"/purchases/" withParams:params httpMethod:@"POST" headers:nil completionHandler:^(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSURLResponse *response, NSDictionary *data) {
        if (item) {
            success(item);
        }else{
            failure(error);
        }
    }];
}

#pragma mark Default parameters
-(NSMutableDictionary *)defaultHeaders{
    NSMutableDictionary *headers =  [[NSMutableDictionary alloc] initWithDictionary:@{}];
    [headers setValue:@"application/json" forKey:@"Content-Type"];
    return headers;
}

-(void)addDeviceToParams:(NSMutableDictionary *)params{
    NSString *identifierForVendor = [self identifierForVendor];
    NSString *advertisingIdentifier = [self advertisingIdentifier];
    NSMutableDictionary *deviceOptions = [[NSMutableDictionary alloc] init];
    if (identifierForVendor) {
        [params setValue:identifierForVendor forKey:ATDeviceIdentifierTypeIdentifierForVendor];
        [deviceOptions setValue:identifierForVendor forKey:ATDeviceIdentifierTypeIdentifierForVendor];
    }
    if (advertisingIdentifier) {
        [params setValue:advertisingIdentifier forKey:ATDeviceIdentifierTypeAdvertisingIdentifier];
        [deviceOptions setValue:advertisingIdentifier forKey:ATDeviceIdentifierTypeAdvertisingIdentifier];
    }
    [params setValue:[UIDevice currentDevice].model forKey:@"model"];
    NSString *osVersion = [@"" stringByAppendingFormat:@"%@", [[UIDevice currentDevice] systemVersion]];
    [params setValue:osVersion forKey:@"os_version"];
    [deviceOptions setValue:osVersion forKey:@"os_version"];
    [deviceOptions setValue:[UIDevice currentDevice].model forKey:@"model"];
    
    NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    if(countryCode){
        [params setValue:countryCode forKey:@"country_code"];
        [deviceOptions setValue:countryCode forKey:@"country_code"];
    }
    NSString *screenScale = [@"" stringByAppendingFormat:@"%.2f", [[UIScreen mainScreen] scale]];
    [params setValue:screenScale forKey:@"screen_scale"];
    [deviceOptions setValue:screenScale forKey:@"screen_scale"];
    if(_deviceID){
        [deviceOptions setValue:_deviceID forKey:@"id"];
    }
    
    [params setValue:deviceOptions forKey:@"device"];
}

-(void)addAppToParams:(NSMutableDictionary *)params{
    if(!self.appKey){
        return;
    }
    NSMutableDictionary *appParams = [[NSMutableDictionary alloc] init];
    [appParams setValue:self.appKey forKey:@"app_key"];
    [params setValue:self.appKey forKey:@"app_key"];
    if (_appID) {
        [appParams setValue:_appID forKey:@"id"];
    }
    
    NSString *versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (versionNumber && [versionNumber isKindOfClass:[NSString class]]) {
        [appParams setValue:versionNumber forKey:@"version"];
    }
    [params setValue:appParams forKey:@"app"];
}

-(void)addCompanyToParams:(NSMutableDictionary *)params{
    if (self.companyUniqueToken && [self.companyUniqueToken isKindOfClass:[NSString class]]) {
        [params setValue:@{ @"unique_token" : self.companyUniqueToken } forKey:@"company"];
    }
}

-(NSString *)identifierForVendor{
    if ([self isAdvertisingTrackingEnabled]) {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return nil;
}

-(NSString *)advertisingIdentifier{
    if ([self isAdvertisingTrackingEnabled]) {
        return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    return nil;
}

- (BOOL)isAdvertisingTrackingEnabled{
    Class identifireManagerClass = NSClassFromString(@"ASIdentifierManager");
    
    BOOL isAdvertisingTrackingEnabled = NO;
    if (identifireManagerClass) {
        isAdvertisingTrackingEnabled = [[identifireManagerClass sharedManager] isAdvertisingTrackingEnabled];
    }
    return isAdvertisingTrackingEnabled;
}

-(NSDictionary *)updateCamelcaseToUnderscoreInDictionary:(NSDictionary *)dictionary{
    NSMutableDictionary *newDictionary = [NSMutableDictionary new];
    for (NSString *key in dictionary){
        id value = dictionary[key];
        NSString *newKey = [self camelcaseToUnderscore:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            [newDictionary setValue:[self updateCamelcaseToUnderscoreInDictionary:value] forKey:newKey];
        }else{
            [newDictionary setValue:value forKey:newKey];
        }
    }
    return newDictionary;
}

-(NSString *)camelcaseToUnderscore:(NSString *)string{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=[a-z])([A-Z])|([A-Z])(?=[a-z])" options:0 error:nil];
    NSString *underscoreString = [[regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@"_$1$2"] lowercaseString];
    return underscoreString;
}

@end
