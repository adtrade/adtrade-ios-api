//
//  AdtradeAPITests.m
//  AdtradeAPITests
//
//  Created by William Locke on 4/21/16.
//  Copyright © 2016 Adtrade. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AdtradeAPI.h"

static int kRequestTimeout = 30;

@interface AdtradeAPITests : XCTestCase

@end

@implementation AdtradeAPITests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [[AdtradeAPI sharedInstance] setAppKey:@"FC32F3BB88B7091F4F3AD8B22B105728"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetApp {
    XCTestExpectation *expectation = [self expectationWithDescription:@"GET app"];
    
    [[AdtradeAPI sharedInstance] getAppWithSucess:^(NSDictionary *item) {

        BOOL expectedStructure = [self responseObject:item matchesExpectedObject:[self exampleObjectForModelName:@"App"]];
        XCTAssert(expectedStructure, @"API response object doesn't meet expected structure.");
        [expectation fulfill];
        
    } failure:^(NSError *error) {
        XCTAssert(NO, @"Error getting app");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}


#pragma mark Validation
-(NSDictionary *)exampleObjectForModelName:(NSString *)modelName{
    id object = [self objectFromFile:[@"" stringByAppendingFormat:@"%@.json", [modelName lowercaseString]]];
    return [object isKindOfClass:[NSDictionary class]] ? object : [NSDictionary new];
}

-(BOOL)responseObject:(NSDictionary *)dictionary matchesExpectedObject:(NSDictionary *)validationDictionary{
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    for (NSString *key in validationDictionary) {
        id object = dictionary[key];
        if (!object) {
            NSLog(@"key: %@ not found", key);
            return NO;
        }
        id validationObject = validationDictionary[key];
        if ([object isKindOfClass:[NSDictionary class]] && [validationObject isKindOfClass:[NSDictionary class]]) {
            if(![self responseObject:object matchesExpectedObject:validationObject]){
                return NO;
            }
        }
    }
    return YES;
}

-(id)objectFromFile:(NSString *)resource{
    NSString *ext = [resource pathExtension];
    NSString *base = [resource stringByDeletingPathExtension];
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:base ofType:ext]];
    return [self jsonObjectFromData:data];
}

-(id)jsonObjectFromData:(NSData *)data{
    if (!data) {
        return nil;
    }
    id object =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (object) {
        return object;
    }
    return nil;
}

@end
