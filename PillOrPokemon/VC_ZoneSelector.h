#import "VC_GamePlay.h"

@interface VC_ZoneSelector : UIViewController <UIAlertViewDelegate> {
    
    UIView *selectorView;
    UIButton *button;
    
    
}

-(IBAction)zoneSelected:(id)sender;
-(void)refresh;

@end
