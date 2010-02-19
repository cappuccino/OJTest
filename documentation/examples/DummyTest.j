
// NOTE: class name must be the same as the file name (without .j extension)

@implementation DummyTest : OJTestCase

// this should pass
- (void)testOneEqualsOne
{
    [self assert:1 equals:1];
}

// this should fail
- (void)testOneEqualsTwo
{
    [self assert:1 equals:0];
}

@end
