"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[553],{3905:(e,t,o)=>{o.d(t,{Zo:()=>s,kt:()=>m});var n=o(67294);function r(e,t,o){return t in e?Object.defineProperty(e,t,{value:o,enumerable:!0,configurable:!0,writable:!0}):e[t]=o,e}function a(e,t){var o=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),o.push.apply(o,n)}return o}function i(e){for(var t=1;t<arguments.length;t++){var o=null!=arguments[t]?arguments[t]:{};t%2?a(Object(o),!0).forEach((function(t){r(e,t,o[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(o)):a(Object(o)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(o,t))}))}return e}function l(e,t){if(null==e)return{};var o,n,r=function(e,t){if(null==e)return{};var o,n,r={},a=Object.keys(e);for(n=0;n<a.length;n++)o=a[n],t.indexOf(o)>=0||(r[o]=e[o]);return r}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(n=0;n<a.length;n++)o=a[n],t.indexOf(o)>=0||Object.prototype.propertyIsEnumerable.call(e,o)&&(r[o]=e[o])}return r}var p=n.createContext({}),c=function(e){var t=n.useContext(p),o=t;return e&&(o="function"==typeof e?e(t):i(i({},t),e)),o},s=function(e){var t=c(e.components);return n.createElement(p.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},u=n.forwardRef((function(e,t){var o=e.components,r=e.mdxType,a=e.originalType,p=e.parentName,s=l(e,["components","mdxType","originalType","parentName"]),u=c(o),m=r,h=u["".concat(p,".").concat(m)]||u[m]||d[m]||a;return o?n.createElement(h,i(i({ref:t},s),{},{components:o})):n.createElement(h,i({ref:t},s))}));function m(e,t){var o=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var a=o.length,i=new Array(a);i[0]=u;var l={};for(var p in t)hasOwnProperty.call(t,p)&&(l[p]=t[p]);l.originalType=e,l.mdxType="string"==typeof e?e:r,i[1]=l;for(var c=2;c<a;c++)i[c]=o[c];return n.createElement.apply(null,i)}return n.createElement.apply(null,o)}u.displayName="MDXCreateElement"},57784:(e,t,o)=>{o.r(t),o.d(t,{assets:()=>p,contentTitle:()=>i,default:()=>d,frontMatter:()=>a,metadata:()=>l,toc:()=>c});var n=o(87462),r=(o(67294),o(3905));const a={sidebar_position:2},i="Installation",l={unversionedId:"Installation",id:"Installation",title:"Installation",description:"Method 1 - Plugin",source:"@site/docs/Installation.md",sourceDirName:".",slug:"/Installation",permalink:"/Socket/docs/Installation",draft:!1,editUrl:"https://github.com/JoelBrd/Socket/edit/main/docs/Installation.md",tags:[],version:"current",sidebarPosition:2,frontMatter:{sidebar_position:2},sidebar:"defaultSidebar",previous:{title:"Introduction",permalink:"/Socket/docs/intro"},next:{title:"Adding Your First Macro",permalink:"/Socket/docs/YourFirstMacro"}},p={},c=[{value:"Method 1 - Plugin",id:"method-1---plugin",level:3},{value:"Method 2 - Git",id:"method-2---git",level:3},{value:"(1) Clone the repository to your local machine",id:"1-clone-the-repository-to-your-local-machine",level:4},{value:"(2) Use Wally to download the dependencies",id:"2-use-wally-to-download-the-dependencies",level:4},{value:"(3) Use Rojo to sync the project onto a Roblox Studio place",id:"3-use-rojo-to-sync-the-project-onto-a-roblox-studio-place",level:4},{value:"(4) Compile the plugin",id:"4-compile-the-plugin",level:4}],s={toc:c};function d(e){let{components:t,...o}=e;return(0,r.kt)("wrapper",(0,n.Z)({},s,o,{components:t,mdxType:"MDXLayout"}),(0,r.kt)("h1",{id:"installation"},"Installation"),(0,r.kt)("h3",{id:"method-1---plugin"},"Method 1 - Plugin"),(0,r.kt)("p",null,"Download the plugin ",(0,r.kt)("a",{parentName:"p",href:"https://www.roblox.com/library/9988470603/Socket"},"here")," via Roblox"),(0,r.kt)("h3",{id:"method-2---git"},"Method 2 - Git"),(0,r.kt)("p",null,"If you don't trust Method 1 (I get it!), you can download the ",(0,r.kt)("a",{parentName:"p",href:"https://github.com/JoelBrd/Socket"},"repo")," and compile the plugin yourself!"),(0,r.kt)("h4",{id:"1-clone-the-repository-to-your-local-machine"},"(1) Clone the repository to your local machine"),(0,r.kt)("ol",null,(0,r.kt)("li",{parentName:"ol"},"Open up the terminal"),(0,r.kt)("li",{parentName:"ol"},"Route to your desired directory"),(0,r.kt)("li",{parentName:"ol"},"Run ",(0,r.kt)("inlineCode",{parentName:"li"},"git clone https://github.com/JoelBrd/Socket"))),(0,r.kt)("div",{className:"admonition admonition-info alert alert--info"},(0,r.kt)("div",{parentName:"div",className:"admonition-heading"},(0,r.kt)("h5",{parentName:"div"},(0,r.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,r.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"14",height:"16",viewBox:"0 0 14 16"},(0,r.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M7 2.3c3.14 0 5.7 2.56 5.7 5.7s-2.56 5.7-5.7 5.7A5.71 5.71 0 0 1 1.3 8c0-3.14 2.56-5.7 5.7-5.7zM7 1C3.14 1 0 4.14 0 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm1 3H6v5h2V4zm0 6H6v2h2v-2z"}))),"info")),(0,r.kt)("div",{parentName:"div",className:"admonition-content"},(0,r.kt)("p",{parentName:"div"},"Unsure what the terminal is? Wonder how to route to a desired directory? Got no idea what ",(0,r.kt)("inlineCode",{parentName:"p"},"git")," is? Check ",(0,r.kt)("a",{parentName:"p",href:"https://www.youtube.com/watch?v=X5e3xQBeqf8&ab_channel=ElektorTV"},"this video")," out, or strongly consider using ",(0,r.kt)("strong",{parentName:"p"},"Method 1")))),(0,r.kt)("h4",{id:"2-use-wally-to-download-the-dependencies"},"(2) Use ",(0,r.kt)("a",{parentName:"h4",href:"https://wally.run/"},"Wally")," to download the dependencies"),(0,r.kt)("p",null,"Socket uses ",(0,r.kt)("a",{parentName:"p",href:"https://roblox.github.io/roact/"},"Roact"),", ",(0,r.kt)("a",{parentName:"p",href:"https://github.com/Roblox/rodux"},"Rodux"),", ",(0,r.kt)("a",{parentName:"p",href:"https://roblox.github.io/roact-rodux/guide/usage/"},"Roact-Rodux"),",\n",(0,r.kt)("a",{parentName:"p",href:"https://github.com/evaera/roblox-lua-promise"},"Promise")," and ",(0,r.kt)("a",{parentName:"p",href:"https://github.com/howmanysmall/Janitor"},"Janitor"),"!"),(0,r.kt)("ol",null,(0,r.kt)("li",{parentName:"ol"},"Download ",(0,r.kt)("a",{parentName:"li",href:"https://wally.run/"},"Wally")," onto your machine"),(0,r.kt)("li",{parentName:"ol"},"Open ",(0,r.kt)("inlineCode",{parentName:"li"},"...\\Socket\\src\\Shared\\Libraries")," in the terminal "),(0,r.kt)("li",{parentName:"ol"},"Run the comamnd ",(0,r.kt)("inlineCode",{parentName:"li"},"wally install"))),(0,r.kt)("h4",{id:"3-use-rojo-to-sync-the-project-onto-a-roblox-studio-place"},"(3) Use ",(0,r.kt)("a",{parentName:"h4",href:"https://rojo.space/"},"Rojo")," to sync the project onto a Roblox Studio place"),(0,r.kt)("p",null,"Please see the ",(0,r.kt)("a",{parentName:"p",href:"https://rojo.space/docs/v7/"},"Rojo Docs")," on how to do this"),(0,r.kt)("h4",{id:"4-compile-the-plugin"},"(4) Compile the plugin"),(0,r.kt)("ol",null,(0,r.kt)("li",{parentName:"ol"},"Select ",(0,r.kt)("inlineCode",{parentName:"li"},"game.ServerScriptService.SocketPlugin")," ",(0,r.kt)("strong",{parentName:"li"},"and")," ",(0,r.kt)("inlineCode",{parentName:"li"},"game.ServerScriptService.SocketPlugin.PluginFramework")),(0,r.kt)("li",{parentName:"ol"},"Right Click ",(0,r.kt)("inlineCode",{parentName:"li"},"game.ServerScriptService.SocketPlugin")," -> Save as Local Plugin"),(0,r.kt)("li",{parentName:"ol"},"After selecting a name and saving, ",(0,r.kt)("strong",{parentName:"li"},"Socket")," should appear on your plugin toolbar!")))}d.isMDXComponent=!0}}]);