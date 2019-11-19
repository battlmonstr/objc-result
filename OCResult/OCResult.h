#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OCResultKind) {
    OCResultSuccess,
    OCResultFailure,
};


@interface OCResult : NSObject

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

+ (nonnull OCResult *)success:(nonnull id)value;
+ (nonnull OCResult *)failure:(nonnull NSError *)error;

@property (readonly) OCResultKind kind;
@property (readonly, nonnull) id value;
@property (readonly, nonnull) NSError *error;

- (nonnull OCResult *)map:(id _Nonnull (^ _Nonnull NS_NOESCAPE)(id _Nonnull value))transform;
- (nonnull OCResult *)mapError:(NSError * _Nonnull (^ _Nonnull NS_NOESCAPE)(NSError * _Nonnull error))transform;

- (nonnull OCResult *)flatMap:(OCResult * _Nonnull (^ _Nonnull NS_NOESCAPE)(id _Nonnull value))transform;
- (nonnull OCResult *)flatMapError:(OCResult * _Nonnull (^ _Nonnull NS_NOESCAPE)(NSError * _Nonnull error))transform;

@end
