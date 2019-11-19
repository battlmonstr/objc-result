#import <XCTest/XCTest.h>
#import "OCResult.h"
#import "OCResult+BlockAdapters.h"

@interface Tests : XCTestCase
@end

@implementation Tests

- (void)test_initializer_of_success {
    NSString *value = @"hello";
    OCResult *result = [OCResult success:value];
    XCTAssertEqual(result.kind, OCResultSuccess);
    XCTAssertEqual(result.value, value);
}

- (void)test_initializer_of_failure {
    NSError *error = [NSError errorWithDomain:@"example.com" code:1 userInfo:nil];
    OCResult *result = [OCResult failure:error];
    XCTAssertEqual(result.kind, OCResultFailure);
    XCTAssertEqual(result.error, error);
}

- (void)test_map_of_success {
    OCResult *result1 = [OCResult success:@"hello1"];
    OCResult *result2 = [result1 map:^(id value) {
        XCTAssertEqualObjects(value, @"hello1");
        return @"hello2";
    }];
    XCTAssertEqual(result2.kind, OCResultSuccess);
    XCTAssertEqualObjects(result2.value, @"hello2");
}

- (void)test_map_of_failure {
    NSError *error = [NSError errorWithDomain:@"example.com" code:1 userInfo:nil];
    OCResult *result1 = [OCResult failure:error];
    OCResult *result2 = [result1 map:^(id value) {
        XCTFail(@"The success value transform must not be called on a failure result.");
        return @"hello";
    }];
    XCTAssertEqual(result2.kind, OCResultFailure);
    XCTAssertEqualObjects(result2.error, error);
}

- (void)test_map_error_of_success {
    OCResult *result1 = [OCResult success:@"hello"];
    OCResult *result2 = [result1 mapError:^(NSError *error) {
        XCTFail(@"The failure transform must not be called on a success result.");
        return error;
    }];
    XCTAssertEqual(result2.kind, OCResultSuccess);
    XCTAssertEqualObjects(result2.value, @"hello");
}

- (void)test_map_error_of_failure {
    NSError *error1 = [NSError errorWithDomain:@"example.com" code:1 userInfo:nil];
    OCResult *result1 = [OCResult failure:error1];
    NSError *error2 = [NSError errorWithDomain:@"example.com" code:2 userInfo:nil];
    OCResult *result2 = [result1 mapError:^(NSError *error) {
        XCTAssertEqual(error, error1);
        return error2;
    }];
    XCTAssertEqual(result2.kind, OCResultFailure);
    XCTAssertEqual(result2.error, error2);
}

- (void)test_flat_map_of_success {
    OCResult *expectedResult = [OCResult success:@"hello2"];
    OCResult *result1 = [OCResult success:@"hello1"];
    OCResult *result2 = [result1 flatMap:^(id value) {
        XCTAssertEqualObjects(value, @"hello1");
        return expectedResult;
    }];
    XCTAssertEqual(result2, expectedResult);
}

- (void)test_flat_map_of_failure {
    NSError *error = [NSError errorWithDomain:@"example.com" code:1 userInfo:nil];
    OCResult *result1 = [OCResult failure:error];
    OCResult *result2 = [result1 flatMap:^(id value) {
        XCTFail(@"The success value transform must not be called on a failure result.");
        return [OCResult success:@"hello"];
    }];
    XCTAssertEqual(result2, result1);
}

- (void)test_flat_map_error_of_success {
    OCResult *result1 = [OCResult success:@"hello1"];
    OCResult *result2 = [result1 flatMapError:^(NSError *error) {
        XCTFail(@"The failure transform must not be called on a success result.");
        return [OCResult success:@"hello2"];
    }];
    XCTAssertEqual(result2, result1);
}

- (void)test_flat_map_error_of_failure {
    OCResult *expectedResult = [OCResult success:@"hello"];
    NSError *error1 = [NSError errorWithDomain:@"example.com" code:1 userInfo:nil];
    OCResult *result1 = [OCResult failure:error1];
    OCResult *result2 = [result1 flatMapError:^(NSError *error) {
        XCTAssertEqual(error, error1);
        return expectedResult;
    }];
    XCTAssertEqual(result2, expectedResult);
}

- (void)test_not_equal_to_nil {
    OCResult *result = [OCResult success:@"hello"];
    XCTAssertFalse([result isEqual:nil]);
}

- (void)test_not_equal_to_string {
    OCResult *result = [OCResult success:@"hello"];
    XCTAssertNotEqualObjects(result, @"hello");
}

