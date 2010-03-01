@import "../Frameworks/OJAutotest/OJAutotest.j"

@implementation OJAutotestTest : OJTestCase

- (void)testThatOJAutotestDoesInitialize
{
    var autotest = [[OJAutotest alloc] init];
    [self assertNotNull:autotest];
}

@end