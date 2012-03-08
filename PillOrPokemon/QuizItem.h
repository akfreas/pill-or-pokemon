#import <CoreData/CoreData.h>

@interface QuizItem : NSManagedObject

@property (nonatomic, retain) NSNumber *gameZone;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *itemDescription;
@property (nonatomic, retain) NSNumber *correct;

@end
