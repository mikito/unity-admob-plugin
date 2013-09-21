//
//  UnityGLViewGetter.m
//  Unity-iPhone
//
//  Created by Mikito Yoshiya on 2013/09/21.
//
//

#import "UnityGLViewGetter.h"

extern UIViewController* UnityGetGLViewController();

@implementation UnityGLViewGetter

+(UIViewController *) viewController{
    return UnityGetGLViewController();
}

@end

