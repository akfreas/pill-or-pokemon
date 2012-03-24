#import "VC_Main.h"


@class VC_ZoneSelector;

@implementation VC_Main

@synthesize zoneSelector;


-(id)init {
    self = [self initWithNibName:@"MainView" bundle:nil];
    return self;
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    firstTime = YES;
        
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(firstTime){
        firstTime = NO;
        VC_SplashScreen *splashView = [[VC_SplashScreen alloc] init];

        splashView.modalPresentationStyle = UIModalPresentationFullScreen;
        splashView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:splashView animated:YES];
    } else {
        zoneSelector = [[VC_ZoneSelector alloc] init];
        
        [self.view addSubview:zoneSelector.view];
        
    }
    

}

@end
