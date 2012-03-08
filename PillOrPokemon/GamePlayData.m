//
//  GamePlayData.m
//  PillOrPokemon
//
//  Created by Alexander Freas on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamePlayData.h"
#import "QuizItem.h"

static GamePlayData *gamePlayData;

@implementation GamePlayData {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectContext *context;
    NSMutableArray *quizItemsInZone;
}


+(GamePlayData *)sharedInstance {
    
    static BOOL initialized = NO;
    if (!initialized) {
        gamePlayData = [[self alloc] init];
    }
    return gamePlayData;
}




+(void)createDatabaseForFirstUse {
    
    NSError *error;
    NSURL *urlForDbInBundle = [[NSBundle mainBundle] URLForResource:@"PillOrPokemonData" withExtension:@"sqlite"];
    NSURL *urlForDbInDocuments = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    [urlForDbInDocuments URLByAppendingPathComponent:@"PillOrPokemonData.sqlite"];

    if(![[NSFileManager defaultManager] removeItemAtURL:urlForDbInDocuments error:&error]) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    if (![[NSFileManager defaultManager] copyItemAtURL:urlForDbInBundle toURL:urlForDbInDocuments error:&error]) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}





-(id)init {
    self = [super init];
    
    if (self) {
        context = [self managedObjectContext];     
        [self setQuizItemsInZone:zone];
    }
    
    return self;   
}



-(QuizItem *)quizItemAtIndex:(NSInteger)index {
    return [quizItemsInZone objectAtIndex:index];
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
    [gamePlayData setQuizItemsInZone:zone];
}

-(void)setQuizItemsInZone:(NSInteger)zone {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuizItem" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gameZone == %d AND correct == %d", zone, NO];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;

    quizItemsInZone = [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:&error]];
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
    [storeUrl URLByAppendingPathComponent:@"PillOrPokemonData.sqlite"];
	
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
