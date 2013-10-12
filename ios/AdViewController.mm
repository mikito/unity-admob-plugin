#import "AdViewController.h"
#import "AdTransparentView.h"

#define BANNER_REFRESH_RATE 30

extern UIViewController* UnityGetGLViewController();
extern UIView* UnityGetGLView();

@implementation AdViewController

@synthesize bannerView;
@synthesize position;


static AdViewController *instance = nil;

+ (CGSize) determineAdSize{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        return GAD_SIZE_320x50;
	}else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return GAD_SIZE_468x60;
	}
    return CGSizeMake(0.0, 0.0);
}

+ (void) installAdMob:(NSString *)adMobID position:(int)position{
    if(instance != nil) return;
    
    // Init
    AdViewController *adViewController = [[AdViewController alloc] init];
    instance = adViewController;
    [instance addTestDeviceID:GAD_SIMULATOR_ID];
    
    // Unity View
    UIViewController *rootViewController = UnityGetGLViewController();
    UIView *rootView = UnityGetGLView();
    
    // Add Ad Base View
    adViewController.view = [[[AdTransparentView alloc] init] autorelease];
    adViewController.position = position;
    adViewController.view.frame = rootView.bounds;
    adViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [rootView addSubview:adViewController.view];
    
    // Init Admob
    GADBannerView *bannerView = [[GADBannerView alloc] init];
    bannerView.adUnitID = adMobID;
    bannerView.rootViewController = rootViewController;
    bannerView.delegate = adViewController;
   
    // Add AdView
    adViewController.bannerView = bannerView;
    [adViewController layoutAdView];
    [adViewController.view addSubview:bannerView];
    
    NSLog(@"Install AdMob");
}

- (void)layoutAdView{
    CGRect rootBounds = self.view.bounds;
    CGSize adSize = [AdViewController determineAdSize];
    CGRect frame;
    int autoresizingMask = 0;
    
    frame.size = adSize;
    
    // x layout
    switch (position) {
        case AdPositionTop:
        case AdPositionBottom:
            frame.origin.x = (rootBounds.size.width - adSize.width) / 2;
            autoresizingMask += UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            break;
        case AdPositionTopLeft:
        case AdPositionBottomLeft:
            frame.origin.x = 0;
            autoresizingMask += UIViewAutoresizingFlexibleRightMargin;
            break;
        case AdPositionTopRight:
        case AdPositionBottomRight:
            frame.origin.x = 0;
            autoresizingMask += UIViewAutoresizingFlexibleLeftMargin;
            break;
    }
    
    // y layout
    switch (position) {
        case AdPositionTop:
        case AdPositionTopLeft:
        case AdPositionTopRight:
            frame.origin.y = 0;
            autoresizingMask += UIViewAutoresizingFlexibleBottomMargin;
            break;
        case AdPositionBottom:
        case AdPositionBottomLeft:
        case AdPositionBottomRight:
            frame.origin.y = rootBounds.size.height - adSize.height;
            autoresizingMask += UIViewAutoresizingFlexibleTopMargin;
            break;
    }
   
    bannerView.frame = frame;
    bannerView.autoresizingMask = autoresizingMask;
}

- (id)init {
	self = [super init];
	if (self != nil) {
        testDeviceIDs = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) addTestDeviceID:(NSString *) testDeviceID{
    [testDeviceIDs addObject:testDeviceID];
}

- (void) showAd{
    self.bannerView.hidden = NO;
}

- (void) hideAd{
    self.bannerView.hidden = YES;
}

- (void)refreshBanner {
    GADRequest *request = [GADRequest request];
    request.testDevices = testDeviceIDs;

    [self.bannerView loadRequest:request];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%@", error);
    [NSTimer scheduledTimerWithTimeInterval:BANNER_REFRESH_RATE target:self selector:@selector(refreshBanner) userInfo:nil repeats:NO];
}

- (void)dealloc {
    self.view = nil;
    self.bannerView.delegate = nil;
    [self.bannerView release];
    [testDeviceIDs release];
    instance = nil;
    [super dealloc];
}

@end

extern "C" {
    void installAdMobIOS_(char *adMobID, int position);
    void addTestDeviceIDIOS_(char *deviceID);
    void hideAdIOS_();
    void showAdIOS_();
    void refreshAdIOS_();
    void releaseAdMobIOS_();
    bool isIpadAdMob_();
}

void installAdMobIOS_(char *adMobID, int position){
    [AdViewController installAdMob:
     [NSString stringWithCString:adMobID encoding:NSASCIIStringEncoding]
                          position: position];
}

void addTestDeviceIDIOS_(char *deviceID){
    if(instance != nil){
        [instance addTestDeviceID:[NSString stringWithCString:deviceID encoding:NSASCIIStringEncoding]];
    }
}

void hideAdIOS_(){
    if(instance != nil){
        [instance hideAd];
    }
}

void showAdIOS_(){
    if(instance != nil){
        [instance showAd];
    }
}

void refreshAdIOS_(){
    if(instance != nil){
        [instance refreshBanner];
    }
}

void releaseAdMobIOS_(){
    if(instance != nil){
        [instance release];
    }
}

bool isIpadAdMob_(){
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        return false;
	}else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return true;
	}
    return false;
}
