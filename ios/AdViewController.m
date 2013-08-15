#import "AdViewController.h"
#import "AdTransparentView.h"
#import "UnityAppController.h"

#define BANNER_REFRESH_RATE 30

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
    
    // Add AdView
    adViewController.view = [[[AdTransparentView alloc] init] autorelease];
    adViewController.position = position;
    UIView *rootView = ((UnityAppController*)[UIApplication sharedApplication].delegate).rootView;
    [rootView addSubview:adViewController.view];
    
    // Init Admob
    GADBannerView *bannerView = [[GADBannerView alloc] init];
    adViewController.bannerView = bannerView;
    [adViewController.view addSubview:bannerView];

    [adViewController layoutAdView];
    
    bannerView.adUnitID = adMobID;
    bannerView.rootViewController = adViewController;
    bannerView.delegate = adViewController;
    
    // Rotate Notification
    [[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(willRotate:)
                                                 name:@"kUnityViewWillRotate"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(didRotate:)
                                                 name:@"kUnityViewDidRotate"
                                               object:nil];
    
    NSLog(@"Install AdMob");
}

- (void)layoutAdView{
    UIView *rootView = ((UnityAppController*)[UIApplication sharedApplication].delegate).rootView;
    self.view.frame = rootView.bounds;
    
    // Determine Ad Position
    CGSize adSize = [AdViewController determineAdSize];
    CGRect frame;
    frame.size = adSize;
    
    switch(position){
    case AdPositionTop:
        frame.origin.x = (rootView.bounds.size.width - adSize.width) / 2;
        frame.origin.y = 0;
        break;
    case AdPositionBottom:
        frame.origin.x = (rootView.bounds.size.width - adSize.width) / 2;
        frame.origin.y = rootView.bounds.size.height - adSize.height;
        break;
    case AdPositionTopLeft:
        frame.origin.x = 0;
        frame.origin.y = 0;
        break;
    case AdPositionTopRight:
        frame.origin.x = rootView.bounds.size.width - adSize.width;
        frame.origin.y = 0;
        break;
    case AdPositionBottomLeft:
        frame.origin.x = 0;
        frame.origin.y = rootView.bounds.size.height - adSize.height;
        break;
    case AdPositionBottomRight:
        frame.origin.x = rootView.bounds.size.width - adSize.width;
        frame.origin.y = rootView.bounds.size.height - adSize.height;
        break;
    }
    
    self.bannerView.frame = frame;
}

- (void)willRotate:(NSNotification *)notification{
    [self hideAd];
}

- (void)didRotate:(NSNotification *)notification{
    [self layoutAdView];
    [self showAd];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.view = nil;
    self.bannerView.delegate = nil;
    [self.bannerView release];
    [testDeviceIDs release];
    instance = nil;
    [super dealloc];
}

@end

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
