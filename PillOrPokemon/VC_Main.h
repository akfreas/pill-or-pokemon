#import "VC_SplashScreen.h"

#ifdef BUILD_TARGET_FREE
#import "VC_ZoneSelectorFree.h"
#else
#import "VC_ZoneSelector.h"
#endif

#import <UIKit/UIKit.h>

@interface VC_Main : UIViewController {
    
    BOOL firstTime;
        
}

@property (retain, nonatomic) VC_ZoneSelector *zoneSelector;


@end
