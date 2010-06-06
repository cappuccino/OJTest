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
    BOOL            isDirty;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        isDirty = NO;
        watchLocations = [CPArray array];
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
    var runTests = function(modifiedFiles) {
        var modifiedFilePaths = modifiedFiles.map(function(modifiedFile) {
            return modifiedFile.path;
        });
        
        [self runTests:[self testsForFiles:modifiedFilePaths]];

        print("---------- WAITING FOR CHANGES ----------");
    };
    
    var callback = function(modifiedFiles) {
        print("----------  CHANGES  DETECTED  ----------");
        runTests(modifiedFiles);
    };
    
    runTests([]);
    FSEVENTS.watch(watchLocations, callback);
}

- (void)runTests:(CPArray)tests
{
    var runnerResult = OS.system([OJAUTOTEST_RUNNER, isDirty].concat(tests));
    if(runnerResult === 0)
    {
        [self runDirtyTests:tests];
    }
    else
    {
        isDirty = YES;
    }
}

- (void)setFrameworksLocations:(CPArray)locations
{   
    OBJJ_INCLUDE_PATHS = (OBJJ_INCLUDE_PATHS || []).concat(locations);
}

- (void)runDirtyTests:(CPArray)tests
{
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

- (CPArray)testsForFiles:(CPArray)files
{
    var tests = [CPArray array];
    for(var i = 0; i < [files count]; i++)
    {
        var testForFile = [self testForFile:[files objectAtIndex:i]];
        if(FILE.exists(testForFile) && ![tests containsObject:testForFile])
        {
            [tests addObject:testForFile];
        }
        
    }
    return tests;
}

- (BOOL)isTest:(CPString)filePath
{
    return [filePath hasSuffix:@"Test.j"];
}

- (CPString)testForFile:(CPString)filePath
{
    if ([self isTest:filePath])
        return FILE.absolute(filePath);
    var fileName = [filePath lastPathComponent];
    var fileNameWithoutExtension = [fileName stringByReplacingOccurrencesOfString:(@"." + [filePath pathExtension]) withString:@""];
    var testName = "Test/"+fileNameWithoutExtension+"Test.j";
    
    // this is due to an error in v0.8.1. I'm leaving this here so that we
    // can add it back in when v0.8.1 is fixed.
    
    //var testName = [CPString stringWithFormat:@"%s/%s%s", @"Test", fileNameWithoutExtension, @"Test.j"];
    return FILE.absolute(testName);
}

@end