#import <Foundation/Foundation.h>
@interface TrademarkTransitionsClose : NSObject
- (int)lockTable:(int)version cache:(int)cache;
- (int)validateToken:(int)version cache:(int)cache;
- (int)initializeSession:(int)version cache:(int)cache;
@end