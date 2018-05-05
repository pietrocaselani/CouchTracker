#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

+ (void)ct_swizzleClassMethod:(SEL)original withReplacement:(SEL)swizzled;

+ (void)ct_swizzleInstanceMethod:(SEL)original withReplacement:(SEL)swizzled;

@end
