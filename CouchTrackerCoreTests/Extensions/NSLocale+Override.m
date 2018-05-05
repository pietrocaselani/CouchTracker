#import "NSLocale+Override.h"
#import "NSObject+Swizzling.h"

@implementation NSLocale (Overridew)

+ (void)load
{
	[self ct_swizzleLocales];
}

static NSLocale *ct_locale = nil;

+ (void)ct_overrideRuntimeLocale:(NSLocale *)locale
{
	ct_locale = locale;
}

+ (void)ct_resetRuntimeLocale
{
	ct_locale = nil;
}

+ (void)ct_swizzleLocales
{
	[self ct_swizzleClassMethod:@selector(autoupdatingCurrentLocale) withReplacement:@selector(ct_autoupdatingCurrentLocale)];
	[self ct_swizzleClassMethod:@selector(currentLocale) withReplacement:@selector(ct_currentLocale)];
	[self ct_swizzleClassMethod:@selector(systemLocale) withReplacement:@selector(ct_systemLocale)];
}

+ (id /* NSLocale * */)ct_autoupdatingCurrentLocale
{
	return ct_locale ?: [self ct_autoupdatingCurrentLocale];
}

+ (id /* NSLocale * */)ct_currentLocale
{
	return ct_locale ?: [self ct_currentLocale];
}

+ (id /* NSLocale * */)ct_systemLocale
{
	return ct_locale ?: [self ct_systemLocale];
}

@end
