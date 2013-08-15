#import <UIKit/UIKit.h>
#import "GADBannerView.h"
@interface AdViewController : UIViewController  <GADBannerViewDelegate>{
    GADBannerView *bannerView;
    NSMutableArray *testDeviceIDs;
    int position;
}

+ (CGSize) determineAdSize;
+ (void) installAdMob:(NSString *) unitID position:(int)position;
- (void) addTestDeviceID:(NSString *) testDeviceID;
- (void) hideAd;
- (void) showAd;
- (void) refreshBanner;
- (void) layoutAdView;
- (void) willRotate:(NSNotification *)notification;
- (void) didRotate:(NSNotification *)notification;
    
@property(nonatomic, strong) GADBannerView *bannerView;
@property(assign) int position;

enum _AdPosition{
    AdPositionTop,
    AdPositionBottom,
    AdPositionTopLeft,
    AdPositionTopRight,
    AdPositionBottomLeft,
    AdPositionBottomRight
};

@end

