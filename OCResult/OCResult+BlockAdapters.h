#import "OCResult.h"


/*!
 @category OCResult (BlockAdapters)
 @abstract Helper methods to adapt the code using completion blocks to OCResult.
 @discussion Use the methods of this helper to pass OCResult objects to blocks that expect plain value/error parameters.
 */
@interface OCResult (BlockAdapters)

/*!
 Calls the given block passing the contained value or error (depending on the result kind)
 and nil as the other expected parameter.
 Use this when you have an OCResult, and need to return it to the caller by such completion block.
 */
- (void)performBlock:(void (^ _Nonnull NS_NOESCAPE)(id _Nullable value, NSError * _Nullable error))block;

/*!
 Calls one of the given blocks passing the contained value or error (depending on the result kind).
 Use this when you have an OCResult, and need to return it to the caller by such completion blocks.
 */
- (void)performSuccessBlock:(void (^ _Nonnull NS_NOESCAPE)(id _Nonnull value))successBlock
             orFailureBlock:(void (^ _Nonnull NS_NOESCAPE)(NSError * _Nonnull error))failureBlock;

/*!
 Creates a block that can accept an OCResult
 and pass its contents to the given block with separate value and error parameters.
 wrapBlock: is similar to performBlock:, but instead of calling the block immediately,
 it lets you call it manually later.
 Use it when you have a completion block with value and error parameters,
 and you need to call an API that is sending back an OCResult via its completion block.
 */
+ (void (^ _Nonnull)(OCResult * _Nonnull result))wrapBlock:(void (^ _Nonnull)(id _Nullable value, NSError * _Nullable error))block;

@end
