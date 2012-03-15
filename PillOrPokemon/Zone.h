#import <CoreData/CoreData.h>

@interface Zone : NSManagedObject

@property (strong, nonatomic) NSNumber *gameZone;
@property (strong, nonatomic) NSNumber *unlocked;
@property (strong, nonatomic) NSNumber *completed;

@end
