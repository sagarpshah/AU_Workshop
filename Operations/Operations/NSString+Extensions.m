#import "NSString+Extensions.h"


@implementation NSString (Extensions)

- (NSString *)cacheDirectoryPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
	return documentsDirectory;
}

- (NSString *)privateDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
    
}

- (NSString *)pathInCacheDirectory
{
	NSString *documentsDirectory = [self cacheDirectoryPath];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:self];
	
	return path;
}

- (NSString *)pathInPrivateDirectory
{
	NSString *documentsDirectory = [self privateDirectoryPath];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:self];
	
	return path;
}

- (NSString *)pathInDirectory:(NSString *)dir cachedData:(BOOL)yesOrNo
{
	NSString *documentsDirectory = nil;
    if (yesOrNo) {
        documentsDirectory = [self cacheDirectoryPath];
    }
    else {
        documentsDirectory = [self privateDirectoryPath];
    }
	NSString *dirPath = [documentsDirectory stringByAppendingString:dir];
	NSString *path = [dirPath stringByAppendingString:self];
	
	NSFileManager *manager = [NSFileManager defaultManager];
	[manager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
	
	return path;
}

- (NSString *)pathInDirectory:(NSString *)dir
{
    return [self pathInDirectory:dir cachedData:YES];
}

- (NSString *)removeWhiteSpace
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringByNormalizingCharacterInSet:(NSCharacterSet *)characterSet withString:(NSString *)replacement
{
	NSMutableString* result = [NSMutableString string];
	NSScanner* scanner = [NSScanner scannerWithString:self];
	while (![scanner isAtEnd]) {
		if ([scanner scanCharactersFromSet:characterSet intoString:NULL]) {
			[result appendString:replacement];
		}
		NSString* stringPart = nil;
		if ([scanner scanUpToCharactersFromSet:characterSet intoString:&stringPart]) {
			[result appendString:stringPart];
		}
	}
			
	return [result copy];
}

- (NSString *)bindSQLCharacters
{
	NSString *bindString = self;

	bindString = [bindString stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
	
	return bindString;
}

- (NSString *)trimSpaces
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t\n "]];
}

+ (BOOL)validateEmail:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:candidate];
}

// Range must be in {a,b}. Where a is mimimum length and b is max length
+ (BOOL)validateForNumericAndCharacets:(NSString *)candidate WithLengthRange:(NSString *)strRange
{
	BOOL valid = NO;
	NSCharacterSet *alphaNums = [NSCharacterSet alphanumericCharacterSet];
	NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:candidate];
	BOOL isAlphaNumeric = [alphaNums isSupersetOfSet:inStringSet];
	if(isAlphaNumeric){
		NSString *emailRegex = [NSString stringWithFormat:@"[%@]%@",candidate, strRange]; 
		NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
		valid =[emailTest evaluateWithObject:candidate];
	}
	return valid;
}

@end