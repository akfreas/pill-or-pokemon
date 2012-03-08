@interface PlistFunctions : NSObject


+(NSURL *)documentsUrl;
+(NSMutableArray *)zonesFromPlist;
+(void)unlockZoneInPlist:(NSNumber *)zone;
+(void)initializeZonePlistWithLockedZones;
+(void)initializeZonePlistWithUnlockedZones;

@end
