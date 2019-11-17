#import "OCResult.h"


@interface OCResult (BlockAdapters)

- (void)performBlock:(void (^ _Nonnull NS_NOESCAPE)(id _Nullable value, NSError * _Nullable error))block;

- (void)performSuccessBlock:(void (^ _Nonnull NS_NOESCAPE)(id _Nonnull value))successBlock
             orFailureBlock:(void (^ _Nonnull NS_NOESCAPE)(NSError * _Nonnull error))failureBlock;

@end
