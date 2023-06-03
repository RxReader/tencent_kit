#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@import tencent_kit;

// This demonstrates a simple unit test of the Objective-C portion of this plugin's implementation.
//
// See https://developer.apple.com/documentation/xctest for more information about using XCTest.

@interface RunnerTests : XCTestCase

@end

@implementation RunnerTests

- (void)testExample {
  TencentKitPlugin *plugin = [[TencentKitPlugin alloc] init];

  FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"isQQInstalled"
                                                              arguments:nil];
  XCTestExpectation *expectation = [self expectationWithDescription:@"result block must be called"];
  [plugin handleMethodCall:call
                    result:^(id result) {
                      NSNumber *expected = [NSNumber numberWithBool:NO];
                      XCTAssertEqualObjects(result, expected);
                      [expectation fulfill];
                    }];
  [self waitForExpectationsWithTimeout:1 handler:nil];
}

@end
