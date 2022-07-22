"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[273],{3905:function(e,n,t){t.d(n,{Zo:function(){return d},kt:function(){return m}});var r=t(67294);function o(e,n,t){return n in e?Object.defineProperty(e,n,{value:t,enumerable:!0,configurable:!0,writable:!0}):e[n]=t,e}function a(e,n){var t=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);n&&(r=r.filter((function(n){return Object.getOwnPropertyDescriptor(e,n).enumerable}))),t.push.apply(t,r)}return t}function l(e){for(var n=1;n<arguments.length;n++){var t=null!=arguments[n]?arguments[n]:{};n%2?a(Object(t),!0).forEach((function(n){o(e,n,t[n])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(t)):a(Object(t)).forEach((function(n){Object.defineProperty(e,n,Object.getOwnPropertyDescriptor(t,n))}))}return e}function i(e,n){if(null==e)return{};var t,r,o=function(e,n){if(null==e)return{};var t,r,o={},a=Object.keys(e);for(r=0;r<a.length;r++)t=a[r],n.indexOf(t)>=0||(o[t]=e[t]);return o}(e,n);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(r=0;r<a.length;r++)t=a[r],n.indexOf(t)>=0||Object.prototype.propertyIsEnumerable.call(e,t)&&(o[t]=e[t])}return o}var c=r.createContext({}),s=function(e){var n=r.useContext(c),t=n;return e&&(t="function"==typeof e?e(n):l(l({},n),e)),t},d=function(e){var n=s(e.components);return r.createElement(c.Provider,{value:n},e.children)},p={inlineCode:"code",wrapper:function(e){var n=e.children;return r.createElement(r.Fragment,{},n)}},u=r.forwardRef((function(e,n){var t=e.components,o=e.mdxType,a=e.originalType,c=e.parentName,d=i(e,["components","mdxType","originalType","parentName"]),u=s(t),m=o,f=u["".concat(c,".").concat(m)]||u[m]||p[m]||a;return t?r.createElement(f,l(l({ref:n},d),{},{components:t})):r.createElement(f,l({ref:n},d))}));function m(e,n){var t=arguments,o=n&&n.mdxType;if("string"==typeof e||o){var a=t.length,l=new Array(a);l[0]=u;var i={};for(var c in n)hasOwnProperty.call(n,c)&&(i[c]=n[c]);i.originalType=e,i.mdxType="string"==typeof e?e:o,l[1]=i;for(var s=2;s<a;s++)l[s]=t[s];return r.createElement.apply(null,l)}return r.createElement.apply(null,t)}u.displayName="MDXCreateElement"},25304:function(e,n,t){t.r(n),t.d(n,{frontMatter:function(){return i},contentTitle:function(){return c},metadata:function(){return s},toc:function(){return d},default:function(){return u}});var r=t(87462),o=t(63366),a=(t(67294),t(3905)),l=["components"],i={sidebar_position:4},c="Examples",s={unversionedId:"Examples",id:"Examples",isDocsHomePage:!1,title:"Examples",description:"Example 1 | Midas Touch Macro",source:"@site/docs/Examples.md",sourceDirName:".",slug:"/Examples",permalink:"/Socket/docs/Examples",editUrl:"https://github.com/JoelBrd/Socket/edit/master/docs/Examples.md",tags:[],version:"current",sidebarPosition:4,frontMatter:{sidebar_position:4},sidebar:"defaultSidebar",previous:{title:"Adding Your First Macro",permalink:"/Socket/docs/YourFirstMacro"},next:{title:"Advanced Concepts",permalink:"/Socket/docs/AdvancedConcepts"}},d=[{value:"Example 1 | Midas Touch Macro",id:"example-1--midas-touch-macro",children:[{value:"Create the Macro",id:"create-the-macro",children:[],level:3},{value:"Make it pretty",id:"make-it-pretty",children:[],level:3},{value:"v1",id:"v1",children:[],level:3},{value:"v2",id:"v2",children:[{value:"Automatic Undo",id:"automatic-undo",children:[],level:4},{value:"More colors",id:"more-colors",children:[],level:4},{value:"Real time",id:"real-time",children:[],level:4}],level:3}],level:2}],p={toc:d};function u(e){var n=e.components,i=(0,o.Z)(e,l);return(0,a.kt)("wrapper",(0,r.Z)({},p,i,{components:n,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"examples"},"Examples"),(0,a.kt)("h2",{id:"example-1--midas-touch-macro"},"Example 1 | Midas Touch Macro"),(0,a.kt)("p",null,"Lets go through an example here by creating a Macro that makes parts look golden."),(0,a.kt)("h3",{id:"create-the-macro"},"Create the Macro"),(0,a.kt)("p",null,"We'll start off by placing a ",(0,a.kt)("inlineCode",{parentName:"p"},"ModuleScript")," at ",(0,a.kt)("inlineCode",{parentName:"p"},"game.ServerStorage.SocketPlugin.Macros.MidasTouch"),":"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'---\n---Midas Touch\n---\n\n--------------------------------------------------\n-- Dependencies\nlocal ServerStorage = game:GetService("ServerStorage")\nlocal Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")\nlocal Logger = require(Utils.Logger)\n\n--------------------------------------------------\n-- Members\n\nlocal macroDefinition = {\n    Group = "Golden",\n    Name = "Midas Touch",\n    Description = "Makes parts gold",\n}\n\nmacroDefinition.Function = function(macro, plugin)\n    Logger:MacroInfo(macro, "I command you to make parts golden!")\nend\n\nreturn macroDefinition\n\n')),(0,a.kt)("p",null,(0,a.kt)("strong",{parentName:"p"},"Result:")),(0,a.kt)("p",null,(0,a.kt)("img",{alt:"image",src:t(18587).Z})),(0,a.kt)("h3",{id:"make-it-pretty"},"Make it pretty"),(0,a.kt)("p",null,"This is looking a touch bland on our Widget, lets juice it up a bit."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'local macroDefinition = {\n    Group = "Golden",\n    GroupColor = Color3.fromRGB(255, 180, 0),\n    GroupIcon = "\ud83d\udc51",\n    Name = "Midas Touch",\n    Icon = "\ud83e\udd0f";\n    Description = "Makes parts gold",\n}\n')),(0,a.kt)("p",null,(0,a.kt)("strong",{parentName:"p"},"Better!")),(0,a.kt)("p",null,(0,a.kt)("img",{alt:"image",src:t(87680).Z})),(0,a.kt)("h3",{id:"v1"},"v1"),(0,a.kt)("p",null,"The Macro currently doesn't do anything, other than print a silly message to the output window. Lets make it so when we run the Macro, it will make any parts that we have selected turn golden:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'---\n---Midas Touch\n---\n\n--------------------------------------------------\n-- Dependencies\nlocal Selection = game:GetService("Selection")\nlocal ServerStorage = game:GetService("ServerStorage")\nlocal Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")\nlocal Logger = require(Utils.Logger)\n\n--------------------------------------------------\n-- Constants\nlocal COLOR_GOLD = Color3.fromRGB(255, 180, 0)\n\n--------------------------------------------------\n-- Members\n\nlocal macroDefinition = {\n    Group = "Golden",\n    GroupColor = COLOR_GOLD,\n    GroupIcon = "\ud83d\udc51",\n    Name = "Midas Touch",\n    Icon = "\ud83e\udd0f";\n    Description = "Converts any parts we have selected turn to gold",\n}\n\nmacroDefinition.Function = function(macro, plugin)\n    -- Get our selected instances, and filter out any non-BaseParts\n    local selectedInstances = Selection:Get()\n    local parts = {}\n    for _,instance in pairs(selectedInstances) then\n        if instance:IsA("BasePart") then\n            table.insert(parts, instance)\n        end\n    end\n\n    -- Apply a gold finish to each part\n    for _,part in pairs(parts) do\n        part.Color = COLOR_GOLD\n        part.Material = Enum.Material.Foil\n    end\n\n    -- Log\n    Logger:MacroInfo(macro, ("I encrusted %d parts with gold!"):format(#parts))\nend\n\nreturn macroDefinition\n\n')),(0,a.kt)("p",null,(0,a.kt)("strong",{parentName:"p"},"Cool!")),(0,a.kt)("p",null,(0,a.kt)("img",{alt:"image",src:t(27419).Z})),(0,a.kt)("h3",{id:"v2"},"v2"),(0,a.kt)("h4",{id:"automatic-undo"},"Automatic Undo"),(0,a.kt)("p",null,"v1 was all well and good, but what if I accidentally gold-ify a part that I didn't want to? We need to setup ",(0,a.kt)("inlineCode",{parentName:"p"},"ChangeHistoryService")," waypoints to implement this, or we can simply do:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},"{\n    -- ...\n    EnableAutomaticUndo = true\n    -- ...\n}\n")),(0,a.kt)("h4",{id:"more-colors"},"More colors"),(0,a.kt)("p",null,"I'm also not super happy with it always being the same color; lets add 2 color fields that we will uniformly interpolate between."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'{\n    -- ...\n    Fields = {\n        {\n            Name = "ColorA",\n            Type = "Color3",\n            IsRequired = true,\n        },\n        {\n            Name = "ColorB",\n            Type = "Color3",\n            IsRequired = true,\n        },\n    }\n    -- ...\n}\n')),(0,a.kt)("p",null,(0,a.kt)("img",{alt:"image",src:t(22340).Z})),(0,a.kt)("h4",{id:"real-time"},"Real time"),(0,a.kt)("p",null,"Finally, I don't want to have to click Run, or use a Keybind, to make a part gold. I want to"),(0,a.kt)("ol",null,(0,a.kt)("li",{parentName:"ol"},"Make the Macro toggleable"),(0,a.kt)("li",{parentName:"ol"},"Whenever the Macro is running, any parts I select will turn to gold in real time."),(0,a.kt)("li",{parentName:"ol"},"Define routines so they'll get cleaned up safely")),(0,a.kt)("p",null,"Lets write some code to make this happen.."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'---\n---Midas Touch\n---\n\n--------------------------------------------------\n-- Dependencies\nlocal Selection = game:GetService("Selection")\nlocal ServerStorage = game:GetService("ServerStorage")\nlocal Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")\nlocal Logger = require(Utils.Logger)\n\n--------------------------------------------------\n-- Constants\nlocal COLOR_GOLD = Color3.fromRGB(255, 180, 0)\n\n--------------------------------------------------\n-- Members\n\nlocal macroDefinition = {\n    Group = "Golden",\n    GroupColor = COLOR_GOLD,\n    GroupIcon = "\ud83d\udc51",\n    Name = "Midas Touch",\n    Icon = "\ud83e\udd0f";\n    Description = "Converts any parts we have selected turn to gold",\n    EnableAutomaticUndo = true,\n    Fields = {\n        {\n            Name = "ColorA",\n            Type = "Color3",\n            IsRequired = true,\n        },\n        {\n            Name = "ColorB",\n            Type = "Color3",\n            IsRequired = true,\n        },\n    },\n}\n\nmacroDefinition.Function = function(macro, plugin)\n    -- Toggle running\n    macro:ToggleIsRunning()\n\n    -- RETURN: Not running\n    if not macro:IsRunning() then\n        return\n    end\n    \n    -- Get Variables\n    local colorA = macro:GetFieldValue("ColorA")\n    local colorB = macro:GetFieldValue("ColorB")\n\n    -- Setup Loop\n    macro.RunJanitor:Add(Selection.SelectionChanged:Connect(function()\n        -- Get our selected instances, and filter out any non-parts\n        local selectedInstances = Selection:Get()\n        local parts = {}\n        for _,instance in pairs(selectedInstances) do\n            if instance:IsA("BasePart") then\n                table.insert(parts, instance)\n            end\n        end\n        \n        -- Apply a gold finish to each part\n        for _,part in pairs(parts) do\n            part.Color = colorA:Lerp(colorB, math.random())\n            part.Material = Enum.Material.Foil\n        end\n        \n        if #parts > 0 then\n            Logger:MacroInfo(macro, ("I encrusted %d parts with gold!"):format(#parts))\n        end\n    end))\nend\n\nreturn macroDefinition\n')),(0,a.kt)("p",null,(0,a.kt)("strong",{parentName:"p"},"Fantastic <3")),(0,a.kt)("p",null,(0,a.kt)("img",{alt:"image",src:t(75961).Z})))}u.isMDXComponent=!0},18587:function(e,n){n.Z="data:image/png;base64,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"},87680:function(e,n){n.Z="data:image/png;base64,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"},27419:function(e,n,t){n.Z=t.p+"assets/images/midas_touch_3-b044a2dd0ed29874f0d83fb50ab1bc92.png"},22340:function(e,n,t){n.Z=t.p+"assets/images/midas_touch_4-54d8382746ad1b0166280f50bdc80f10.png"},75961:function(e,n,t){n.Z=t.p+"assets/images/midas_touch_v2-8615c637cd955113e882a07230ddbd6a.gif"}}]);