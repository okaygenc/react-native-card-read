#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(CardRead, NSObject)

RCT_EXTERN_METHOD(scanCard:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

@end
