--- Provides EmmyLua Definitions for the libraries used!

--------------------------------------------------
--- RODUX (v3.0.0, April 2022)
--------------------------------------------------

---@class RoduxAction
---@field type RoduxActionType
---@field data table

---@class RoduxActionType:string
---@class RoduxState
---@class RoduxNextDispatchResult

---@alias RoduxReducer fun(state:RoduxState, action:RoduxAction):RoduxState
---@alias RoduxActionHandler fun(state:RoduxState, action:RoduxAction)
---@alias RoduxActionCreator fun(...):RoduxAction
---@alias RoduxMiddleware fun(nextDispatch:RoduxNextDispatch, store:RoduxStore):fun(action:RoduxAction):RoduxNextDispatchResult A middleware is a function that accepts the next dispatch function in the middleware chain, as well as the store the middleware is being used with, and returns a new function. That function is called whenever an action is dispatched and can dispatch more actions, log to output, or perform any other side effects! https://roblox.github.io/rodux/api-reference/#middleware
---@alias RoduxNextDispatch fun(action:RoduxAction):RoduxNextDispatchResult

---@class Rodux
---@field Store RoduxStore
---@field createReducer fun(initialState:RoduxState, actionHandlers:table<RoduxActionType, RoduxActionHandler>):RoduxReducer A helper function that can be used to create reducers. createReducer can replace the chain of if statements in a reducer: https://roblox.github.io/rodux/api-reference/#roduxcreatereducer
---@field combineReducers fun(map:table<any, RoduxReducer>):RoduxReducer A helper function that can be used to combine multiple reducers into a new reducer.
---@field makeActionCreator fun(name:RoduxActionType, actionGeneratorFunction:RoduxActionCreator):RoduxActionCreator
---@field loggerMiddleware RoduxMiddleware
---@field thunkMiddleware RoduxMiddleware

---@class RoduxErrorReporter
---@field reportReducerError fun(prevState:RoduxState, action:RoduxAction, errorResult:RoduxErrorResult)
---@field reportUpdateError fun(prevState:RoduxState, currentState:RoduxState, actionLog:RoduxAction[], errorResult:RoduxErrorResult)

---@class RoduxErrorResult
---@field message string
---@field thrownValue string

---@class RoduxSignalReturn
---@field disconnect function

---Multiple actions can be grouped together into one changed event!
---Do not yield within any listeners on changed; an error will be thrown.
---@class RoduxStoreChangedEvent
---@field connect fun(self:RoduxStoreChangedEvent, listener:fun(newState:RoduxState, oldState:RoduxState)):RoduxSignalReturn

---@class RoduxStore
---@field new fun(reducer:Reducer, initialState:RoduxState, middlewares:RoduxMiddleware[]|nil, errorReporter:RoduxErrorReporter|nil):RoduxStore Creates and returns a new Store. The initialization action does not pass through any middleware prior to reaching the reducer.
---@field changed RoduxStoreChangedEvent A Signal that is fired when the store's state is changed up to once per frame.
---@field dispatch fun(self:RoduxStore, action:RoduxAction) Dispatches an action. The action will travel through all of the store's middlewares before reaching the store's reducer. Unless handled by middleware, action must contain a type field to indicate what type of action it is. No other fields are required.
---@field getState fun(self:RoduxStore):RoduxState Do not modify this state! Doing so will cause serious bugs your code!
---@field destruct fun(self:RoduxStore) Destroys the store, cleaning up its connections. Attempting to use the store after destruct has been called will cause problems.
---@field flush fun(self:RoduxStore) Flushes the store's pending actions, firing the changed event if necessary. flush is called by Rodux automatically every frame and usually doesn't need to be called manually.

--------------------------------------------------
--- JANITOR (v1.14.1, April 2022)
--------------------------------------------------

---@class Janitor
---@field CurrentlyCleaning boolean Whether or not the Janitor is currently cleaning up.
---@field new fun():Janitor
---@field Is fun(self:Janitor, object:any):boolean Determines if the passed object is a Janitor. This checks the metatable directly.
---@field Add fun(self:Janitor, object:any, methodName:string|true, index:any):any Adds an Object to Janitor for later cleanup, where MethodName is the key of the method within Object which should be called at cleanup time. If the MethodName is true the Object itself will be called if it's a function or have task.cancel called on it if it is a thread. If passed an index it will occupy a namespace which can be Remove()d or overwritten. Returns the Object.
---@field Add fun(self:Janitor, object:any, methodName:string|true):any
---@field Add fun(self:Janitor, object:any):any
---@field AddPromise fun(self:Janitor, promise:Promise):Promise
---@field Cleanup fun(self:Janitor) Calls each Object's MethodName (or calls the Object if MethodName == true) and removes them from the Janitor. Also clears the namespace. This function is also called when you call a Janitor Object (so it can be used as a destructor callback).
---@field Destroy fun(self:Janitor) Calls Janitor.Cleanup and renders the Janitor unusable. Running this will make any further attempts to call a method of Janitor error.
---@field Get fun(self:Janitor, index:any):any|nil Gets whatever object is stored with the given index, if it exists. This was added since Maid allows getting the task using __index.
---@field LinkToInstance fun(self:Janitor, object:Instance, allowMultiple:boolean):RBXScriptConnection "Links" this Janitor to an Instance, such that the Janitor will Cleanup when the Instance is Destroyed() and garbage collected. A Janitor may only be linked to one instance at a time, unless AllowMultiple is true. When called with a truthy AllowMultiple parameter, the Janitor will "link" the Instance without overwriting any previous links, and will also not be overwritable. When called with a falsy AllowMultiple parameter, the Janitor will overwrite the previous link which was also called with a falsy AllowMultiple parameter, if applicable.
---@field LinkToInstance fun(self:Janitor, object:Instance):RBXScriptConnection
---@field LinkToInstances fun(self:Janitor, ...:Instance[]):Janitor Links several instances to a new Janitor, which is then returned.
---@field Remove fun(self:Janitor, index:any):Janitor Cleans up whatever Object was set to this namespace by the 3rd parameter of Janitor.Add.
---@field RemoveList fun(self:Janitor, ...:any):Janitor Cleans up multiple objects at once. ... are the indices you want to remove.

--------------------------------------------------
--- ROACT-RODUX (v0.2.2, April 2022)
--------------------------------------------------

---@class RoactRodux
---@field StoreProvider any
---@field connect fun()
