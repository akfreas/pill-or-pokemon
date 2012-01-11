//
//  VC_ZoneSelector.h
//  PillOrPokemon
//
//  Created by Alexander Freas on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VC_GamePlay.h"

@interface VC_ZoneSelector : UIViewController {
    
    IBOutlet UIImageView *zoneSelector;
    
    
}

-(IBAction)selectZone:(id)sender;

@end
