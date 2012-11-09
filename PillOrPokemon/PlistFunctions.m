//
//  PlistFunctions.m
//  PillOrPokemon
//
//  Created by Alexander Freas on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlistFunctions.h"

@implementation PlistFunctions

+(NSURL *)documentsUrl {
    
    NSURL *unlockedZonesPlistUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    unlockedZonesPlistUrl = [unlockedZonesPlistUrl URLByAppendingPathComponent:@"Scores.plist"];
    return unlockedZonesPlistUrl;
}

+(NSMutableArray *)zonesFromPlist {
    
    NSURL *unlockedZonesPlistUrl = [PlistFunctions documentsUrl];
    NSMutableArray *zones = [[NSDictionary dictionaryWithContentsOfURL:unlockedZonesPlistUrl] objectForKey:@"zones"];
    return zones;
}

+(void)unlockZoneInPlist:(NSNumber *)zone {
    
    NSMutableArray *zones = [PlistFunctions zonesFromPlist];
    [zones replaceObjectAtIndex:[zone intValue] withObject:@"unlocked"];
    [PlistFunctions saveZones:zones];
}

+(void)initializeZonePlistWithLockedZones {
    
    NSMutableArray *zones = [NSMutableArray arrayWithCapacity:4];
    [zones addObject:@"unlocked"];
    for (int i=1; i<4; i++) {
        [zones addObject:@"locked"];
    }
    
    [PlistFunctions saveZones:zones];
}

+(void)initializeZonePlistWithUnlockedZones {
    
    NSMutableArray *zones =  [NSMutableArray arrayWithCapacity:4];
    for (int i=0; i<4; i++) {
        [zones addObject:@"unlocked"];
    }
    
    [PlistFunctions saveZones:zones];
}

+(void)saveZones:(NSMutableArray *)zones {
    
    NSURL *plistUrl = [self documentsUrl];
    NSDictionary *zoneDict = [NSDictionary dictionaryWithObject:zones forKey:@"zones"];
    [zoneDict writeToURL:plistUrl atomically:YES];
}

+(NSMutableArray *)incorrectQuestions {

    NSURL *plistUrl = [self documentsUrl];
    NSMutableArray *incorrect = [[NSDictionary dictionaryWithContentsOfURL:plistUrl] objectForKey:@"incorrect"];
    return incorrect;
}

+(void)addIncorrectQuestion:(NSMutableArray *)newIncorrect forZone:(NSInteger)zone {

    NSURL *plistUrl = [self documentsUrl];
    NSMutableArray *oldIncorrect = [[NSDictionary dictionaryWithContentsOfURL:plistUrl] objectForKey:@"incorrect"];
    
}


@end