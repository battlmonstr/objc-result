#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OCResultKind) {
    /*! The result represents a success and holds a value. */
    OCResultSuccess,
    /*! The result represents a failure and holds an error. */
    OCResultFailure,
};


/*!
 @abstract OCResult holds either a value or an error.
 @discussion A result object is a union of an operation result or an error.
 One and only one thing is present at a time.
 It helps to avoid proliferation of "if not nil" checks in your code,
 because the result always is guaranteed to contain something.
 It also helps to make sure that every error is either handled
 or passed along and not lost.
 */
@interface OCResult : NSObject

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

/*! Constructs a result that holds a value. */
+ (nonnull OCResult *)success:(nonnull id)value;
/*! Constructs a result that holds an error. */
+ (nonnull OCResult *)failure:(nonnull NSError *)error;

/*!
 Either OCResultSuccess or OCResultFailure.
 It is recommended to use a switch statement on the kind before querying the value/error.
 */
@property (readonly) OCResultKind kind;
/*! A value contained in a success result. Asserts if it is a failure result. */
@property (readonly, nonnull) id value;
/*! An error contained in a failure result. Asserts if it is a success result. */
@property (readonly, nonnull) NSError *error;

/*!
 Replaces a success result value and wraps it inside a new success result object.
 A failure result is returned unchanged.
 @param transform A value mapping block that takes an existing result value and returns a new result value.
 */
- (nonnull OCResult *)map:(id _Nonnull (^ _Nonnull NS_NOESCAPE)(id _Nonnull value))transform;
/*!
 Replaces a failure result error and wraps it inside a new failure result object.
 A success result is returned unchanged.
 @param transform An error mapping block that takes an existing result error and returns a new result error.
 */
- (nonnull OCResult *)mapError:(NSError * _Nonnull (^ _Nonnull NS_NOESCAPE)(NSError * _Nonnull error))transform;

/*!
 Provides a new result based on the original success result value.
 A failure result is returned unchanged.
 @param transform A constructor block that takes an existing result value and produces a new result object of any kind.
 */
- (nonnull OCResult *)flatMap:(OCResult * _Nonnull (^ _Nonnull NS_NOESCAPE)(id _Nonnull value))transform;
/*!
 Provides a new result based on the original failure result error.
 A success result is returned unchanged.
 @param transform A constructor block that takes an existing result error and produces a new result object of any kind.
 */
- (nonnull OCResult *)flatMapError:(OCResult * _Nonnull (^ _Nonnull NS_NOESCAPE)(NSError * _Nonnull error))transform;

@end
