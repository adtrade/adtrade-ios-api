AdtradeAPI
==========

Wrapper for Adtrade API. 

Usage
-----

Sign up to Adtrade (adtrade.com) to get app key. 

```objective-c
#import "AdtradeAPI.h"
```

```objective-c

[[AdtradeAPI sharedInstance] setAppKey:@"FC32F3BB88B7091F4F3AD8B22B105728"];

```

#### Get app
```objective-c
[[AdtradeAPI sharedInstance] getAppWithSucess:^(NSDictionary *item) {
  // Handle successful response
} failure:^(NSError *error) {
  
}];
```

#### Create session
```objective-c
[[AdtradeAPI sharedInstance] createSessionWithSucess:^(NSDictionary *item) {
  // Handle successful response
  
} failure:^(NSError *error) {
        
}];
```

#### Create install
```objective-c
[[AdtradeAPI sharedInstance] createInstallWithSucess:^(NSDictionary *item) {
  // Handle successful response
  
} failure:^(NSError *error) {
        
}];
```

#### Create interstitial
```objective-c
[[AdtradeAPI sharedInstance] createImpressionWithSucess:^(NSDictionary *item) {
  // Handle successful response
  
} failure:^(NSError *error) {
        
}];
```

<p align="center">
  <img src="https://raw.githubusercontent.com/adtrade/AdtradeAPI/master/Resources/show-ad.png?token=ABWhtYhavcfuRcAAOmbv-NPnhQF1rDmHks5XIo7KwA%3D%3D" alt="Example interstitial"/>
</p>



Documentation
-------------

[Apple Docs](http://adtrade.github.io/adtrade-ios-api/logs/appledoc/html/Classes/AdtradeAPI.html)

