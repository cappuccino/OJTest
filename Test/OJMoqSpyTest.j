@import "../Frameworks/OJMoq/OJMoqSpy.j"
@import <OJSpec/OJSpec.j>

@implementation OJMoqSpyTest : OJTestCase

- (void)testThatOJMoqSpyDoesInitialize
{
	[[OJMoqSpy spyOnBaseObject:@"TEST"] shouldNotBeNil];
}

@end