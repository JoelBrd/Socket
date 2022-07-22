"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[663],{3905:function(e,n,t){t.d(n,{Zo:function(){return p},kt:function(){return d}});var a=t(67294);function i(e,n,t){return n in e?Object.defineProperty(e,n,{value:t,enumerable:!0,configurable:!0,writable:!0}):e[n]=t,e}function o(e,n){var t=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);n&&(a=a.filter((function(n){return Object.getOwnPropertyDescriptor(e,n).enumerable}))),t.push.apply(t,a)}return t}function r(e){for(var n=1;n<arguments.length;n++){var t=null!=arguments[n]?arguments[n]:{};n%2?o(Object(t),!0).forEach((function(n){i(e,n,t[n])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(t)):o(Object(t)).forEach((function(n){Object.defineProperty(e,n,Object.getOwnPropertyDescriptor(t,n))}))}return e}function l(e,n){if(null==e)return{};var t,a,i=function(e,n){if(null==e)return{};var t,a,i={},o=Object.keys(e);for(a=0;a<o.length;a++)t=o[a],n.indexOf(t)>=0||(i[t]=e[t]);return i}(e,n);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(a=0;a<o.length;a++)t=o[a],n.indexOf(t)>=0||Object.prototype.propertyIsEnumerable.call(e,t)&&(i[t]=e[t])}return i}var c=a.createContext({}),s=function(e){var n=a.useContext(c),t=n;return e&&(t="function"==typeof e?e(n):r(r({},n),e)),t},p=function(e){var n=s(e.components);return a.createElement(c.Provider,{value:n},e.children)},u={inlineCode:"code",wrapper:function(e){var n=e.children;return a.createElement(a.Fragment,{},n)}},m=a.forwardRef((function(e,n){var t=e.components,i=e.mdxType,o=e.originalType,c=e.parentName,p=l(e,["components","mdxType","originalType","parentName"]),m=s(t),d=i,h=m["".concat(c,".").concat(d)]||m[d]||u[d]||o;return t?a.createElement(h,r(r({ref:n},p),{},{components:t})):a.createElement(h,r({ref:n},p))}));function d(e,n){var t=arguments,i=n&&n.mdxType;if("string"==typeof e||i){var o=t.length,r=new Array(o);r[0]=m;var l={};for(var c in n)hasOwnProperty.call(n,c)&&(l[c]=n[c]);l.originalType=e,l.mdxType="string"==typeof e?e:i,r[1]=l;for(var s=2;s<o;s++)r[s]=t[s];return a.createElement.apply(null,r)}return a.createElement.apply(null,t)}m.displayName="MDXCreateElement"},20302:function(e,n,t){t.r(n),t.d(n,{frontMatter:function(){return l},contentTitle:function(){return c},metadata:function(){return s},toc:function(){return p},default:function(){return m}});var a=t(87462),i=t(63366),o=(t(67294),t(3905)),r=["components"],l={sidebar_position:3},c="Adding Your First Macro",s={unversionedId:"YourFirstMacro",id:"YourFirstMacro",isDocsHomePage:!1,title:"Adding Your First Macro",description:"If you've got this far, let's assume that your interested in adding some Macros of your own to help improve your developer workflow!",source:"@site/docs/YourFirstMacro.md",sourceDirName:".",slug:"/YourFirstMacro",permalink:"/Socket/docs/YourFirstMacro",editUrl:"https://github.com/JoelBrd/Socket/edit/master/docs/YourFirstMacro.md",tags:[],version:"current",sidebarPosition:3,frontMatter:{sidebar_position:3},sidebar:"defaultSidebar",previous:{title:"Installation",permalink:"/Socket/docs/Installation"},next:{title:"Examples",permalink:"/Socket/docs/Examples"}},p=[{value:"Creating a new Macro",id:"creating-a-new-macro",children:[],level:2},{value:"Creating our code",id:"creating-our-code",children:[{value:"Parameters",id:"parameters",children:[],level:3},{value:"Logging",id:"logging",children:[],level:3},{value:"Using the <code>macro</code> Parameter",id:"using-the-macro-parameter",children:[{value:"<code>macro.State.IsRunning</code> &amp; <code>macro:ToggleIsRunning()</code>",id:"macrostateisrunning--macrotoggleisrunning",children:[],level:4},{value:"<code>macro.State.FieldValues</code>",id:"macrostatefieldvalues",children:[],level:4}],level:3},{value:"BindToClose",id:"bindtoclose",children:[],level:3}],level:2}],u={toc:p};function m(e){var n=e.components,l=(0,i.Z)(e,r);return(0,o.kt)("wrapper",(0,a.Z)({},u,l,{components:n,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"adding-your-first-macro"},"Adding Your First Macro"),(0,o.kt)("p",null,"If you've got this far, let's assume that your interested in adding some Macros of your own to help improve your developer workflow! "),(0,o.kt)("h2",{id:"creating-a-new-macro"},"Creating a new Macro"),(0,o.kt)("p",null,"Let's make use of one of our Core Macros, ",(0,o.kt)("strong",{parentName:"p"},"Create Macro")," to create your first macro\n",(0,o.kt)("img",{alt:"image",src:t(56013).Z})),(0,o.kt)("p",null,"This creates a ",(0,o.kt)("inlineCode",{parentName:"p"},"ModuleScript")," in the ",(0,o.kt)("inlineCode",{parentName:"p"},"SocketPlugin.Macros")," directory"),(0,o.kt)("div",{className:"admonition admonition-info alert alert--info"},(0,o.kt)("div",{parentName:"div",className:"admonition-heading"},(0,o.kt)("h5",{parentName:"div"},(0,o.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,o.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"14",height:"16",viewBox:"0 0 14 16"},(0,o.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M7 2.3c3.14 0 5.7 2.56 5.7 5.7s-2.56 5.7-5.7 5.7A5.71 5.71 0 0 1 1.3 8c0-3.14 2.56-5.7 5.7-5.7zM7 1C3.14 1 0 4.14 0 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm1 3H6v5h2V4zm0 6H6v2h2v-2z"}))),"info")),(0,o.kt)("div",{parentName:"div",className:"admonition-content"},(0,o.kt)("p",{parentName:"div"},"You can create folders in this directory to help organise your Macros; but the ",(0,o.kt)("inlineCode",{parentName:"p"},"Group")," of a Macro is defined within the ",(0,o.kt)("inlineCode",{parentName:"p"},"ModuleScript")," itself"))),(0,o.kt)("p",null,"You'll get a ",(0,o.kt)("inlineCode",{parentName:"p"},"ModuleScript")," with a ",(0,o.kt)("inlineCode",{parentName:"p"},"Source")," similar to:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'---\n-- Macro\n---\n\n--------------------------------------------------\n-- Dependencies\nlocal ServerStorage = game:GetService("ServerStorage")\nlocal Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")\nlocal Logger = require(Utils.Logger)\n\n--------------------------------------------------\n-- Members\n\nlocal macroDefinition = {\n    Name = "%s",\n    Group = "Macros",\n    Icon = "%s",\n    Description = "%s",\n}\n\nmacroDefinition.Function = function(macro, plugin)\n    Logger:MacroInfo(macro, ("Hello %s!"):format(macro.Name))\n    --[[\n        ...\n        Your Logic Here\n        ...\n    ]]\nend\n\nreturn macroDefinition\n\n')),(0,o.kt)("p",null,"You'll notice we're returning a table with key/value pairs. For a full breakdown of what is on offer, and what they each do, see ",(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition"},"MacroDefinition"),"."),(0,o.kt)("p",null,"There are 2 required key/value pairs:"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},"Name"),(0,o.kt)("li",{parentName:"ul"},"Function")),(0,o.kt)("p",null,"Everything else is optional, or will be populated with a default value."),(0,o.kt)("div",{className:"admonition admonition-tip alert alert--success"},(0,o.kt)("div",{parentName:"div",className:"admonition-heading"},(0,o.kt)("h5",{parentName:"div"},(0,o.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,o.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"12",height:"16",viewBox:"0 0 12 16"},(0,o.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.5 0C3.48 0 1 2.19 1 5c0 .92.55 2.25 1 3 1.34 2.25 1.78 2.78 2 4v1h5v-1c.22-1.22.66-1.75 2-4 .45-.75 1-2.08 1-3 0-2.81-2.48-5-5.5-5zm3.64 7.48c-.25.44-.47.8-.67 1.11-.86 1.41-1.25 2.06-1.45 3.23-.02.05-.02.11-.02.17H5c0-.06 0-.13-.02-.17-.2-1.17-.59-1.83-1.45-3.23-.2-.31-.42-.67-.67-1.11C2.44 6.78 2 5.65 2 5c0-2.2 2.02-4 4.5-4 1.22 0 2.36.42 3.22 1.19C10.55 2.94 11 3.94 11 5c0 .66-.44 1.78-.86 2.48zM4 14h5c-.23 1.14-1.3 2-2.5 2s-2.27-.86-2.5-2z"}))),"tip")),(0,o.kt)("div",{parentName:"div",className:"admonition-content"},(0,o.kt)("p",{parentName:"div"},"Try adding + configuring some fields, and see how the Widget updates! Keep an eye on the ",(0,o.kt)("em",{parentName:"p"},"output")," window incase there are any issues with your ",(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition"},"MacroDefinition"),"."))),(0,o.kt)("h2",{id:"creating-our-code"},"Creating our code"),(0,o.kt)("p",null,"We now have a fresh Macro, and have played around with how it appears on the Widget. Lets take a look at the tools we have when defining our ",(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition#Function"},"Function")),(0,o.kt)("h3",{id:"parameters"},"Parameters"),(0,o.kt)("p",null,(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition#Function"},"Function")," gets passed 2 parameters; ",(0,o.kt)("inlineCode",{parentName:"p"},"macro"),": ",(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition"},"MacroDefinition"),", ",(0,o.kt)("inlineCode",{parentName:"p"},"plugin"),": ",(0,o.kt)("a",{parentName:"p",href:"https://developer.roblox.com/en-us/api-reference/class/Plugin"},"Plugin"),"."),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("inlineCode",{parentName:"li"},"macro")," is our ",(0,o.kt)("a",{parentName:"li",href:"/api/MacroDefinition"},"MacroDefinition"),". It is important we reference ",(0,o.kt)("inlineCode",{parentName:"li"},"macro")," inside our functions, and ",(0,o.kt)("strong",{parentName:"li"},"not")," ",(0,o.kt)("inlineCode",{parentName:"li"},"macroDefinition"),". Changes are made outside the scope of the ",(0,o.kt)("inlineCode",{parentName:"li"},"ModuleScript")," (e.g., if we change a ",(0,o.kt)("inlineCode",{parentName:"li"},"Field")," value on the Widget, this is written to the ",(0,o.kt)("inlineCode",{parentName:"li"},"macro")," variable and ",(0,o.kt)("strong",{parentName:"li"},"not")," ",(0,o.kt)("inlineCode",{parentName:"li"},"macroDefinition"),")"),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("inlineCode",{parentName:"li"},"plugin")," is the actual ",(0,o.kt)("a",{parentName:"li",href:"https://developer.roblox.com/en-us/api-reference/class/Plugin"},"Plugin")," object that ",(0,o.kt)("strong",{parentName:"li"},"Socket")," is under; this is passed for special use cases, as the ",(0,o.kt)("a",{parentName:"li",href:"https://developer.roblox.com/en-us/api-reference/class/Plugin"},"Plugin")," object has unique API")),(0,o.kt)("h3",{id:"logging"},"Logging"),(0,o.kt)("p",null,"You'll notice in the template Macro that gets created, a required ",(0,o.kt)("inlineCode",{parentName:"p"},"Logger")," file. This gives us access to ",(0,o.kt)("inlineCode",{parentName:"p"},'Logger:MacroInfo(macro, "Hello!")')," and ",(0,o.kt)("inlineCode",{parentName:"p"},'Logger:MacroWarn(macro, "Uh Oh!")')),(0,o.kt)("p",null,"This is just a nice way to print to the output, and show the Macro scope it came from. This is the same API used for when ",(0,o.kt)("strong",{parentName:"p"},"Socket")," detects an issue with a Macro and wants to inform the user (e.g., a required Field is missing its value)"),(0,o.kt)("h3",{id:"using-the-macro-parameter"},"Using the ",(0,o.kt)("inlineCode",{parentName:"h3"},"macro")," Parameter"),(0,o.kt)("p",null,"You can reference any members of ",(0,o.kt)("inlineCode",{parentName:"p"},"macro")," (see ",(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition"},"MacroDefinition"),")."),(0,o.kt)("p",null,"One of the most useful members is ",(0,o.kt)("inlineCode",{parentName:"p"},"macro.State")," (see ",(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition#MacroState"},"MacroState"),"). Let's take a quick look what that gives us access to:"),(0,o.kt)("h4",{id:"macrostateisrunning--macrotoggleisrunning"},(0,o.kt)("inlineCode",{parentName:"h4"},"macro.State.IsRunning")," & ",(0,o.kt)("inlineCode",{parentName:"h4"},"macro:ToggleIsRunning()")),(0,o.kt)("p",null,"We may want to have a Macro that has a toggleable routine; aka we can turn it on and off. We can change ",(0,o.kt)("inlineCode",{parentName:"p"},"macro.State.IsRunning")," to keep track of the macro being on or off. We can toggle this using ",(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition#ToggleIsRunning"},"ToggleIsRunning")," and read it via ",(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition#IsRunning"},"IsRunning"),". These methods are sugar for manipulating values in ",(0,o.kt)("inlineCode",{parentName:"p"},"macro")),(0,o.kt)("h4",{id:"macrostatefieldvalues"},(0,o.kt)("inlineCode",{parentName:"h4"},"macro.State.FieldValues")),(0,o.kt)("p",null,"A strength of Socket is being able to declare values on the fly to be used in our Macros. These are easily accessible on the Widget, but we then ofcourse need to reference them in our ",(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition#Function"},"Function"),". ",(0,o.kt)("inlineCode",{parentName:"p"},"macro.State.FieldValues")," is where the declared values of fields exist. If we have declared a field such as:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'{\n    Fields = {\n        {\n            Name = "Amount";\n            Type = "number";\n        }\n    }\n}\n')),(0,o.kt)("p",null,"We can access the value via ",(0,o.kt)("inlineCode",{parentName:"p"},'macro:GetFieldValue("Amount")')," (which is sugar for ",(0,o.kt)("inlineCode",{parentName:"p"},"macro.State.FieldValues.Amount"),")\nNote that amount may not exist, so we can either:"),(0,o.kt)("ol",null,(0,o.kt)("li",{parentName:"ol"},"Run this check in our ",(0,o.kt)("inlineCode",{parentName:"li"},"Function")),(0,o.kt)("li",{parentName:"ol"},"Do ")),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'{\n    Fields = {\n        {\n            Name = "Amount";\n            Type = "number";\n            IsRequired = true;\n        }\n    }\n}\n')),(0,o.kt)("p",null,"If ",(0,o.kt)("inlineCode",{parentName:"p"},"IsRequired=true"),", we will get a ",(0,o.kt)("inlineCode",{parentName:"p"},"Logger:MacroWarn")," warning in our output if we run the macro and we have not declared a value for the Field. We can assume it exists in our ",(0,o.kt)("inlineCode",{parentName:"p"},"Function")," now!"),(0,o.kt)("p",null,"A nice trick we can do is if we want to declare a default value for a Field, we can mirror the following structure in our ",(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition"},"MacroDefinition")),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'{\n    Fields = {\n        {\n            Name = "Amount";\n            Type = "number";\n        }\n    }\n    State = {\n        FieldValues = {\n            Amount = 1;\n        }\n    }\n}\n')),(0,o.kt)("p",null,"We may also have an input field that has some specific requirements (e.g., for an ",(0,o.kt)("inlineCode",{parentName:"p"},"Amount")," value, we probably want a positive integer!). We can write these checks in our ",(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition#Function"},"Function")," ofcourse - a cleaner option is this:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'{\n    Fields = {\n        {\n            Name = "Amount";\n            Type = "number";\n            IsRequired = true;\n            Validator = function(value)\n                local hasDecimalComponent = math.floor(value) ~= value\n                local isLessThanZero = value <= 0\n                if hasDecimalComponent or isLessThanZero then\n                    return "Must be a positive non-zero integer"\n                end\n            end\n        }\n    }\n}\n')),(0,o.kt)("p",null,"If there is an issue, return a string detailing the issue. This will be written to the output, along with the context of the Field (Macro, Field Name/Type/Value)"),(0,o.kt)("h3",{id:"bindtoclose"},"BindToClose"),(0,o.kt)("p",null,"Imagine we have a Macro that is running routines (",(0,o.kt)("inlineCode",{parentName:"p"},"macro.State.IsRunning=true"),"), but we then delete the ",(0,o.kt)("inlineCode",{parentName:"p"},"ModuleScript")," for that Macro, or we close the ",(0,o.kt)("a",{parentName:"p",href:"https://developer.roblox.com/en-us/api-reference/class/Plugin"},"Plugin"),"? We could still have code running that would've normally been stopped by toggling the Macro. This is where ",(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition#BindToClose"},"BindToClose")," comes in."),(0,o.kt)("p",null,"Example:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'    local Heartbeat = game:GetService("RunService").Heartbeat\n\n    -- MacroDefinition that, when running, will print the time since the last frame\n    local macroDefinition = {\n        -- ...\n        Function = function(macro, plugin)\n            -- Toggle running state\n            macro:ToggleIsRunning()\n\n            -- Get Variables\n            local isRunning = macro:IsRunning()\n        \n            if isRunning then\n                macro.State.HeartbeatConnection = Heartbeat:Connect(function(dt)\n                    Logger:MacroInfo(macro, ("dt: %f"))\n                end)\n            elseif macro.State.HeartbeatConnection then\n                macro.State.HeartbeatConnection:Disconnect()\n                macro.State.HeartbeatConnection = nil\n            end\n        end;\n        BindToClose = function(macro, plugin)\n            if macro.State.HeartbeatConnection then\n                macro.State.HeartbeatConnection:Disconnect()\n                macro.State.HeartbeatConnection = nil\n            end\n        end;\n        -- ...\n    }\n')),(0,o.kt)("p",null,"In the above situation, toggling ",(0,o.kt)("inlineCode",{parentName:"p"},"IsRunning")," from outside the scope of ",(0,o.kt)("inlineCode",{parentName:"p"},"Function")," will still cause routines to keep running! ",(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition#BindToClose"},"BindToClose")," saves the day by ensuring ",(0,o.kt)("inlineCode",{parentName:"p"},"HeartbeatConnection")," is disconnected."),(0,o.kt)("div",{className:"admonition admonition-tip alert alert--success"},(0,o.kt)("div",{parentName:"div",className:"admonition-heading"},(0,o.kt)("h5",{parentName:"div"},(0,o.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,o.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"12",height:"16",viewBox:"0 0 12 16"},(0,o.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.5 0C3.48 0 1 2.19 1 5c0 .92.55 2.25 1 3 1.34 2.25 1.78 2.78 2 4v1h5v-1c.22-1.22.66-1.75 2-4 .45-.75 1-2.08 1-3 0-2.81-2.48-5-5.5-5zm3.64 7.48c-.25.44-.47.8-.67 1.11-.86 1.41-1.25 2.06-1.45 3.23-.02.05-.02.11-.02.17H5c0-.06 0-.13-.02-.17-.2-1.17-.59-1.83-1.45-3.23-.2-.31-.42-.67-.67-1.11C2.44 6.78 2 5.65 2 5c0-2.2 2.02-4 4.5-4 1.22 0 2.36.42 3.22 1.19C10.55 2.94 11 3.94 11 5c0 .66-.44 1.78-.86 2.48zM4 14h5c-.23 1.14-1.3 2-2.5 2s-2.27-.86-2.5-2z"}))),"tip")),(0,o.kt)("div",{parentName:"div",className:"admonition-content"},(0,o.kt)("p",{parentName:"div"},"Naturally when ",(0,o.kt)("inlineCode",{parentName:"p"},"BindToClose")," is called by ",(0,o.kt)("strong",{parentName:"p"},"Socket"),", we also toggle ",(0,o.kt)("inlineCode",{parentName:"p"},"IsRunning=false")," - so if you hade a routine like:"),(0,o.kt)("pre",{parentName:"div"},(0,o.kt)("code",{parentName:"pre",className:"language-lua"},"while macro.State.IsRunning do\n-- ...\nend\n")),(0,o.kt)("p",{parentName:"div"},"The loop would stop and does not require a ",(0,o.kt)("inlineCode",{parentName:"p"},"BindToClose")," function. We also cleanup the ",(0,o.kt)("inlineCode",{parentName:"p"},"RunJanitor")," when ",(0,o.kt)("inlineCode",{parentName:"p"},"BindToClose")," is called. We can pass any Instances, or other routines, to the ",(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition#RunJanitor"},"RunJanitor")," to be cleaned up when the Macro stops running. Check out the API ",(0,o.kt)("a",{parentName:"p",href:"/api/MacroDefinition#BindToClose"},"here")))),(0,o.kt)("p",null,"The above example was to demonstrate the functionality of ",(0,o.kt)("inlineCode",{parentName:"p"},"BindToClose"),"; a much cleaner structure would be:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'    local Heartbeat = game:GetService("RunService").Heartbeat\n\n    -- MacroDefinition that, when running, will print the time since the last frame\n    local macroDefinition = {\n        -- ...\n        Function = function(macro, plugin)\n            -- Toggle running state\n            macro:ToggleIsRunning()\n\n            -- RETURN: Not running\n            if not macro:IsRunning() then\n                return\n            end\n\n            -- Setup Loop\n            macro.RunJanitor:Add(Heartbeat:Connect(function(dt)\n                Logger:MacroInfo(macro, ("dt: %f"))\n            end))\n        end\n        -- ...\n    }\n')))}m.isMDXComponent=!0},56013:function(e,n){n.Z="data:image/png;base64,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"}}]);