#import <Foundation/Foundation.h>

@interface NSLocale (Override)

+ (void)ct_overrideRuntimeLocale:(NSLocale *)locale;

+ (void)ct_resetRuntimeLocale;

@end
