//
//  GamePlayData.m
//  PillOrPokemon
//
//  Created by Alexander Freas on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamePlayData.h"
#import "QuizItem.h"

@implementation GamePlayData {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectContext *context;
    NSArray *quizItemsInZone;
}



-(id)initWithZone:(NSInteger)zone {
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
    [context save:&error];
}



-(void)setQuizItemsInZone:(NSInteger)zone {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuizItem" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gameZone == %d", zone];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;

    quizItemsInZone = [context executeFetchRequest:fetchRequest error:&error];
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
	
    NSURL *storeUrl = [[NSBundle mainBundle] URLForResource:@"PillOrPokemonData" withExtension:@"sqlite"];
	
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
