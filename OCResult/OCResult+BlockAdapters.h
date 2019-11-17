#import "OCResult.h"


@interface OCResult (BlockAdapters)

- (void)performBlock:(void (^ _Nonnull)(id _Nullable value, NSError * _Nullable error))block;

- (void)performSuccessBlock:(void (^ _Nonnull)(id _Nonnull value))successBlock
             orFailureBlock:(void (^ _Nonnull)(NSError * _Nonnull error))failureBlock;

@end
