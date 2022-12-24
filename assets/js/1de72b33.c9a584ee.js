"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[305],{3905:(e,t,r)=>{r.d(t,{Zo:()=>s,kt:()=>m});var n=r(67294);function o(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function a(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function i(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?a(Object(r),!0).forEach((function(t){o(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):a(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function l(e,t){if(null==e)return{};var r,n,o=function(e,t){if(null==e)return{};var r,n,o={},a=Object.keys(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||(o[r]=e[r]);return o}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(o[r]=e[r])}return o}var c=n.createContext({}),u=function(e){var t=n.useContext(c),r=t;return e&&(r="function"==typeof e?e(t):i(i({},t),e)),r},s=function(e){var t=u(e.components);return n.createElement(c.Provider,{value:t},e.children)},p={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},d=n.forwardRef((function(e,t){var r=e.components,o=e.mdxType,a=e.originalType,c=e.parentName,s=l(e,["components","mdxType","originalType","parentName"]),d=u(r),m=o,f=d["".concat(c,".").concat(m)]||d[m]||p[m]||a;return r?n.createElement(f,i(i({ref:t},s),{},{components:r})):n.createElement(f,i({ref:t},s))}));function m(e,t){var r=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var a=r.length,i=new Array(a);i[0]=d;var l={};for(var c in t)hasOwnProperty.call(t,c)&&(l[c]=t[c]);l.originalType=e,l.mdxType="string"==typeof e?e:o,i[1]=l;for(var u=2;u<a;u++)i[u]=r[u];return n.createElement.apply(null,i)}return n.createElement.apply(null,r)}d.displayName="MDXCreateElement"},19094:(e,t,r)=>{r.r(t),r.d(t,{assets:()=>c,contentTitle:()=>i,default:()=>p,frontMatter:()=>a,metadata:()=>l,toc:()=>u});var n=r(87462),o=(r(67294),r(3905));const a={sidebar_position:8},i="Changelog",l={unversionedId:"Changelog",id:"Changelog",title:"Changelog",description:"v1.2.0",source:"@site/docs/Changelog.md",sourceDirName:".",slug:"/Changelog",permalink:"/Socket/docs/Changelog",draft:!1,editUrl:"https://github.com/JoelBrd/Socket/edit/main/docs/Changelog.md",tags:[],version:"current",sidebarPosition:8,frontMatter:{sidebar_position:8},sidebar:"defaultSidebar",previous:{title:"Contributing",permalink:"/Socket/docs/Contributing"}},c={},u=[{value:"v1.2.0",id:"v120",level:2},{value:"v1.2.1",id:"v121",level:3},{value:"v1.1.0",id:"v110",level:2},{value:"v1.0.0",id:"v100",level:2}],s={toc:u};function p(e){let{components:t,...r}=e;return(0,o.kt)("wrapper",(0,n.Z)({},s,r,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"changelog"},"Changelog"),(0,o.kt)("h2",{id:"v120"},"v1.2.0"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},"Fix issues with docking from the recent Studio overhaul"),(0,o.kt)("li",{parentName:"ul"},"Fixed bug with Local Macros where ",(0,o.kt)("inlineCode",{parentName:"li"},"ModuleScripts")," with duplicate names would silently not get saved"),(0,o.kt)("li",{parentName:"ul"},'Removed "Clone" built-in macro, as this behaviour mirrors ',(0,o.kt)("inlineCode",{parentName:"li"},"Ctrl+D")),(0,o.kt)("li",{parentName:"ul"},"Add in luau type definitions"),(0,o.kt)("li",{parentName:"ul"},'Update "Create Macro" macro to use luau type definitions for better UX')),(0,o.kt)("h3",{id:"v121"},"v1.2.1"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},"Fix typo with luau type ",(0,o.kt)("inlineCode",{parentName:"li"},"MacroField.Validator"))),(0,o.kt)("h2",{id:"v110"},"v1.1.0"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},"Added Local Macros (see ",(0,o.kt)("a",{parentName:"li",href:"/api/MacroDefinition#IsLocalMacro"},"IsLocalMacro"),"), which allows replication of macros across multiple places via the ",(0,o.kt)("inlineCode",{parentName:"li"},"plugin")," itself."),(0,o.kt)("li",{parentName:"ul"},"Added ",(0,o.kt)("inlineCode",{parentName:"li"},"LocalMacroColor")," setting"),(0,o.kt)("li",{parentName:"ul"},"Improved logic behind the settings system to be more scalable + easier to add new settings of different types")),(0,o.kt)("h2",{id:"v100"},"v1.0.0"),(0,o.kt)("p",null,"Release!"))}p.isMDXComponent=!0}}]);