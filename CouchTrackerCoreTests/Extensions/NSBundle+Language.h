#import <Foundation/Foundation.h>

@interface NSBundle (Language)

+ (void)ct_overrideLanguage:(NSString *)language;

+ (void)ct_resetLanguage;

@end
