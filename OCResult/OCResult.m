#import "OCResult.h"

@implementation OCResult {
    id _value;
    NSError *_error;
}

- (instancetype)initWithValue:(id)value {
    self = [super init];
    if (self) {
        _kind = OCResultSuccess;
        _value = value;
    }
    return self;
}

- (instancetype)initWithError:(NSError *)error {
    self = [super init];
    if (self) {
        _kind = OCResultFailure;
        _error = error;
    }
    return self;
}

+ (OCResult *)success:(id)value {
    return [[OCResult alloc] initWithValue:value];
}

+ (OCResult *)failure:(NSError *)error {
    return [[OCResult alloc] initWithError:error];
}

- (id)value {
    NSAssert(_kind == OCResultSuccess, @"Not a success. Check the result kind. Contains an error: %@", _error);
    return _value;
}

- (NSError *)error {
    NSAssert(_kind == OCResultFailure, @"Not a failure. Check the result kind.");
    return _error;
}

- (OCResult *)map:(id (^)(id value))transform {
    NSParameterAssert(transform);
    switch (_kind) {
        case OCResultSuccess:
            return [OCResult success:transform(_value)];
        case OCResultFailure:
            return self;
    }
}

- (OCResult *)mapError:(NSError *(^)(NSError *error))transform {
    NSParameterAssert(transform);
    switch (_kind) {
        case OCResultSuccess:
            return self;
        case OCResultFailure:
            return [OCResult failure:transform(_error)];
    }
}

//- (NSUInteger)hash {
//    // TODO
//}
//
//- (BOOL)isEqual:(id)object {
//    // TODO
//}

@end
