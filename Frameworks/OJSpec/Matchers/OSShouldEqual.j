
@import "../OSMatcher.j"

@implementation OSShouldEqual : OSMatcher
{
}

@end

/**
 * Checks if two objects has the same value.
 *
@implementation CPObject (ShouldEqualMatcher)

- (void)shouldEqual:(id)expected
{
    if(![[[OSShouldEqual alloc] initWithExpected:expected] matches:self])
        throw SpecFailedException;
}

- (void)shouldNotEqual:(id)expected
{
    if([[[OSShouldEqual alloc] initWithExpected:expected] matches:self])
        throw SpecFailedException;
}

@end*/

[CPObject registerMatcher:OSShouldEqual];
