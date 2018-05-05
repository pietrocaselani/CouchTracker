#import "NSBundle+Language.h"
#import "NSObject+Swizzling.h"

@implementation NSBundle (Language)

+ (void)load
{
	[self ct_swizzleLanguageBundles];
}

static NSBundle *ct_languageBundle = nil;

+ (void)ct_swizzleLanguageBundles
{
	[self ct_swizzleInstanceMethod:@selector(localizedStringForKey:value:table:)
																withReplacement:@selector(ct_localizedStringForKey:value:table:)];
}

+ (NSBundle *)testingBundle
{
	return [NSBundle bundleWithIdentifier:@"io.github.pietrocaselani.CouchTrackerCoreTests"];
}

+ (void)ct_overrideLanguage:(NSString *)language
{
	NSString *path = [[self testingBundle] pathForResource:language ofType:@"lproj"];
	ct_languageBundle = [NSBundle bundleWithPath:path];
}

+ (void)ct_resetLanguage
{
	ct_languageBundle = nil;
}

- (NSString *)ct_localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName NS_FORMAT_ARGUMENT(1);
{
	if (ct_languageBundle)
	{
		return [ct_languageBundle ct_localizedStringForKey:key value:value table:tableName];
	}
	
	return [self ct_localizedStringForKey:key value:value table:tableName];
}

@end
