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
---@field changed RoduxStoreChangedEvent A Signal that is fired when the stores state is changed up to once per frame.
---@field dispatch fun(self:RoduxStore, action:RoduxAction) Dispatches an action. The action will travel through all of the stores middlewares before reaching the stores reducer. Unless handled by middleware, action must contain a type field to indicate what type of action it is. No other fields are required.
---@field getState fun(self:RoduxStore):RoduxState Do not modify this state! Doing so will cause serious bugs your code!
---@field destruct fun(self:RoduxStore) Destroys the store, cleaning up its connections. Attempting to use the store after destruct has been called will cause problems.
---@field flush fun(self:RoduxStore) Flushes the stores pending actions, firing the changed event if necessary. flush is called by Rodux automatically every frame and usually doesnt need to be called manually.

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
---@field Cleanup fun(self:Janitor) Calls each Objects MethodName (or calls the Object if MethodName == true) and removes them from the Janitor. Also clears the namespace. This function is also called when you call a Janitor Object (so it can be used as a destructor callback).
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

---@alias RoactRoduxMapStateToProps fun(state:RoduxState, props:table):table
---@alias RoactRoduxMapDispatchToProps fun(dispatch:fun(action:RoduxAction)):table

---@class RoactRodux
---@field StoreProvider string A Roact Component type
---@field connect fun(mapStateToProps:RoactRoduxMapStateToProps, mapDispatchToProps:RoactRoduxMapDispatchToProps)

--------------------------------------------------
--- ROACT (v1.4.2, April 2022)
--------------------------------------------------

---@class Roact
---@field createElement fun(component:string|function|table, props:table, children:table<string, RoactElement>):RoactElement Creates a new Roact element representing the given component. The children argument is shorthand for adding a Roact.Children key to props. It should be specified as a dictionary of names to elements. component can be a string, a function, or a table created by Component:extend.
---@field createElement fun(component:string|function|table, props:table):RoactElement
---@field createElement fun(component:string|function|table):RoactElement
---@field createFragment fun(elements:RoactElement[]):RoactFragment Creates a new Roact fragment with the provided table of elements. Fragments allow grouping of elements without the need for intermediate containing objects like Frames.
---@field mount fun(element:RoactElement, parent:Instance, key:string):RoactTree Creates a Roblox Instance given a Roact element, and optionally a parent to put it in, and a key to use as the instances Name.
---@field mount fun(element:RoactElement, parent:Instance):RoactTree
---@field mount fun(element:RoactElement):RoactTree
---@field update fun(tree:RoactTree, element:RoactElement):RoactTree Updates an existing instance handle with a new element, returning a new handle. This can be used to update a UI created with Roact.mount by passing in a new element with new propsupdate can be used to change the props of a component instance created with mount and is useful for putting Roact content into non-Roact applications.As of Roact 1.0, the returned RoactTree object will always be the same value as the one passed in.
---@field unmount fun(tree:RoactTree) Destroys the given RoactTree and all of its descendants. Does not operate on a Roblox Instance -- this must be given a handle that was returned by Roact.mount.
---@field createBinding fun(initialValue:any):RoactBinding, fun(newValue:any) The first value returned is a Binding object, which will typically be passed as a prop to a Roact host component. The second is a function that can be called with a new value to update the binding.
---@field joinBindings fun(bindings:table<any, RoactBinding>):RoactBinding Combines multiple bindings into a single binding. The new bindings value will have the same keys as the input table of bindings. joinBindings is usually used alongside Binding.map
---@field createRef fun():RoactRef Creates a new reference object that can be used with Roact.Ref.
---@field forwardRef fun(render:fun(props:table, ref:RoactRef):RoactElement):RoactComponent Creates a new component given a render function that accepts both props and a ref, allowing a ref to be forwarded to an underlying host component via Roact.Ref.
---@field createContext fun(defaultValue:any):RoactContext Creates a new context provider and consumer. For a usage guide, see Advanced Concepts: Context. defaultValue is given to consumers if they have no Provider ancestors. It is up to users of Roacts context API to turn this case into an error if it is an invalid state. Provider and Consumer are both Roact components.
---@field setGlobalConfig fun(configValues:RoactGlobalConfig) The entry point for configuring Roact. Roact currently applies this to everything using this instance of Roact, so be careful using this with a project that has multiple consumers of Roact.
---@field Children string This is the key that Roact uses internally to store the children that are attached to a Roact element. If youre writing a new function component or stateful component that renders children like a host component, you can access Roact.Children in your props table.
---@field Ref string Use Roact.Ref as a key into the props of a host element to receive a handle to the underlying Roblox Instance. Assign this key to a ref created with createRef:
---@field Event string Index into Roact.Event to receive a key that can be used to connect to events when creating host elements e.g. Roact.Event.Touched
---@field Change string Index into Roact.Change to receive a key that can be used to connect to GetPropertyChangedSignal events. Its similar to Roact.Event e.g., Roact.Change.Text
---@field Roact.None string Roact.None is a special value that can be used to clear elements from your component state when calling setState or returning from getDerivedStateFromProps. In Lua tables, removing a field from state is not possible by setting its value to nil because nil values mean the same thing as no value at all. If a field needs to be removed from state, it can be set to Roact.None when calling setState, which will ensure that the resulting state no longer contains it:
---@field Component RoactComponentType The base component instance that can be extended to make stateful components. Call Roact.Component:extend(ComponentName) to make a new stateful component with a given name.
---@field PureComponent RoactComponentType An extension of Roact.Component that only re-renders if its props or state change. PureComponent implements the shouldUpdate lifecycle event with a shallow equality comparison. Its optimized for use with immutable data structures, which makes it a perfect fit for use with frameworks like Rodux. PureComponent is not always faster, but can often result in significant performance improvements when used correctly.
---@field Portal RoactComponentType A component that represents a portal to a Roblox Instance. Portals are created using Roact.createElement. Any children of a portal are put inside the Roblox Instance specified by the required target prop. That Roblox Instance should not be one created by Roact. Portals are useful for creating dialogs managed by deeply-nested UI components, and enable Roact to represent and manage multiple disjoint trees at once.

