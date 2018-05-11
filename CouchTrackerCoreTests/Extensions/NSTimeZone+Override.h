#import <Foundation/Foundation.h>

@interface NSTimeZone (Override)

+ (void)ct_overrideRuntimeTimeZone:(NSTimeZone *)timeZone;

+ (void)ct_resetRuntimeTimeZone;

@end
