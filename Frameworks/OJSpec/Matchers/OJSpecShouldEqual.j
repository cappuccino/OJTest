@import "../OJSpecMatcher.j"

@implementation OJSpecShouldEqual : OJSpecMatcher

@end

/**
 * Checks if two objects has the same value.
 */
@implementation CPObject (ShouldEqualMatcher)

- (void)shouldEqual:(id)expected
{
    [[[OJSpecShouldEqual alloc] initWithExpected:expected] matches:self];
}

- (void)shouldNotEqual:(id)expected
{
    [[[OJSpecShouldEqual alloc] initWithExpected:expected] doesNotMatch:self];
}

@end
