@class VC_ZoneSelector;

@interface VC_GamePlay : UIViewController <UIAlertViewDelegate, UIPopoverControllerDelegate> {
    
    
}

-(id)initWithZone:(NSInteger)theZone zoneSelector:(VC_ZoneSelector *)theZoneSelector;
-(IBAction)chooseType:(id)sender;
@end
