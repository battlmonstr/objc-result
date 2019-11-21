# OCResult - Objective-C "Result" type

![CI tests status](https://github.com/battlmonstr/objc-result/workflows/CI/badge.svg)

## Overview

Swift 5 standard library has a [`Result<Success, Failure>`][swift-result] enum type. The OCResult library implements the same concept for Objective-C code.

A _result_ object is a union of an operation result value or an error. One and only one thing is present at a time. You can create a result by using one of the static constructors:

    #import <OCResult/OCResult.h>

    OCResult *goodResult = [OCResult success:@"some value"];

    // or
    NSError *error = ...
    OCResult *badResult = [OCResult failure:error];

Keeping a result value together with a potential error helps to make sure that every error is either handled or passed along and not lost:

**Example 1: without OCResult**

    MyObj *obj = [MyParser parseData:data error:nil];
        // easy to ignore the error
    obj.created = [NSDate date];
        // easy to forget to check for validity
    return obj;
        // the error information is lost


**Example 1: improved with OCResult**

    OCResult *result = [MyParser parseData:data];
    result = [result map:^(MyObj *obj) {
        obj.created = [NSDate date];
            // this code runs only if there's no error
    }];
    return result;
        // a potential error is passed along

**Example 2: without OCResult**

    - (void)didParseMyObj:(MyObj *)obj error:(NSError *)error {
        [self.myView showMyObj:obj];
            // easy to forget to handle the error
    }

**Example 2: improved with OCResult**

    - (void)didParseResult:(OCResult *)result {
        // an exhaustive switch helps to cover the failure case
        switch (result.kind) {
            case OCResultSuccess:
                [self.myView showMyObj:result.value];
                break;
            case OCResultFailure:
                [self showError:result.error];
                break;
        }
    }

Using the `map`/`mapError` methods helps to avoid proliferation of "if not nil" checks in your code:

**Example 3: without OCResult**

    [MyParser asyncParseData:data 
                  completion:^(MyObj *obj, NSError *error) {
        if (!error) {
            completionBlock(obj, nil);
        } else {
            error = [NSError errorWithDomain:@"com.myapp" code:1 
                                    userInfo:@{ NSLocalizedDescriptionKey: @"Sorry!" }];
            completionBlock(nil, error);
        }
    }];


**Example 3: improved with OCResult**

    [MyParser asyncParseData:data
                  completion:^(OCResult *result) {
        result = [result mapError:^(NSError *error) {
            return [NSError errorWithDomain:@"com.myapp" code:1 
                                   userInfo:@{ NSLocalizedDescriptionKey: @"Sorry!" }];
        }];
        completionBlock(result);
    }];


## Installation

### From CocoaPods

Add the `OCResult` pod to your Podfile:

    target 'MyApp' do
      pod 'OCResult'
    end

Then run `pod install` inside your terminal, or from the `CocoaPods.app`.

Alternatively to give it a test run, run the command:

    pod try OCResult

### Manually

Copy the source code files from the OCResult directory:

* "OCResult.h" and "OCResult.m".
* "OCResult+BlockAdapters.h" and "OCResult+BlockAdapters.m" if you need to work with callbacks (see explanation below).
* "OCResult2Swift.swift" if you need to bridge with Swift (see explanation below); For this file to work you need to import "OCResult.h" from your own [Swift bridging header file](https://developer.apple.com/documentation/swift/imported_c_and_objective-c_apis/importing_objective-c_into_swift).
* Copy the "LICENSE.txt".

### License terms

The MIT license terms demand to add attribution somewhere inside your app. It is enough to add this text to your credits, licenses or "About" page within the app:

    OCResult
    Copyright (c) 2019 battlmonstr
    https://github.com/battlmonstr/objc-result

if the link is clickable, otherwise add the [full LICENSE.txt text](https://github.com/battlmonstr/objc-result/blob/master/LICENSE.txt).


## Working with callbacks

A typical asynchronous completion block has either 2 parameters to be used like so:

    [MyParser asyncParseData:data
                  completion:^(MyObj *obj, NSError *error) {
        ...
    }];

or you might have 2 blocks for each case each having a single parameter:

    [MyParser asyncParseData:data 
                   onSuccess:^(MyObj *obj) { ... }
                   onFailure:^(NSError *error) { ... }];

If you convert the code to use OCResult "inside-out", and you implement such a method, you can use `BlockAdapters` category:

    #import <OCResult/OCResult+BlockAdapters.h>

    ...
    [result performBlock:completion];
    // or
    [result performSuccessBlock:onSuccess
                 orFailureBlock:onFailure];

If your inner code is also asynchronous, and it already expects a completion with OCResult:

    [MyInternalParser asyncParseData:data
                          completion:^(OCResult *result) {
        ...
    }];

then you can adapt a given "old style" completion block using `wrapBlock`:

    [MyInternalParser asyncParseData:data
                          completion:[OCResult wrapBlock:completion]];


## Bridging with Swift

If your Swift code is already using the [`Result<Success, Failure>`][swift-result] enum type, you can use the "OCResult2Swift.swift" extension to bridge it with OCResult for Objective-C code:

    import OCResult

    let result1 = ...

    let ocResult = OCResult.make(fromSwiftResult: result1)
        // for passing into the Objective-C code

    let result2 = ocResult.toSwift()
        // for using in the Swift code

You can use [the `map` method](https://developer.apple.com/documentation/swift/result/3139400-map) to convert `Any` to a different `Success` type:

    let strResult = result2.map({ ($0 as? String) ?? "oops" })



[swift-result]: https://developer.apple.com/documentation/swift/result
