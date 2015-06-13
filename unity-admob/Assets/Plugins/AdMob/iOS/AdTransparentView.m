#import "AdTransparentView.h"

@implementation AdTransparentView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // Pass-through touch events outside the banner view;
    UIView *bannerView = [self.subviews objectAtIndex:0];
    return bannerView && [bannerView pointInside:[self convertPoint:point toView:bannerView] withEvent:event];
}

@end
