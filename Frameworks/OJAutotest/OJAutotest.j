@import <Foundation/Foundation.j>

var OS = require("os");
var FILE = require("file");
var FSEVENTS = require("fsevents");

var OJAUTOTEST_RUNNER = "ojautotest-run";

/*!
   A test runner that automatically detects changes and runs relevant tests. In order to use this,
   you should be using the ojautotest script located at $NARWHAL_HOME/bin/ojautotest.
 */
@implementation OJAutotest : CPObject
{
    CPArray         watchLocations        @accessors;
    CPArray         testsAlreadyRun;
    CPDate          lastRunTime;
    BOOL            isDirty;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        isDirty = NO;
        watchLocations = [CPArray array];
        testsAlreadyRun = [CPArray array];
    }
    return self;
}

- (void)start
{
    print("---------- STARTING LOOP ----------");
    print("In order to stop the tests, do Control-C twice in quick succession.");
    [self loop];
}

- (void)loop
{
    var runTests = function() {
        [self runTests];
        print("---------- WAITING FOR CHANGES ----------");
    };
    
    var callback = function() {
        print("----------  CHANGES  DETECTED  ----------");
        runTests();
    };
    
    runTests();
    FSEVENTS.watch(watchLocations, callback);
}

- (void)runTests
{
    var tests = [self testsOfFiles:[self files]];
    var runnerResult = OS.system([OJAUTOTEST_RUNNER, isDirty].concat(tests));

    if(runnerResult == 0)
    {
        [self runDirtyTests];
    }
    else
    {
        isDirty = YES;
    }

    [self testsWereRun];
}

- (void)runDirtyTests
{
    var tests = [self testsOfFiles:[self files]];
    if(isDirty)
    {
        isDirty = NO;
        var allTestRun = OS.system([OJAUTOTEST_RUNNER, isDirty].concat(tests));
        
        if(allTestRun !== 0)
        {
            isDirty = YES;
        }
    }
}

- (CPArray)files
{
    var result = [];
    
    for(var i = 0; i < [watchLocations count]; i++)
    {
        var items = new (require("jake").FileList)(watchLocations[i] + "/*.j").items();
        
        for(var j = 0; j < [items count]; j++)
            result.push( items[j] );
    }
    
    return result;
}

- (void)testsWereRun
{
    lastRunTime = [CPDate dateWithTimeIntervalSinceNow:0];
}

- (CPString)testsOfFiles:(CPArray)files
{
    var result = [CPArray array];
    
    for(var i = 0; i < [files count]; i++)
    {
        var nextFile = FILE.absolute([files objectAtIndex:i]);
    
        if([self isTest:nextFile] && [self testHasBeenModified:nextFile] && ![result containsObject:nextFile])
            [result addObject:nextFile];
        else if(![self isTest:nextFile] && [self testForFileHasBeenModified:nextFile] && ![result containsObject:[self testForFile:nextFile]])
            [result addObject:[self testForFile:nextFile]];
    }
    
    return result;
}

- (BOOL)isTest:(CPString)fileName
{
    return [fileName hasSuffix:@"Test.j"];
}

- (BOOL)testForFileHasBeenModified:(CPString)file
{
    return FILE.isFile([self testForFile:file]) && [self testHasBeenModified:file];
}

- (CPString)testForFile:(CPString)file
{
    return FILE.absolute("Test/"+[[file lastPathComponent] substringToIndex:[[file lastPathComponent] length]-2]+"Test.j");
}

- (BOOL)testHasBeenModified:(CPString)test
{
    if(FILE.isFile(test))
    {
        var lastModification = FILE.mtime(test);
        return [lastModification compare:lastRunTime] > 0;
    }
    
    return NO;
}

@end