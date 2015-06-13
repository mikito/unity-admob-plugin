#import "AdInterstitialViewController.h"

extern UIWindow* UnityGetMainWindow();
extern "C" void UnitySendMessage(const char *, const char *, const char *);

@implementation AdInterstitialViewController

- (id)initWithManagerName:(NSString *) _managerName {
	self = [super init];
    
    testDeviceIDs = [[NSMutableArray alloc] init];
    //[self addTestDeviceID:GAD_SIMULATOR_ID];
    
    managerName = [_managerName retain];
    
	return self;
}

- (void) addTestDeviceID:(NSString *) testDeviceID{
    [testDeviceIDs addObject:testDeviceID];
}

- (void)dealloc {
    self.view = nil;
    [interstitial release];
    [testDeviceIDs release];
    [managerName release];
    [super dealloc];
}

- (void)loadAdMobIntersBanner:(NSString *) unitID{
    UIView *rootView = UnityGetMainWindow();
    
    if (self.view == nil) {
        self.view = [[[UIView alloc] init] autorelease];
        self.view.frame = rootView.frame;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    [rootView addSubview:self.view];
    
    interstitial = [[GADInterstitial alloc] initWithAdUnitID:unitID];
    interstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    request.testDevices = testDeviceIDs;
    [interstitial loadRequest:request];
}

#pragma mark GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    [interstitial presentFromRootViewController:self];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    [self.view removeFromSuperview];
    UnitySendMessage([managerName UTF8String], "DidInterstitialFinish", "");
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    [self.view removeFromSuperview];
    UnitySendMessage([managerName UTF8String], "DidInterstitialFinish", "");
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad{}
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad{}
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad{}

@end

extern "C" {
    void *adMobInterstitialInit(char *managerName);
    void adMobInterstitialAddTestDevice(void *instance, char *deviceID);
    void adMobInterstitialShow(void *instance, char *unitID);
    void adMobInterstitialRelease(void *instance);
}

void *adMobInterstitialInit(char *managerName) {
    id instance = [[AdInterstitialViewController alloc] initWithManagerName:
                   [NSString stringWithCString:managerName encoding:NSASCIIStringEncoding]
                   ];
    return (void *)instance;
}

void adMobInterstitialAddTestDevice(void *instance, char *deviceID) {
    AdInterstitialViewController *interstitial = (AdInterstitialViewController*)instance;
    [interstitial addTestDeviceID: [NSString stringWithCString:deviceID encoding:NSASCIIStringEncoding]];
}

void adMobInterstitialShow(void *instance, char *unitID) {
    AdInterstitialViewController *interstitial = (AdInterstitialViewController*)instance;
    [interstitial loadAdMobIntersBanner:[NSString stringWithCString:unitID encoding:NSASCIIStringEncoding]];
}

void adMobInterstitialRelease(void *instance) {
    AdInterstitialViewController *interstitial = (AdInterstitialViewController*)instance;
    [interstitial release];
}
