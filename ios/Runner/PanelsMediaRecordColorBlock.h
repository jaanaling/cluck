#import <Foundation/Foundation.h>
@interface PanelsMediaRecordColorBlock : NSObject
- (int)lockTable:(int)version cache:(int)cache;
- (int)validateToken:(int)version cache:(int)cache;
@end