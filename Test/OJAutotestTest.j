@import "../Frameworks/OJAutotest/OJAutotest.j"
@import <OJMoq/OJMoq.j>

var OS = require("os");
var FSEVENTS = require("fsevents");
var FILE = require("file");

var oldSystem = OS.system;
var oldWatch = FSEVENTS.watch;

@implementation OJAutotestTest : OJTestCase

- (void)setUp
{
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
    var autotest = [[OJAutotest alloc] init];
    [self assertNotNull:autotest];
}

- (void)testThatOJAutotestDoesStartWithWatchedLocationTest
{
    var watchingTest = NO;
    FSEVENTS.watch = function(locationsToWatch, callback) {
        if(locationsToWatch[0] === "Test") {
            watchingTest = YES;
        }
    };
    
    var autotest = [OJAutotest startWithWatchedLocations:["Test"]];
    
    [self assertTrue:watchingTest];
}

- (void)testThatOJAutotestDoesStartWithWatchedLocationTestAndLib
{
    var watchingTest = NO;
    FSEVENTS.watch = function(locationsToWatch, callback) {
        if(locationsToWatch[0] === "Test" && locationsToWatch[1] === "lib") {
            watchingTest = YES;
        }
    };

    var autotest = [OJAutotest startWithWatchedLocations:["Test", "lib"]];

    [self assertTrue:watchingTest];   
}

- (void)testThatOJAutotestDoesReturnCorrectFiles
{
    var autotest = [OJAutotest startWithWatchedLocations:["Test"]];
    
    [self assert:[autotest files] contains:"Test/OJAutotestTest.j"];
    [self assert:[autotest files] contains:"Test/OJMoqSelectorTest.j"];
    [self assert:[autotest files] contains:"Test/OJMoqTest.j"];
    [self assert:[autotest files] contains:"Test/OJTestCaseTest.j"];
}

- (void)testThatOJAutotestDoesIdentifyTests
{
    var autotest = [[OJAutotest alloc] init];
    
    [self assertTrue:[autotest isTest:@"OneTest.j"]];
}

- (void)testThatOJAutotestDoesDetectFileHasBeenModified
{
    var autotest = [[OJAutotest alloc] init];
    
    [self createFiles:["Test/OneTest.j"] andRun:function(){
        [self assertTrue:[autotest testHasBeenModified:@"Test/OneTest.j"]];        
    }];
}

- (void)testThatOJAutotestDoesIdentifyNonTests
{
    var autotest = [[OJAutotest alloc] init];
    
    [self assertFalse:[autotest isTest:@"One.j"]];
}


- (void)testThatOJAutotestDoesGetTestFileForFile
{
    var autotest = [[OJAutotest alloc] init];
    
    var expectedOutput = FILE.absolute("Test/OJAutotestTest.j");
    var input = FILE.absolute("Frameworks/OJAutotest/OJAutotest.j");
    
    [self assert:expectedOutput equals:[autotest testForFile:input]];
}


- (void)testThatOJAutotestDoesDoesReturnFalseIfTestDoesNotExistWhenCheckingModification
{
    var autotest = [[OJAutotest alloc] init];
    
    [self assertFalse:[autotest testHasBeenModified:@"DoesNotExist.j"]];
}


- (void)testThatOJAutotestDoesDetectThatTestForFileHasBeenModified
{
    var autotest = [[OJAutotest alloc] init];
    
    [self createFiles:["Test/OneTest.j", "One.j"] andRun:function(){
        [self assertTrue:[autotest testForFileHasBeenModified:FILE.absolute("One.j")]];
    }];
}

- (void)testThatOJAutotestDoesReturnTheTestsOfFiles
{
    var autotest = [[OJAutotest alloc] init];
    
    [self createFiles:["Test/OneTest.j", "Two.j", "Test/TwoTest.j"] andRun:function(){
        var output = [autotest testsOfFiles:["Test/OneTest.j", "Two.j"]];
        [self assert:["Test/OneTest.j", "Test/TwoTest.j"].map(function(str){return FILE.absolute(str);}) equals:output];
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
        [self fail:@"The array <"+array+"> did not contain the object <"+[anObject description]+">"];
    }
}

@end