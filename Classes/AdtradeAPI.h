//
//  AdtradeAPI.h
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

#import <UIKit/UIKit.h>
#import "ATNetworking.h"

@class ATHTTPRequest;


@interface AdtradeAPI : NSObject

@property (nonnull, nonatomic, copy) NSString *appKey;
@property (nonnull, nonatomic, copy) NSString *companyUniqueToken;


+(nonnull AdtradeAPI *)sharedInstance;

-(void)setServer:(nonnull NSString *)serverURL;

///---------------------------------------------------------------------------------------
/// @name Apps
///---------------------------------------------------------------------------------------
/** Get app [API Documentation](http://docs.adtrade.apiary.io/reference/0/apps/get-app)
 
 @param success Block passes back dictionary object representing an app. See API docs for dictionary structure.
 @param failure Block passes back `NSError` object describing error that occurred. See userInfo[NSLocalizedDescriptionKey] for description of error.
 */
-(void)getAppWithSucess:(nullable void (^ )(NSDictionary *_Nonnull item))success failure:(nullable void (^ )(NSError *_Nonnull error))failure;


///---------------------------------------------------------------------------------------
/// @name Installs
///---------------------------------------------------------------------------------------
/** Create install [API Documentation](http://docs.adtrade.apiary.io/reference/0/installs/create-install)
 
 @param success Block passes back dictionary object representing an install. See API docs for dictionary structure.
 @param failure Block passes back `NSError` object describing error that occurred. See userInfo[NSLocalizedDescriptionKey] for description of error.
 */
-(void)createInstallWithSucess:(nullable void (^ )(NSDictionary *_Nonnull item))success failure:(nullable void (^ )(NSError *_Nonnull error))success;

/** List installs [API Documentation](http://docs.adtrade.apiary.io/reference/0/installs/list-installs)
 
 @param success Block passes back an array of dictionary objects representing installs. See API docs for dictionary structure.
 @param failure Block passes back `NSError` object describing error that occurred. See userInfo[NSLocalizedDescriptionKey] for description of error.
 */
-(void)listInstallsWithSucess:(nullable void (^ )(NSArray *_Nonnull items))success failure:(nullable void (^ )(NSError *_Nonnull error))failure;


///---------------------------------------------------------------------------------------
/// @name Sessions
///---------------------------------------------------------------------------------------
/** Create session [API Documentation](http://docs.adtrade.apiary.io/reference/0/sessions/create-session)
 
 @param success Block passes back dictionary object representing a session. See API docs for dictionary structure.
 @param failure Block passes back `NSError` object describing error that occurred. See userInfo[NSLocalizedDescriptionKey] for description of error.
 */
-(void)createSessionWithSuccess:(nullable void (^ )(NSDictionary *_Nonnull item))success failure:(nullable void (^ )(NSError *_Nonnull error))failure;


///---------------------------------------------------------------------------------------
/// @name Impressions
///---------------------------------------------------------------------------------------
/** Create impression [API Documentation](http://docs.adtrade.apiary.io/reference/0/impressions/create-impression)
 
 @param success Block passes back dictionary object representing an impression. See API docs for dictionary structure.
 @param failure Block passes back `NSError` object describing error that occurred. See userInfo[NSLocalizedDescriptionKey] for description of error.
 */
-(void)createImpressionWithSucess:(nullable void (^ )(NSDictionary *_Nonnull item))success failure:(nullable void (^ )(NSError *_Nonnull error))failure;

/** Update impression [API Documentation](http://docs.adtrade.apiary.io/reference/0/impressions/update-impression)
 
 @param success Block passes back dictionary object representing updated impression. See API docs for dictionary structure.
 @param failure Block passes back `NSError` object describing error that occurred. See userInfo[NSLocalizedDescriptionKey] for description of error.
 */
-(void)updateImpression:(nonnull NSDictionary *)impression sucess:(nullable void (^ )(NSDictionary *_Nonnull item))success failure:(nullable void (^ )(NSError *_Nonnull error))failure;

/** Delete impression [API Documentation](http://docs.adtrade.apiary.io/reference/0/impressions/delete-impression)
 
 @param success Block passes back dictionary object representing deleted impression. See API docs for dictionary structure.
 @param failure Block passes back `NSError` object describing error that occurred. See userInfo[NSLocalizedDescriptionKey] for description of error.
 */
-(void)deleteImpressionWithID:(nonnull NSString *)impressionID uniqueToken:(nonnull NSString *)uniqueToken sucess:(nullable void (^ )(NSDictionary *_Nonnull item))success failure:(nullable void (^ )(NSError *_Nonnull error))failure;


///---------------------------------------------------------------------------------------
/// @name Clicks
///---------------------------------------------------------------------------------------
-(void)deleteClickForImpression:(nonnull NSDictionary *)impression sucess:(nullable void (^ )(NSDictionary *_Nonnull item))success failure:(nullable void (^ )(NSError *_Nonnull error))failure;
-(void)createClickForImpression:(nonnull NSDictionary *)impression sucess:(nullable void (^ )(NSDictionary *_Nonnull item))success failure:(nullable void (^ )(NSError *_Nonnull error))failure;

///---------------------------------------------------------------------------------------
/// @name Purchases
///---------------------------------------------------------------------------------------
-(void)createPurchase:(nonnull NSDictionary *)purchase sucess:(nullable void (^)(NSDictionary *_Nonnull item))success failure:(nullable void (^)(NSError *_Nonnull error))failure;

@end
