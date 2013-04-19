#import <UIKit/UIKit.h>
#import "GADBannerView.h"
@interface AdViewController : UIViewController  <GADBannerViewDelegate>{
    GADBannerView *bannerView;
    NSMutableArray *testDeviceIDs;
}

+ (CGSize) determineAdSize;
+ (void) installAdMob:(NSString *) unitID position:(int)position;
- (void) addTestDeviceID:(NSString *) testDeviceID;
- (void) hideAd;
- (void) showAd;
- (void) refreshBanner;

@property(nonatomic, retain) GADBannerView *bannerView;

enum _AdPosition{
    AdPositionTop ,
    AdPositionBottom
};

@end