---@class RoactElement
---@class RoactFragment
---@class RoactRef

---@class RoactComponent
---@field defaultProps nil|table If defaultProps is defined on a stateful component, any props that arent specified when a component is created will be taken from there.
---@field init fun(initialProps:table) init is called exactly once when a new instance of a component is created. It can be used to set up the initial state, as well as any non-render related values directly on the component.
---@field render fun():RoactElement|nil render describes what a component should display at the current instant in time.
---@field setState fun(stateUpdater:fun(prevState:table, props:table):table) setState requests an update to the components state. Roact may schedule this update for a later time or resolve it immediately. If a function is passed to setState, that function will be called with the current state and props as arguments. If this function returns nil, Roact will not schedule a re-render and no state will be updated. If a table is passed to setState, the values in that table will be merged onto the existing state:
---@field setState fun(stateChange:table)
---@field shouldUpdate fun(nextProps:table, nextState:table):boolean shouldUpdate provides a way to override Roacts rerendering heuristics. By default, components are re-rendered any time a parent component updates, or when state is updated via setState. PureComponent implements shouldUpdate to only trigger a re-render any time the props are different based on shallow equality. In a future Roact update, all components may implement this check by default.
---@field validateProps nil|fun(props:table):boolean, string validateProps is an optional method that can be implemented for a component. It provides a mechanism for verifying inputs passed into the component. Every time props are updated, validateProps will be called with the new props before proceeding to shouldUpdate or init. It should return the same parameters that assert expects: a boolean, true if the props passed validation, false if they did not, plus a message explaining why they failed. If the first return value is true, the second value is ignored. For performance reasons, property validation is disabled by default. To use this feature, enable propValidation via setGlobalConfig:
---@field getElementTrackeback fun():string|nil getElementTraceback gets the stack trace that the component was created in. This allows you to report error messages accurately.
---@field didMount fun() didMount is fired after the component finishes its initial render. At this point, all associated Roblox Instances have been created, and all components have finished mounting. didMount is a good place to start initial network communications, attach events to services, or modify the Roblox Instance hierarchy.
---@field willUnmount fun() willUnmount is fired right before Roact begins unmounting a component instances children. willUnmount acts like a components destructor, and is a good place to disconnect any manually-connected events.
---@field willUpdate fun(nextProps:table, nextState:props) willUpdate is fired after an update is started but before a components state and props are updated.
---@field didUpdate fun(previousProps:table, previousState:props) didUpdate is fired after at the end of an update. At this point, Roact has updated the properties of any Roblox Instances and the component instances props and state are up to date. didUpdate is a good place to send network requests or dispatch Rodux actions, but make sure to compare self.props and self.state with previousProps and previousState to avoid triggering too many updates.
---@field getDerivedStateFromProps nil|fun(nextProps:table, lastState:table):table Used to recalculate any state that depends on being synchronized with props. Generally, you should use didUpdate to respond to props changing. If you find yourself copying props values to state as-is, consider using props or memoization instead. getDerivedStateFromProps should return a table that contains the part of the state that should be updated.

---@class RoactComponentType
---@field extend fun(self:RoactComponentType, name:string):RoactComponent

---@class RoactGlobalConfig
---@field typeChecks boolean
---@field propValidation boolean
---@field internalTypeChecks boolean
---@field elementTracing boolean

---@class RoactContext
---@field Provider RoactComponent
---@field Consumer RoactComponent

---@class RoactBinding
---@field getValue fun():any Returns the internal value of the binding. This is helpful when updating a binding relative to its current value.
---@field map fun(mappingFunction:fun(value:any):any):RoactBinding Returns a new binding that maps the existing bindings value to something else. For example, map can be used to transform an animation progress value like 0.4 into a property that can be consumed by a Roblox Instance like UDim2.new(0.4, 0, 1, 0).
