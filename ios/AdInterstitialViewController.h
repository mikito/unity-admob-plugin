#import <UIKit/UIKit.h>
extern "C" {
  #import "GADInterstitial.h"
}
@interface AdInterstitialViewController : UIViewController  <GADInterstitialDelegate>{
    NSString *managerName;
    GADInterstitial *interstitial;
    NSMutableArray *testDeviceIDs;
}

- (id) initWithManagerName:(NSString *)managerName;
- (void) addTestDeviceID:(NSString *) testDeviceID;
- (void) loadAdMobIntersBanner:(NSString *) unitID;

@end