- (void)test_success_not_equal_to_failure {
    OCResult *success = [OCResult success:@"hello"];
    NSError *error = [NSError errorWithDomain:@"example.com" code:1 userInfo:nil];
    OCResult *failure = [OCResult failure:error];
    XCTAssertNotEqualObjects(success, failure);
    XCTAssertNotEqualObjects(failure, success);
}

- (void)test_equal_successes {
    OCResult *result1 = [OCResult success:@"hello"];
    OCResult *result2 = [OCResult success:@"hello"];
    XCTAssertEqualObjects(result1, result2);
}

- (void)test_not_equal_successes {
    OCResult *result1 = [OCResult success:@"hello1"];
    OCResult *result2 = [OCResult success:@"hello2"];
    XCTAssertNotEqualObjects(result1, result2);
}

- (void)test_equal_failures {
    NSError *error = [NSError errorWithDomain:@"example.com" code:1 userInfo:nil];
    OCResult *result1 = [OCResult failure:error];
    OCResult *result2 = [OCResult failure:error];
    XCTAssertEqualObjects(result1, result2);
}

- (void)test_not_equal_failures {
    NSError *error1 = [NSError errorWithDomain:@"example.com" code:1 userInfo:nil];
    NSError *error2 = [NSError errorWithDomain:@"example.com" code:2 userInfo:nil];
    OCResult *result1 = [OCResult failure:error1];
    OCResult *result2 = [OCResult failure:error2];
    XCTAssertNotEqualObjects(result1, result2);
}

- (void)test_hash_of_success {
    NSString *value = @"hello";
    OCResult *result = [OCResult success:value];
    XCTAssertEqual([result hash], [value hash]);
}

- (void)test_hash_of_failure {
    NSError *error = [NSError errorWithDomain:@"example.com" code:1 userInfo:nil];
    OCResult *result = [OCResult failure:error];
    XCTAssertEqual([result hash], [error hash]);
}

- (void)test_perform_block_of_success {
    NSString *expectedValue = @"hello";
    OCResult *result = [OCResult success:expectedValue];
    [result performBlock:^(id value, NSError *error) {
        XCTAssertEqual(value, expectedValue);
        XCTAssertNil(error);
    }];
}

- (void)test_perform_block_of_failure {
    NSError *expectedError = [NSError errorWithDomain:@"example.com" code:1 userInfo:nil];
    OCResult *result = [OCResult failure:expectedError];
    [result performBlock:^(id value, NSError *error) {
        XCTAssertNil(value);
        XCTAssertEqual(error, expectedError);
    }];
}

- (void)test_perform_success_block_of_success {
    NSString *expectedValue = @"hello";
    OCResult *result = [OCResult success:expectedValue];
    __block id actualValue = nil;
    [result performSuccessBlock:^(id value) { actualValue = value; }
                 orFailureBlock:^(NSError *error) { XCTFail("The failure block must not be called on a success result."); }];
    XCTAssertEqual(actualValue, expectedValue);
}

- (void)test_perform_failure_block_of_failure {
    NSError *expectedError = [NSError errorWithDomain:@"example.com" code:1 userInfo:nil];
    OCResult *result = [OCResult failure:expectedError];
    __block NSError *actualError = nil;
    [result performSuccessBlock:^(id value) { XCTFail("The success block must not be called on a failure result."); }
                 orFailureBlock:^(NSError *error) { actualError = error; }];
    XCTAssertEqual(actualError, expectedError);
}

- (void)test_wrap_block_passes_success {
    NSString *expectedValue = @"hello";
    void (^resultBlock)(OCResult *result);
    __block id actualValue = nil;
    resultBlock = [OCResult wrapBlock:^(id value, NSError *error) {
        actualValue = value;
        XCTAssertNil(error);
    }];
    resultBlock([OCResult success:expectedValue]);
    XCTAssertEqual(actualValue, expectedValue);
}

- (void)test_wrap_block_passes_failure {
    NSError *expectedError = [NSError errorWithDomain:@"example.com" code:1 userInfo:nil];
    void (^resultBlock)(OCResult *result);
    __block NSError *actualError = nil;
    resultBlock = [OCResult wrapBlock:^(id value, NSError *error) {
        XCTAssertNil(value);
        actualError = error;
    }];
    resultBlock([OCResult failure:expectedError]);
    XCTAssertEqual(actualError, expectedError);
}

@end
