#import "AdViewController.h"
#import "AdTransparentView.h"

#define BANNER_REFRESH_RATE 30

@implementation AdViewController

@synthesize bannerView = _bannerView;

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
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    adViewController.view = [[[AdTransparentView alloc] initWithFrame:window.bounds] autorelease];
    [window addSubview:adViewController.view];
    
    // Determine Ad Position
    CGRect frame;
    CGSize adSize = [AdViewController determineAdSize];
    if (position == AdPositionTop) {
        frame = CGRectMake((window.frame.size.width - adSize.width)/2,
                           0.0,
                           adSize.width,
                           adSize.height);
    }else if(position == AdPositionBottom){
        frame = CGRectMake((window.frame.size.width - adSize.width)/2,
                           window.frame.size.height -adSize.height,
                           adSize.width,
                           adSize.height);
    }
    
    // Init Admob
    GADBannerView *bannerView = [[GADBannerView alloc] initWithFrame:frame];
    bannerView.adUnitID = adMobID;
    bannerView.rootViewController = adViewController;
    bannerView.delegate = adViewController;
    adViewController.bannerView = bannerView;
    [adViewController.view addSubview:bannerView];
    
    NSLog(@"Install AdMob");
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
