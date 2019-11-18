#import "OCResult+BlockAdapters.h"

@implementation OCResult (BlockAdapters)

- (void)performBlock:(void (^ NS_NOESCAPE)(id value, NSError *error))block {
    NSParameterAssert(block);
    switch (self.kind) {
        case OCResultSuccess:
            block(self.value, nil);
            break;
        case OCResultFailure:
            block(nil, self.error);
            break;
    }
}

- (void)performSuccessBlock:(void (^ NS_NOESCAPE)(id value))successBlock
             orFailureBlock:(void (^ NS_NOESCAPE)(NSError *error))failureBlock
{
    NSParameterAssert(successBlock);
    NSParameterAssert(failureBlock);
    switch (self.kind) {
        case OCResultSuccess:
            successBlock(self.value);
            break;
        case OCResultFailure:
            failureBlock(self.error);
            break;
    }
}

+ (void (^)(OCResult *result))wrapBlock:(void (^)(id value, NSError *error))block {
    NSParameterAssert(block);
    return ^(OCResult *result) {
        [result performBlock:block];
    };
}

@end
