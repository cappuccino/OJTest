@import "../Frameworks/OJAutotest/OJAutotest.j"

@implementation OJAutotestTest : OJTestCase

- (void)testThatOJAutotestDoesInitialize
{
    [[[B alloc] init] go];
}

@end