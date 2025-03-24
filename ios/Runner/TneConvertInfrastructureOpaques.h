#import <Foundation/Foundation.h>
@interface TneConvertInfrastructureOpaques : NSObject
- (int)lockTable:(int)version cache:(int)cache;
- (int)validateToken:(int)version cache:(int)cache;
- (int)initializeSession:(int)version cache:(int)cache;
@end