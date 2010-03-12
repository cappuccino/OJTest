#include <CoreServices/CoreServices.h>
#import <Foundation/Foundation.h>

static void callback(ConstFSEventStreamRef streamRef,
					 void *clientCallBackInfo,
					 size_t numEvents,
					 void *eventPaths,
					 const FSEventStreamEventFlags eventFlags[],
					 const FSEventStreamEventId eventIds[]) {
	exit(0);
}

int main (int argc, const char * argv[]) {
	// Show help
	if (argc < 2 || strncmp(argv[1], "-h", 2) == 0) {
		printf("Sleep until a file in or below the watchdir is modified.\n");
		printf("Usage: fsevent_sleep /path/to/watchdir\n");
		exit(1);
	}
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CFAbsoluteTime latency = 1.0;
	NSArray *paths = [[NSProcessInfo processInfo] arguments];
    void *callbackInfo = NULL;
    FSEventStreamRef stream;
    stream = FSEventStreamCreate(
								 kCFAllocatorDefault,
								 callback,
								 callbackInfo,
								 (CFArrayRef)paths,
								 kFSEventStreamEventIdSinceNow,
								 latency,
								 kFSEventStreamCreateFlagNone
								 );
	
	// Add stream to run loop
    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	FSEventStreamStart(stream);
	CFRunLoopRun();
	
	[pool drain];
	// Exit
	return 2;
}