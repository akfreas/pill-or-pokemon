//
//  GamePlayData.m
//  PillOrPokemon
//
//  Created by Alexander Freas on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamePlayData.h"
#import "QuizItem.h"
#import "Zone.h"

//static GamePlayData *gamePlayData;

@implementation GamePlayData {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectContext *context;
    NSMutableArray *quizItemsInZone;
}


+(GamePlayData *)sharedInstance {
    
    static GamePlayData *gamePlayData = nil;
    if (!gamePlayData) {
        gamePlayData = [[self alloc] init];
    }
    
    static dispatch_once_t pred;
	dispatch_once(&pred, ^{
		gamePlayData = [[GamePlayData alloc] init];
	});
	
    return gamePlayData;
}




+(void)createDatabaseForFirstUse {
    
    [[GamePlayData sharedInstance] importPPData];
    [[GamePlayData sharedInstance] resetZones];
}





-(id)init {
    self = [super init];
    
    if (self) {
        context = [self managedObjectContext];     
    }
    
    return self;   
}

-(void)importPPData {
    
    
    NSArray *zoneItems = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PPData" ofType:@"plist"]] objectForKey:@"Root"];
    NSError *error;
    
    for (int i=0; i<[zoneItems count]; i++) {
        NSArray *quizItems = [zoneItems objectAtIndex:i];
        for (int y=0; y<[quizItems count]; y++) {
            QuizItem *quizItem = [NSEntityDescription insertNewObjectForEntityForName:@"QuizItem" inManagedObjectContext:context];
            NSDictionary *quizItemFromDict = [quizItems objectAtIndex:y];
            
            quizItem.name = [quizItemFromDict objectForKey:@"name"];
            quizItem.itemDescription = [quizItemFromDict objectForKey:@"description"];
            quizItem.type = [quizItemFromDict objectForKey:@"type"];
            quizItem.correct = [NSNumber numberWithBool:NO];
            quizItem.gameZone = [NSNumber numberWithInt:i + 1];
            
            [context save:&error];
        }
    }


}


-(NSFetchRequest *)zoneFetchRequest {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Zones" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    return fetchRequest;
}

-(void)resetZones {
    
    NSError *error;
    
    for (int i=1; i<=4; i++) {
        
        Zone *zone = [NSEntityDescription insertNewObjectForEntityForName:@"Zones" inManagedObjectContext:context];
        zone.gameZone = [NSNumber numberWithInt:i];
        zone.completed = [NSNumber numberWithBool:NO];
        
        if (i==1) {
            zone.unlocked = [NSNumber numberWithBool:YES];
        } else {
            zone.unlocked = [NSNumber numberWithBool:NO];
        }
        
        [context save:&error];
    }
}

-(NSArray *)quizItems {
    return quizItemsInZone;
}

-(NSArray *)zones {
    NSFetchRequest *fetchRequest =[self zoneFetchRequest];
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

-(void)unlockZone:(NSInteger)theZone {
    
    NSError *error;
    
    NSFetchRequest *request = [self zoneFetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gameZone == %d", theZone];
    [request setPredicate:predicate];
    
    Zone *zone = (Zone *)[[context executeFetchRequest:request error:&error] lastObject];
    zone.unlocked = [NSNumber numberWithBool:YES];
    [context save:&error];
}

-(void)markZoneComplete:(NSInteger)theZone {
    
    NSError *error;
    
    NSFetchRequest *request = [self zoneFetchRequest];
    
    NSPredicate *predicateForZone = [NSPredicate predicateWithFormat:@"gameZone == %d", theZone];
    [request setPredicate:predicateForZone];
    
    Zone *zone = (Zone *)[[context executeFetchRequest:request error:&error] lastObject];
    zone.unlocked = [NSNumber numberWithBool:YES];
    
    NSFetchRequest *quizItemRequest = [self quizItemFetchRequest];
    [quizItemRequest setPredicate:predicateForZone];
    NSArray *quizItems = [[context executeFetchRequest:quizItemRequest error:&error] lastObject];
    for (QuizItem *item in quizItems) {
        item.correct = NO;
    }
    
    [context save:&error];
}

-(NSInteger)count {
    return [quizItemsInZone count];
}

-(void)save {
    
    NSError *error;
    if(![context save:&error]) {
        NSLog(@"Error: %@", error);
    };
}

-(void)shuffleQuizData {
    
    static BOOL seeded = NO;
    if(!seeded)
    {
        seeded = YES;
        srandom(time(NULL));
    }
    
    NSUInteger count = [quizItemsInZone count];
    for (NSUInteger i = 0; i < count; ++i) {
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [quizItemsInZone exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

-(void)setZone:(NSInteger)zone {
    [self setQuizItemsInZone:zone];
}

-(NSFetchRequest *)quizItemFetchRequest {
   NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
   
   NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuizItem" inManagedObjectContext:context];
   [fetchRequest setEntity:entity];
   return fetchRequest;
}

-(void)setQuizItemsInZone:(NSInteger)zone {
    
    NSFetchRequest *request = [self quizItemFetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gameZone == %d AND correct == %d", zone, NO];
    [request setPredicate:predicate];
    
    NSError *error;

    quizItemsInZone = [NSMutableArray arrayWithArray:[context executeFetchRequest:request error:&error]];
}

-(NSManagedObjectContext *)managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
    return managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    storeUrl = [storeUrl URLByAppendingPathComponent:@"PillOrPokemonData.sqlite"];
	
    NSLog(@"DB Location: %@", storeUrl);
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}

-(NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


@end
