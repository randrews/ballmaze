//
//  LuaManager.m
//  Ballmaze
//
//  Created by Ross Andrews on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "LuaManager.h"

static const luaL_reg LM_FNS[] = {
    {"post_notification", lm_post_notification},
    {"observe_notification", lm_observe_notification},
    {NULL, NULL}
};

@implementation LuaManager

@synthesize initial_file;

- (id)init
{
    self = [super init];
    if (self) {
        lua = lua_open();
        luaL_openlibs(lua);
        luaL_openlib(lua, "LM", LM_FNS, 0);

        lua_pushstring(lua, "manager");
        lua_pushlightuserdata(lua, self);
        lua_settable(lua, LUA_REGISTRYINDEX);
        
        lua_pushstring(lua, "observers");
        lua_newtable(lua);
        lua_settable(lua, LUA_REGISTRYINDEX);
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void) awakeFromNib {
    if(initial_file) {
        [self runFile:initial_file];
    }
}

-(void) runFile: (NSString*) file {
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"lua"];
	NSString *code = [NSString stringWithFormat: @"dofile(\"%@\")", path];
	[self runLuaCode: [code UTF8String]];	
}

-(BOOL) runLuaCode: (const char*) code {
	int lua_error = luaL_loadbuffer(lua, code, strlen(code), "line") || lua_pcall(lua, 0, 0, 0);
	
	if(lua_error){ [self logLuaError]; }
	return !lua_error;
}

-(void) logLuaError {
	NSString *msg = [NSString stringWithFormat: @"%s\n", lua_tostring(lua, -1)];
	NSLog(@"%@", msg);
	lua_pop(lua, 1);
}

-(void) pushDictionary: (NSDictionary*) dict {
    lua_newtable(lua);
    
    if(!dict) {return;}
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop){
        const char *key_str = [key UTF8String];
        lua_pushstring(lua, key_str);
        
        if([value isKindOfClass:[NSNumber class]]){
            lua_pushnumber(lua, [value doubleValue]);
        } else {
            lua_pushstring(lua, [value UTF8String]);
        }
        
        lua_settable(lua, -3);
    }];
}

-(NSDictionary*) dictFromIndex: (int) index {
    if(!lua_istable(lua, index)){
        luaL_error(lua, "Expected a table");
    }

    NSDictionary *dict = [NSMutableDictionary dictionary];
    
    lua_pushnil(lua);
    while(lua_next(lua, index)){
        if(!lua_isstring(lua, -2)){
            luaL_error(lua, "Sorry, only string keys are supported yet");
        }
        
        NSString *key = [NSString stringWithUTF8String:luaL_checkstring(lua, -2)];
        
        if(lua_isstring(lua, -1)) {
            [dict setValue:[NSString stringWithUTF8String:luaL_checkstring(lua, -1)]
                    forKey:key];
        } else if(lua_isnumber(lua, -1)) {
            [dict setValue:[NSNumber numberWithDouble:luaL_checknumber(lua, -1)]
                    forKey:key];
        }
        
        lua_pop(lua, 1);
    }
    
    return dict;
}

-(void) heardNotification: (NSNotification*) notification {
    const char *name = [[notification name] UTF8String];
    
    lua_pushstring(lua, "observers");
    lua_gettable(lua, LUA_REGISTRYINDEX);
    
    lua_pushstring(lua, name);
    lua_gettable(lua, -2);
    
    [self pushDictionary:[notification userInfo]];
    lua_pcall(lua, 1,0,0);
}

@end

int lm_post_notification(lua_State *lua) {
    lua_pushstring(lua, "manager");
    lua_gettable(lua, LUA_REGISTRYINDEX);
    LuaManager *manager = lua_touserdata(lua, -1);

    id center = [NSNotificationCenter defaultCenter];
    const char *name = luaL_checkstring(lua, 1);

    NSDictionary *userinfo = [manager dictFromIndex:2];
    
    [center postNotificationName:[NSString stringWithUTF8String:name]
                          object:nil
                        userInfo:userinfo];

    return 0;
}

int lm_observe_notification(lua_State *lua) {
    // Adding the observer fn to the table
    // First we get the table of observers
    lua_pushstring(lua, "observers");
    lua_gettable(lua, LUA_REGISTRYINDEX);
    
    // Then get the name to observe
    const char *name = luaL_checkstring(lua, 1);
    
    // Push the name
    lua_pushstring(lua, name);

    // Then the function itself
    if(!lua_isfunction(lua, 2)){
        return luaL_error(lua, "Expected a function as the second argument");
    }
    lua_pushvalue(lua, 2);
        
    // Set the value in the table
    lua_settable(lua, -3);
    
    // Get out the LuaManager instance
    lua_pushstring(lua, "manager");
    lua_gettable(lua, LUA_REGISTRYINDEX);
    LuaManager *manager = lua_touserdata(lua, -1);

    // Actually set up the observation
    id center = [NSNotificationCenter defaultCenter];
    [center addObserver:manager
               selector:@selector(heardNotification:)
                   name:[NSString stringWithUTF8String:name]
                 object:nil];

    return 0;
}