//
//  LuaManager.h
//  Ballmaze
//
//  Created by Ross Andrews on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

int lm_post_notification(lua_State *lua);
int lm_observe_notification(lua_State *lua);

@interface LuaManager : NSObject {
@private
    lua_State *lua;
    NSString *initial_file;
}

@property (copy) IBOutlet NSString *initial_file;

-(BOOL) runLuaCode: (const char*) code;
-(void) runFile: (NSString*) file;
-(void) logLuaError;

@end
