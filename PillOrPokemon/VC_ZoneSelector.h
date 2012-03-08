#import "VC_GamePlay.h"

@interface VC_ZoneSelector : UIViewController {
    
    UIView *selectorView;
    UIButton *button;
    
    
}

+(NSURL *)documentsUrl;
+(NSMutableArray *)zonesFromPlist;
+(void)unlockZoneInPlist:(NSNumber *)zone;
+(void)initializeZonePlistWithLockedZones;
+(void)initializeZonePlistWithUnlockedZones;
-(IBAction)zoneSelected:(id)sender;

@end
