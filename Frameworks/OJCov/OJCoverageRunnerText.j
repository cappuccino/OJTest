@import <OJUnit/OJTestRunnerText.j>

@implementation OJCoverageRunnerText : OJTestRunnerText
{
    OJCoverageListener      covListener;
    OJCoverageReporter      covReporter;
}

- (void)init
{
    self = [super init];
    if(self)
    {
        covListener = [[OJCoverageListener alloc] init];
        covReporter = [[OJCoverageReporter alloc] init];
        [covListener setDelegate:covReporter];
    }
    return self;
}

- (void)beforeRequire
{
    [covListener start];
}

- (void)afterRun
{
    [covListener stop];
}

- (void)report
{
    [covReporter report];
    [super report];
}


@end
