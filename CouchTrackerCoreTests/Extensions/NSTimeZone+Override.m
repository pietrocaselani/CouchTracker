#import "NSTimeZone+Override.h"
#import "NSObject+Swizzling.h"

@implementation NSTimeZone (Override)

+ (void)load
{
	[self ct_swizzleTimeZones];
}

static NSTimeZone *ct_timeZone = nil;

+ (void)ct_overrideRuntimeTimeZone:(NSTimeZone *)timeZone
{
	ct_timeZone = timeZone;
}

+ (void)ct_resetRuntimeTimeZone
{
	ct_timeZone = nil;
}

+ (void)ct_swizzleTimeZones
{
	[self ct_swizzleClassMethod:@selector(systemTimeZone) withReplacement:@selector(ct_systemTimeZone)];
}

+ (instancetype)ct_systemTimeZone
{
	return ct_timeZone ?: [self ct_systemTimeZone];
}

@end
