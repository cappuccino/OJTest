@import "../Frameworks/OJSpec/OJSpec.j"

@implementation OJSpecMatchersTest : OJTestCase

- (void)testThatOJSpecShouldBeInstanceOfDoesntThrowException
{
    [OJAssert assertNoThrow:function() {
        [@"TEST" shouldBeInstanceOf:CPString];
    }];
}

- (void)testThatOJSpecShouldBeInstanceOfDoesThrowException
{
    [OJAssert assertThrows:function() {
        [@"TEST" shouldBeInstanceOf:CPArray];
    }];
}

- (void)testThatOJSpecShouldNotBeInstanceOfDoesntThrowException
{
    [OJAssert assertNoThrow:function() {
        [@"TEST" shouldNotBeInstanceOf:CPArray];
    }];
}

- (void)testThatOJSpecShouldNotBeInstanceOfDoesThrowException
{
    [OJAssert assertThrows:function() {
        [@"TEST" shouldNotBeInstanceOf:CPString];
    }];
}

- (void)testThatOJSpecShouldBeNilDoesThrowException
{
    [OJAssert assertThrows:function() {
        [@"" shouldBeNil];
    }];
}

- (void)testThatOJSpecShouldNotBeNilDoesntThrowException
{
    [OJAssert assertNoThrow:function() {
        [@"" shouldNotBeNil];
    }];
}
//
// - (void)testThatOJSpecShouldBeNilDoesntThrowException
// {
//  [OJAssert assertNoThrow:function() {
//      [nil shouldBeNil];
//  }];
// }
//
// - (void)testThatOJSpecShouldNotBeNilDoesThrowException
// {
//  [OJAssert assertThrows:function() {
//      [nil shouldNotBeNil];
//  }];
// }

- (void)testThatOJSpecShouldBeSameAsDoesntThrowException
{
    [OJAssert assertNoThrow:function() {
        var target = @"TEST";
        [target shouldBeSameAs:target];
    }];
}

- (void)testThatOJSpecShouldBeSameAsDoesThrowException
{
    [OJAssert assertThrows:function() {
        [[[CPObject alloc] init] shouldBeSameAs:[[CPObject alloc] init]];
    }];
}

- (void)testThatOJSpecShouldNotBeSameAsDoesntThrowException
{
    [OJAssert assertNoThrow:function() {
        [[[CPObject alloc] init] shouldNotBeSameAs:[[CPObject alloc] init]];
    }];
}

- (void)testThatOJSpecShouldNotBeSameAsDoesThrowException
{
    [OJAssert assertThrows:function() {
        var target = [[CPObject alloc] init];
        [target shouldNotBeSameAs:target];
    }];
}

- (void)testThatOJSpecShouldBeEqualDoesntThrowException
{
    [OJAssert assertNoThrow:function() {
        var target = @"TEST";
        [target shouldEqual:target];
    }];
}

- (void)testThatOJSpecShouldBeEqualDoesThrowException
{
    [OJAssert assertThrows:function() {
        [[[CPObject alloc] init] shouldEqual:[[CPObject alloc] init]];
    }];
}

@end
