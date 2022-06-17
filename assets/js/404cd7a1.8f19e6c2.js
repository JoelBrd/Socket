"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[685],{18258:function(e){e.exports=JSON.parse('{"functions":[{"name":"IntroduceInstance","desc":"Brings an instance into the workspace in the context of Socket and the user calling this function. By default, sets a ChangeHistoryService waypoint.","params":[{"name":"instance","desc":"","lua_type":"Instance"},{"name":"dontSetWaypoint","desc":"","lua_type":"boolean|nil"}],"returns":[],"function_type":"method","source":{"line":45,"path":"docs_api/utils.lua"}},{"name":"ClearInstance","desc":"Clears an instance from our context of Socket and the user calling this function. Should be an instance that was introduced via `IntroduceInstance`","params":[{"name":"instance","desc":"","lua_type":"Instance"},{"name":"doDestroy","desc":"","lua_type":"boolean"}],"returns":[],"function_type":"method","source":{"line":54,"path":"docs_api/utils.lua"}}],"properties":[],"types":[],"name":"TeamCreateUtil","desc":"A Util object that gives some nice methods for when a plug needs to create instances + place them somewhere in the workspace. It places instances\\nunder a Socket folder, under this specific user.\\n\\nInstances parented using this class will be automatically cleaned up when Socket closes. You may still want to have a `BindToClose` implementation,\\ndepending on what your plug does and if you need to handle cases where the plugin isn\'t closed properly (e.g., Studio crash)","source":{"line":36,"path":"docs_api/utils.lua"}}')}}]);