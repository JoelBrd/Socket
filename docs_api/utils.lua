--[=[
    @class Logger

    A Util object for nicely logging messages to the output window
]=]

--[=[
    @method PlugInfo
    @param plug PlugDefinition
    @param ... any
    @within Logger

    For showing general information to the output
]=]

--[=[
    @method PlugWarn
    @param plug PlugDefinition
    @param ... any
    @within Logger

    For informing the user that an issue with a plug has occured
]=]

-----------------------------------------------------------------------------------------------------------------------------------------------------

--[=[
    @class TeamCreateUtil

    A Util object that gives some nice methods for when a plug needs to create instances + place them somewhere in the workspace. It places instances
    under a Socket folder, under this specific user.

    Instances parented using this class will be automatically cleaned up when Socket closes. You may still want to have a `BindToClose` implementation,
    depending on what your plug does and if you need to handle cases where the plugin isn't closed properly (e.g., Studio crash)
]=]

--[=[
    @method IntroduceInstance
    @param instance Instance
    @param dontSetWaypoint boolean|nil
    @within TeamCreateUtil

    Brings an instance into the workspace in the context of Socket and the user calling this function. By default, sets a ChangeHistoryService waypoint.
]=]

--[=[
    @method ClearInstance
    @param instance Instance
    @param doDestroy boolean
    @within TeamCreateUtil

    Clears an instance from our context of Socket and the user calling this function. Should be an instance that was introduced via `IntroduceInstance`
]=]
