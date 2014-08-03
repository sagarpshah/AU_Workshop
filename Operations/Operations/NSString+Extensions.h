#import <Foundation/Foundation.h>


@interface NSString (Extensions)

- (NSString *)cacheDirectoryPath;
- (NSString *)privateDirectoryPath;
- (NSString *)pathInCacheDirectory;
- (NSString *)pathInPrivateDirectory;
- (NSString *)pathInDirectory:(NSString *)dir cachedData:(BOOL)yesOrNo;
- (NSString *)pathInDirectory:(NSString *)dir;
- (NSString *)removeWhiteSpace;
- (NSString *)stringByNormalizingCharacterInSet:(NSCharacterSet *)characterSet withString:(NSString *)replacement;
- (NSString *)bindSQLCharacters;
- (NSString *)trimSpaces;
+ (BOOL)validateEmail:(NSString *)candidate;
+ (BOOL)validateForNumericAndCharacets:(NSString *)candidate WithLengthRange:(NSString *)strRange;

@end
