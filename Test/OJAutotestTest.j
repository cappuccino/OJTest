@import "../Frameworks/OJAutotest/OJAutotest.j"
@import <OJMoq/OJMoq.j>

var OS = require("os");
var FSEVENTS = require("fsevents");
var FILE = require("file");

var oldSystem = OS.system;
var oldWatch = FSEVENTS.watch;

@implementation OJAutotestTest : OJTestCase
{
    OJAutotest      target;
}

- (void)setUp
{
    target = [[OJAutotest alloc] init];
    [target setWatchLocations:["Test"]];
    OS.system = function(){return moq();};
    FSEVENTS.watch = function(){return moq();};
}

- (void)tearDown
{
    OS.system = oldSystem;
    FSEVENTS.watch = oldWatch;
}

- (void)testThatOJAutotestDoesInitialize
{
    [OJAssert assertNotNull:target];
}

- (void)testThatOJAutotestDoesStartWithWatchedLocationTest
{
    var watchingTest = NO;
    FSEVENTS.watch = function(locationsToWatch, callback) {
        if(locationsToWatch[0] === "Test") {
            watchingTest = YES;
        }
    };

    [target start];

    [OJAssert assertTrue:watchingTest];
}

- (void)testThatOJAutotestDoesStartWithWatchedLocationTestAndLib
{
    var watchingTest = NO;
    FSEVENTS.watch = function(locationsToWatch, callback) {
        if(locationsToWatch[0] === "Test" && locationsToWatch[1] === "lib") {
            watchingTest = YES;
        }
    };

    [target setWatchLocations:["Test", "lib"]];
    [target start];

    [OJAssert assertTrue:watchingTest];
}

- (void)testThatOJAutotestDoesIdentifyTests
{
    [OJAssert assertTrue:[target isTest:@"OneTest.j"]];
}

- (void)testThatOJAutotestDoesIdentifyNonTests
{
    [OJAssert assertFalse:[target isTest:@"One.j"]];
}

- (void)testThatOJAutotestDoesGetTestFileForFile
{
    var expectedOutput = FILE.absolute("Test/OJAutotestTest.j");
    var input = FILE.absolute("Frameworks/OJAutotest/OJAutotest.j");

    [OJAssert assert:expectedOutput equals:[target testForFile:input]];
}

- (void)testThatOJAutotestDoesReturnTheTestsOfFiles
{
    [self createFiles:["Test/OneTest.j", "Two.j", "Test/TwoTest.j"] andRun:function(){
        var output = [target testsForFiles:["Test/OneTest.j", "Two.j"]];
        [OJAssert assert:["Test/OneTest.j", "Test/TwoTest.j"].map(function(str){return FILE.absolute(str);}) equals:output];
    }];
}

- (void)createFiles:(CPArray)fileList andRun:(Function)someFunction
{
    for(var i = 0; i < [fileList count]; i++)
    {
        FILE.write(fileList[i], "");
    }

    try
    {
        someFunction();
    }
    finally
    {
        for(var i = 0; i < [fileList count]; i++)
        {
            FILE.remove(fileList[i]);
        }
    }
}

- (void)assert:(CPArray)array contains:(CPObject)anObject
{
    if(![array containsObject:anObject])
    {
        [OJAssert fail:@"The array <"+array+"> did not contain the object <"+[anObject description]+">"];
    }
}

@end
