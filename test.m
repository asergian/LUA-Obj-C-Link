#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"
#import "LuaBridge/LuaBridge.h"
#import <Foundation/Foundation.h>
//#import <LuaCore/LuaCore.h>
//#import <LuaCocoa.h>
//#define TESTDIR @"/Volumes/srv/Users/gus/Projects/luacore/TestApp"



/*void runTest(NSString *testName) {
    NSLog(@"******* running %@", testName);
    
    //LCLua *lua = [LCLua readyLua];
    LCLua *lua = [[LCLua alloc] init];
    NSLog(@"******* done with %@", [lua state]);
    
    //[lua runFileAtPath:[TESTDIR stringByAppendingPathComponent:testName]];
    
    //[lua tearDown];
    
    NSLog(@"******* done with %@", testName);
}
*/


int main(int argc, const char * argv[]) {
	lua_State *L = [[LuaBridge instance] L];
	[(id) L dostring:@"yes"];

/*	int return_variable = 0;
	LuaCocoa* lua = nil;
	lua = [lua init];
	const char * functionName = "testFunction";
	NSLog(@"Returned thing: %@", [lua luaState]);

	[lua pcallLuaFunction:functionName];

	NSLog(@"Returned thing: %i", return_variable);*/


/*
	NSLog(@"Hello, World! \n");

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    runTest(@"testscript01.lua");

    [pool release];*/

	return 0;
}