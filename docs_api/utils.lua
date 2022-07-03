--[=[
    @class Logger

    A Util object for nicely logging messages to the output window.

    This can be required under `game.ServerStorage.SocketPlugin.Utils.Logger`
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
    @class InstanceUtil

    A Util object that gives some nice methods for when a plug needs to create instances + place them somewhere in the workspace. It places instances
    under a Socket folder, under this specific user - useful for Team Create!

    Instances parented using this class will be automatically cleaned up when Socket closes (but only for the specific user in Team Create). You may still want to have a `BindToClose` implementation,
    depending on what your plug does and if you need to handle cases where the plugin isn't closed properly (e.g., Studio crash)

    This can be required under `game.ServerStorage.SocketPlugin.Utils.InstanceUtil`
]=]

--[=[
    @method IntroduceInstance
    @param instance Instance
    @param dontSetWaypoint boolean|nil
    @within InstanceUtil

    Brings an instance into the workspace in the context of Socket and the user calling this function. By default, sets a ChangeHistoryService waypoint.
]=]

--[=[
    @method ClearInstance
    @param instance Instance
    @param doDestroy boolean
    @within InstanceUtil

    Clears an instance from our context of Socket and the user calling this function. Should be an instance that was introduced via `IntroduceInstance`
]=]

-----------------------------------------------------------------------------------------------------------------------------------------------------

--[=[
    @class RaycastUtil

    Gives some nice methods for raycasting. 
]=]

--[=[
    @method RaycastMouse
    @param distance number
    @param raycastParams RaycastParams|nil
    @param checkAllCollisionGroups boolean|nil
    @within RaycastUtil

    Sends a raycast from our camera to the point our mouse is at in the world.

    `checkAllCollisionGroups=true` will make sure we raycast against parts that don't collide with the `"Default"` Collision Group (see the ".Locked" plug)
]=]

--[=[
    @method Raycast
    @param origin Vector3
    @param direction Vector3
    @param distance number
    @param raycastParams RaycastParams|nil
    @param checkAllCollisionGroups boolean|nil
    @within RaycastUtil

    Does a bog standard raycast.

    `checkAllCollisionGroups=true` will make sure we raycast against parts that don't collide with the `"Default"` Collision Group (see the ".Locked" plug)
]=]

-----------------------------------------------------------------------------------------------------------------------------------------------------

--[=[
    @class Promise

    See [Promise](https://eryn.io/roblox-lua-promise/)
]=]

--[=[
    @class Janitor

    See [Janitor](https://github.com/howmanysmall/Janitor)
]=]