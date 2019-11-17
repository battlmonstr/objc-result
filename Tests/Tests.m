#import <XCTest/XCTest.h>
#import "OCResult.h"

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
        XCTAssertEqual(value, @"hello1");
        return @"hello2";
    }];
    XCTAssertEqual(result2.kind, OCResultSuccess);
    XCTAssertEqual(result2.value, @"hello2");
}

- (void)test_map_of_failure {
    NSError *error = [NSError errorWithDomain:@"example.com" code:1 userInfo:nil];
    OCResult *result1 = [OCResult failure:error];
    OCResult *result2 = [result1 map:^(id value) {
        XCTFail(@"The success value transform must not be called on a failure result.");
        return @"hello";
    }];
    XCTAssertEqual(result2.kind, OCResultFailure);
    XCTAssertEqual(result2.error, error);
}

- (void)test_map_error_of_success {
    OCResult *result1 = [OCResult success:@"hello"];
    OCResult *result2 = [result1 mapError:^(NSError *error) {
        XCTFail(@"The failure transform must not be called on a success result.");
        return error;
    }];
    XCTAssertEqual(result2.kind, OCResultSuccess);
    XCTAssertEqual(result2.value, @"hello");
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

@end
