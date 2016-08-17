define("appmsg/emotion/caret.js",[],function(e,t){
"use strict";
var t={};
return t.get=function(e){
var t=0;
if(document.selection){
e.focus();
var a=document.selection.createRange();
a.moveStart("character",-e.value.length),t=Sel.text.length;
}else(e.selectionStart||"0"==e.selectionStart)&&(t=e.selectionStart);
return t;
},t.set=function(e,t){
if(e.setSelectionRange)e.focus(),e.setSelectionRange(t,t);else if(e.createTextRange){
var a=e.createTextRange();
a.collapse(!0),a.moveEnd("character",t),a.moveStart("character",t),a.select();
}
},t;
});define("biz_wap/jsapi/cardticket.js",["biz_wap/jsapi/core.js"],function(e){
"use strict";
var c=e("biz_wap/jsapi/core.js"),r={
openCardDetail:function(e){
function r(){
c.invoke("openCardDetail",{
card_id:e.card_id,
card_ext:e.card_ext
},function(c){
"open_card_detail:fail"==c.err_msg||"open_card_detail:ok"==c.err_msg||"open_card_detail:cancel"==c.err_msg?e.success&&e.success(c):c.err_msg.indexOf("function_not_exist")>=0?e.function_not_exist&&e.function_not_exist():"system:access_denied"==c.err_msg?e.access_denied&&e.access_denied("openCardDetail"):e.error&&e.error(c);
});
}
function n(){
c.invoke("batchAddCard",{
card_list:[{
card_id:e.card_id,
card_ext:e.card_ext
}]
},function(c){
"batch_add_card:ok"==c.err_msg||"batch_add_card:fail"==c.err_msg||"batch_add_card:cancel"==c.err_msg?e.success&&e.success(c):c.err_msg.indexOf("function_not_exist")>=0?r():"system:access_denied"==c.err_msg?e.access_denied&&e.access_denied("batchAddCard"):e.error&&e.error(c);
});
}
n();
},
supportCardDetail:function(e){
c.invoke("openCardDetail",{
card_id:"err_id"
},function(c){
e.callback(c.err_msg.indexOf("function_not_exist")>=0?!1:!0);
});
},
openCard:function(e){
c.invoke("batchViewCard",{
cardList:[{
cardId:e.cardId,
code:e.code
}]
},function(c){
c.err_msg.indexOf("function_not_exist")>=0?e.function_not_exist&&e.function_not_exist():e.success&&e.success(c);
});
}
};
return r;
});define("appmsg/emotion/map.js",[],function(){
"use strict";
return["微笑","撇嘴","色","发呆","得意","流泪","害羞","闭嘴","睡","大哭","尴尬","发怒","调皮","呲牙","惊讶","难过","酷","冷汗","抓狂","吐","偷笑","可爱","白眼","傲慢","饥饿","困","惊恐","流汗","憨笑","大兵","奋斗","咒骂","疑问","嘘","晕","折磨","衰","骷髅","敲打","再见","擦汗","抠鼻","鼓掌","糗大了","坏笑","左哼哼","右哼哼","哈欠","鄙视","委屈","快哭了","阴险","亲亲","吓","可怜","菜刀","西瓜","啤酒","篮球","乒乓","咖啡","饭","猪头","玫瑰","凋谢","示爱","爱心","心碎","蛋糕","闪电","炸弹","刀","足球","瓢虫","便便","月亮","太阳","礼物","拥抱","强","弱","握手","胜利","抱拳","勾引","拳头","差劲","爱你","NO","OK","爱情","飞吻","跳跳","发抖","怄火","转圈","磕头","回头","跳绳","挥手","激动","街舞","献吻","左太极","右太极"];
});define("appmsg/emotion/textarea.js",["appmsg/emotion/map.js","appmsg/emotion/dom.js","appmsg/emotion/caret.js","biz_common/dom/class.js"],function(e,n){
"use strict";
function t(){
var e="translate3d(0, 0, 0)";
l.css({
webkitTransform:e,
transform:e
});
}
function a(){
var e=8;
l.on("keydown",function(n){
n.keyCode===e&&s(!0)&&n.preventDefault();
});
}
function s(e){
function n(){
var e=a-1;
0>e&&(e=0);
var n=s.slice(0,e),o=s.slice(a),i=+new Date;
t.value=n+o,p.set(t,e),r(+new Date-i);
}
var t=l.el[0],a=p.get(t),s=t.value,i=4,c=a-i;
0>c&&(c=0,i=a-c);
var m=s.slice(c,a),v=m.match(/\/([\u4e00-\u9fa5\w]+)$/g);
if(v){
var d=v[0],g=i-d.length,b=d.replace("/","");
if(o(b)){
var j=m.replace(d,""),_=s.slice(0,c)+j+s.slice(a),w=+new Date;
t.value=_,p.set(t,c+g),r(+new Date-w);
}else{
if(e)return!1;
n();
}
}else{
if(e)return!1;
n();
}
return e?(t.focus(),f.later(function(){
t.focus();
})):(t.blur(),f.later(function(){
t.blur();
})),u(t.value),!0;
}
function o(e){
for(var n=0,t=m.length;t>n;n++)if(m[n]==e)return!0;
return!1;
}
function i(e){
var n=l.el[0],t=p.get(n),a=n.value,a=a.slice(0,t)+"/"+e+a.slice(t);
n.value=a,p.set(n,t+e.length+1),n.blur(),f.later(function(){
n.blur();
}),u(a);
}
function r(){}
function u(e){
var n=c.el[0];
e.length<1?v.addClass(n,"btn_disabled"):v.removeClass(n,"btn_disabled");
}
var l,c,n={},m=e("appmsg/emotion/map.js"),f=e("appmsg/emotion/dom.js"),p=e("appmsg/emotion/caret.js"),v=e("biz_common/dom/class.js");
return n.init=function(){
l=f("#js_cmt_input"),c=f("#js_cmt_submit"),t(),a();
},n.inputEmotion=function(e,n){
-1===e?s(n):i(m[e-1]);
},n;
});define("appmsg/emotion/nav.js",["appmsg/emotion/common.js","appmsg/emotion/dom.js"],function(n,o){
"use strict";
var t=n("appmsg/emotion/common.js"),a=n("appmsg/emotion/dom.js"),m=a.each,o={};
return o.activeNav=function(n){
t.currentPage=n;
var o=t.navs;
m(o,function(t,a){
a===n?o[a].attr("class","emotion_nav current"):o[a].attr("class","emotion_nav");
});
},o;
});define("appmsg/emotion/common.js",[],function(){
"use strict";
return{
EMOTIONS_COUNT:105,
EMOTION_LI_SIZE:36,
EMOTION_SIZE:24
};
});define("appmsg/emotion/slide.js",["appmsg/emotion/common.js","appmsg/emotion/dom.js","appmsg/emotion/nav.js"],function(n,t){
"use strict";
function o(){
function n(n){
n.preventDefault(),n.stopPropagation(),l||(g=!0,i=a(n),m.isMoved=!1,u=+new Date);
}
function t(n){
n.preventDefault(),n.stopPropagation(),!l&&g&&(r=a(n),h=r-i,e(),Math.abs(h)>6&&(m.isMoved=!0));
}
function o(){
l||(g=!1,s());
}
function a(n){
return n.touches&&n.touches.length>0?n.touches[0].clientX:n.clientX;
}
var i,r,u;
c.on("touchstart",n),c.on("mousedown",n),c.on("touchmove",t),c.on("mousemove",t),
c.on("touchend",o),c.on("mouseup",o);
}
function e(){
var n=m.WIDTH,t=-d*n+h,o=n/4;
t>o?t=o:u-o>t&&(t=u-o);
var e="translate3d("+t+"px, 0, 0)";
c.css({
webkitTransform:e,
transform:e
});
}
function s(){
var n=m.WIDTH,t=55,o=parseInt(h/n),e=h%n;
d-=o,Math.abs(e)>t&&(d-=Math.abs(e)/e*1),d>m.pageCount-1?d=m.pageCount-1:0>d&&(d=0),
h=0,a(d);
}
function a(n){
l=!0,f=-n*m.WIDTH,i(),e(),setTimeout(function(){
l=!1,r();
},T),v.activeNav(n);
}
function i(){
var n="all 0.3s ease";
c.css({
transition:n,
webkitTransition:n
});
}
function r(){
var n=c.el[0].style;
n.transition="",n.webkitTransition="";
}
var u,m=n("appmsg/emotion/common.js"),p=n("appmsg/emotion/dom.js"),t={},c=p("#js_slide_wrapper"),f=0,v=n("appmsg/emotion/nav.js"),l=!1,d=0,g=!1,h=0;
t.init=function(){
u=-m.wrapperWidth+m.WIDTH,o();
var n="translate3d(0, 0, 0)";
c.css({
webkitTransform:n,
transform:n
});
};
var T=300;
return t;
});define("pages/report.js",["biz_wap/utils/ajax.js","pages/version4video.js"],function(e){
"use strict";
function i(e){
var i=["/mp/pagereport?type=","undefined"==typeof e.type?1:e.type,"&comment_id=",e.comment_id||"","&voiceid=",e.voiceid||"","&action=",e.action,"&__biz=",top.window.biz||"","&mid=",top.window.mid||"","&idx=",top.window.idx||"","&uin=",top.window.uin||"","&key=",top.window.key||"","&pass_ticket=",top.window.pass_ticket||"","&t=",Math.random(),"#wechat_redirect"].join(""),t=new Image;
t.src=i;
}
function t(e){
_({
type:"POST",
url:"/mp/videoreport?#wechat_redirect",
timeout:2e4,
async:!1,
data:e.data
});
}
function o(e){
var i=e.data;
i.musicid=i.musicid.join(";"),i.hasended=i.hasended.join(";"),i.commentid=i.commentid.join(";"),
i.mtitle=i.mtitle.join(";#"),i.detail_click=i.detail_click.join(";"),i.duration=i.duration.join(";"),
i.errorcode=i.errorcode.join(";"),i.play_duration=i.play_duration.join(";"),_({
type:"POST",
url:"/mp/musicreport?#wechat_redirect",
timeout:2e4,
async:!1,
data:i
});
}
function n(e){
document.domain="qq.com";
var i=window.cgiData&&window.cgiData.openid?window.cgiData.openid:"",t=encodeURIComponent(top.window.location.href.replace(/(\?|&)(key|uin)=([\S\s]*?)(&|$)/g,"$1").replace(/&$/,"")),o=["http://btrace.qq.com/kvcollect?BossId=2973&Pwd=1557019983&step=1009&vid=","undefined"!=typeof e.vid?e.vid:"","&platform=",a(),"&val=","undefined"!=typeof e.val?e.val:"","&val1=","undefined"!=typeof e.val1?e.val1:"","&vurl=",encodeURIComponent(e.vurl),"&t=",Math.random(),"&url=",t,"&wx_openid=",i].join(""),n=new Image;
n.src=o.substr(0,1024);
}
function d(e){
if(3==e.step||6==e.step||1999==e.step){
document.domain="qq.com";
var i=window.cgiData&&window.cgiData.openid?window.cgiData.openid:"",t=encodeURIComponent(top.window.location.href.replace(/(\?|&)(key|uin)=([\S\s]*?)(&|$)/g,"$1").replace(/&$/,"")),o=["http://btrace.qq.com/kvcollect?BossId=2973&Pwd=1557019983&step=",e.step,"&vid=","undefined"!=typeof e.vid?e.vid:"","&platform=",a(),"&loadwait=","undefined"!=typeof e.loadwait?e.loadwait:"","&val=","undefined"!=typeof e.val?e.val:"","&t=",Math.random(),"&url=",t,"&wx_openid=",i].join(""),n=new Image;
n.src=o.substr(0,1024);
}
}
function a(){
var e=l.device;
return e.ipad?60101:e.is_android_phone?60301:e.iphone?60401:e.is_android_tablet?60501:"";
}
function r(){
var e=l.device;
return e.ipad?"v4010":e.is_android_phone&&l.isUseProxy()?"v5060":e.is_android_phone?"v5010":e.iphone&&l.isUseProxy()?"v3060":e.iphone?"v3010":e.is_android_tablet?"v6010":"";
}
function p(e){
var i={
mid:window.mid||"",
__biz:window.biz||"",
idx:window.idx||"",
musicid:[],
hasended:[],
commentid:[],
scene_type:e.type||0,
mtitle:[],
detail_click:[],
app_btn_kv:0,
app_btn_click:0,
app_btn_type:0,
duration:[],
play_duration:[],
errorcode:[]
};
return i;
}
function c(){
var e={
videoerror:0,
like_kv_vid:"",
like_click_vid:"",
like_kv_alginfo:"",
like_click_alginfo:"",
tad:"",
page:0,
like_click_type:0,
iplat:2,
ptype:1,
rtype:"",
getvinfo_ret:-1,
getvinfo_time:0,
v_err_code:0,
loadwait:0,
hasended:0,
last_ms:0,
duration_ms:0,
app_btn_kv:0,
app_btn_click:0,
app_btn_type:0,
mid:"",
__biz:"",
idx:"",
detail_click:0,
vtitle:"",
vid:"",
commentid:"",
scene_type:"",
replay:0,
full_screen:0,
quick_play:0,
ad_play_time:-1,
video_play_time:-1,
click_play_button:0,
traceid:"",
webviewid:"",
orderid:0,
play_time:0,
client_time_when_play:0,
drag_times:"",
pause_num:0,
h5_profile:0,
to_article:0,
desc_more_click:0,
desc_more_show:0
};
return e;
}
var _=e("biz_wap/utils/ajax.js"),l=e("pages/version4video.js");
return{
report:i,
videoreport:t,
getPlatformType:a,
getsdtfrom:r,
getinfoReport:n,
qqvideo_common_report:d,
musicreport:o,
getMusicReportData:p,
getVideoReportData:c
};
});define("pages/music_player.js",["biz_common/dom/event.js","biz_wap/jsapi/core.js","pages/version4video.js","biz_common/utils/monitor.js"],function(t){
"use strict";
function o(t){
this._o={
type:0,
src:"",
mid:"",
songId:"",
autoPlay:!1,
duration:0,
debug:!1,
needVioceMutex:!0,
appPlay:!0,
title:"",
singer:"",
epname:"",
coverImgUrl:"",
webUrl:"",
onStatusChange:function(){},
onTimeupdate:function(){},
onError:function(){}
},this._extend(t),this._status=-1,this._g={},0!==l.surportType&&(this._o.needVioceMutex&&l.mutexPlayers.push(this),
this._o.autoPlay&&this.play());
}
function i(t){
_.invoke("musicPlay",{
app_id:"a",
title:"微信公众平台",
singer:"微信公众平台",
epname:"微信公众平台",
coverImgUrl:"http://res.wx.qq.com/mpres/htmledition/images/favicon.ico",
dataUrl:l.ev,
lowbandUrl:l.ev,
webUrl:"http://mp.weixin.qq.com/s?"
},function(o){
"function"==typeof t&&t(o);
});
}
function e(t){
for(var o=0,i=l.mutexPlayers.length;i>o;o++){
var e=l.mutexPlayers[o];
e&&"function"==typeof e._onPause&&e!=t&&(e._h5Audio&&"function"==typeof e._h5Audio.pause?e._h5Audio.pause():1==e.getSurportType()&&e._pauseJsapiPlay(!1));
}
}
function n(){
return l.surportType;
}
function s(t){
return new o(t);
}
function a(){
l.surportType>0&&l.isAndroidLow&&window.addEventListener("canplay",function(t){
t.target&&"function"==typeof t.target.play&&t.target.play();
},!0);
}
function u(){
for(var t=0,o=l.keyConf.length;o>t;t++){
var i=l.keyConf[t];
l.reportData[i]={
key:t,
count:0
};
}
h.on(window,"unload",r);
}
function r(){
for(var t=0,o=l.mutexPlayers.length;o>t;t++){
var i=l.mutexPlayers[t];
if(i&&1==i._status&&1==i._surportType){
d(i._o.type,"unload_wx_pv",1);
break;
}
}
p();
}
function p(){
var t=l.reportId;
if(1==parseInt(10*Math.random())||l.debug){
for(var o in l.reportData){
var i=l.reportData[o];
i.count>0&&y.setSum(t,i.key,i.count);
}
y.send();
}
}
function d(t,o,i){
0==t||1==t?o="m_"+o:(2==t||3==t)&&(o="v_"+o),l.reportData[o]&&(i=i||1,l.reportData[o].count+=i,
l.debug&&console.log("addpv:"+o+" count:"+l.reportData[o].count));
}
var h=t("biz_common/dom/event.js"),_=t("biz_wap/jsapi/core.js"),c=t("pages/version4video.js"),y=t("biz_common/utils/monitor.js"),l={
hasCheckJsapi:!1,
ev:window._empty_v,
isAndroidLow:/android\s2\.3/i.test(navigator.userAgent),
surportType:"addEventListener"in window?2:0,
mutexPlayers:[],
reportId:"28306",
keyConf:["m_pv","m_wx_pv","m_h5_pv","m_unload_wx_pv","v_pv","v_wx_pv","v_h5_pv","v_unload_wx_pv","no_copyright","copyright_cgi_err","copyright_net_err","copyright_timeout","copyright_other_err","overseas","fee","musicid_error"],
reportData:{},
debug:-1!=location.href.indexOf("&_debug=1")?!0:!1
};
return u(),a(),o.prototype._createAutoAndPlay=function(){
if(this._h5Audio=document.createElement("audio"),this._H5bindEvent(),this._h5Audio.setAttribute("style","height:0;width:0;display:none"),
this._h5Audio.setAttribute("autoplay",""),this._status=0,l.isAndroidLow)this._h5Audio.src=this._o.src,
document.body.appendChild(this._h5Audio),this._h5Audio.load();else{
document.body.appendChild(this._h5Audio);
var t=this;
setTimeout(function(){
t._h5Audio.src=t._o.src,t._h5Audio.play();
},0);
}
this._surportType=2;
},o.prototype._destoryH5Audio=function(){
this._h5Audio&&"function"==typeof this._h5Audio.pause&&(this._h5Audio.pause(),document.body.removeChild(this._h5Audio),
this._h5Audio=null,this._status=-1,this._surportType=0);
},o.prototype._createApp=function(t){
this._h5Audio&&this._destoryH5Audio();
var o=this,i=this._o;
_.invoke("musicPlay",{
app_id:"a",
title:i.title,
singer:i.singer,
epname:i.epname,
coverImgUrl:i.coverImgUrl,
dataUrl:i.src,
lowbandUrl:i.src,
webUrl:i.webUrl
},function(e){
o._g.checkJsapiTimeoutId&&clearTimeout(o._g.checkJsapiTimeoutId),e.err_msg.indexOf("ok")>=0?(d(o._o.type,"wx_pv",1),
o._surportType=1,l.surportType=1,o.jsApiData&&o.jsApiData.updateTimeoutId&&clearTimeout(o.jsApiData.updateTimeoutId),
o.jsApiData={
starTime:+new Date,
curTime:0,
updateTimeoutId:null,
duration:i.duration||void 0
},o._onPlay(),"undefined"!=typeof i.duration&&1*i.duration>0&&o._analogUpdateTime()):2===l.surportType?o._h5Play(t):o._onError({},15);
});
},o.prototype._analogUpdateTime=function(){
function t(){
return i.curTime=1*((+new Date-i.starTime)/1e3).toFixed(2),i.curTime>=i.duration?void o._stopJsapiPlay(!1):(o._onTimeupdate(null,i.curTime),
void(i.updateTimeoutId=setTimeout(function(){
t();
},1e3)));
}
var o=this,i=o.jsApiData;
t();
},o.prototype._onPlay=function(t){
this._status=1;
try{
e(this);
}catch(t){}
"function"==typeof this._o.onStatusChange&&this._o.onStatusChange.call(this,t||{},this._status);
},o.prototype._onPause=function(t){
this._status=2,"function"==typeof this._o.onStatusChange&&this._o.onStatusChange.call(this,t||{},this._status);
},o.prototype._onEnd=function(t){
this._status=3,"function"==typeof this._o.onStatusChange&&this._o.onStatusChange.call(this,t||{},this._status);
},o.prototype._onLoadedmetadata=function(t){
"function"==typeof this._o.onLoadedmetadata&&this._o.onLoadedmetadata.call(this,t||{});
},o.prototype._onTimeupdate=function(t,o){
"function"==typeof this._o.onTimeupdate&&this._o.onTimeupdate.call(this,t||{},o);
},o.prototype._onError=function(t,o){
this._status=-1,"function"==typeof this._o.onError&&this._o.onError.call(this,t||{},o);
},o.prototype._H5bindEvent=function(){
var t=this;
this._h5Audio.addEventListener("play",function(o){
t._onPlay(o);
},!1),this._h5Audio.addEventListener("ended",function(o){
t._onEnd(o);
},!1),this._h5Audio.addEventListener("pause",function(o){
t._onPause(o);
},!1),this._h5Audio.addEventListener("error",function(o){
var i=o.target.error.code;
(1>i||i>5)&&(i=5),t._onError(o,i);
},!1),"function"==typeof this._o.onTimeupdate&&this._h5Audio.addEventListener("timeupdate",function(o){
t._onTimeupdate(o,t._h5Audio.currentTime);
},!1),"function"==typeof this._o.onLoadedmetadata&&this._h5Audio.addEventListener("loadedmetadata",function(o){
t._onLoadedmetadata(o);
},!1);
},o.prototype._extend=function(t){
for(var o in t)this._o[o]=t[o];
},o.prototype._pauseJsapiPlay=function(t){
this._stopJsapiPlay(t);
},o.prototype._stopJsapiPlay=function(t){
function o(){
n.updateTimeoutId&&clearTimeout(n.updateTimeoutId),n.updateTimeoutId=null,n.curTime=0,
e._onTimeupdate(null,0),e._onEnd();
}
var e=this,n=e.jsApiData;
t?i(function(){
o();
}):o();
},o.prototype._h5Play=function(t){
(2===l.surportType||!this._o.appPlay&&1===l.surportType)&&(d(this._o.type,"h5_pv",1),
this._h5Audio?(this._h5Audio.ended||this._h5Audio.paused)&&(this._h5Audio.ended&&(this._h5Audio.currentTime=0),
"undefined"!=typeof t?(this._h5Audio.currentTime=t,this._h5Audio.play()):this._h5Audio.play()):this._createAutoAndPlay());
},o.prototype.getSurportType=function(){
return this._surportType||0;
},o.prototype.getPlayStatus=function(){
return this._status;
},o.prototype.getCurTime=function(){
return 1==this._surportType&&this.jsApiData?this.jsApiData.curTime||0:this._h5Audio?this._h5Audio.currentTime:0;
},o.prototype.getDuration=function(){
return 1==this._surportType&&this.jsApiData?this.jsApiData.duration||void 0:this._h5Audio?this._h5Audio.duration||this._o.duration:void 0;
},o.prototype.pause=function(){
1==this._surportType?this._pauseJsapiPlay(!0):2==this._surportType&&this._h5Audio&&"function"==typeof this._h5Audio.pause&&this._h5Audio.pause();
},o.prototype.stop=function(){
2==this._surportType&&this._h5Audio?(this._h5Audio.pause(),this._h5Audio.currentTime=0,
this._onEnd()):1==this._surportType&&this._stopJsapiPlay(!0);
},o.prototype.play=function(t){
var o=this,i=this._g;
d(this._o.type,"pv",1),i.checkJsapiTimeoutId&&clearTimeout(i.checkJsapiTimeoutId),
c.device.inWechat&&this._o.appPlay?1!=this._status&&(this._createApp(t),i.checkJsapiTimeoutId=setTimeout(function(){
o._h5Play(t);
},1e3)):this._h5Play(t);
},o.prototype.monitor=function(t,o){
d(-1,t,o);
},{
init:s,
getSurportType:n
};
});define("pages/loadscript.js",[],function(){
"use strict";
function e(t){
e.counter||(e.counter=1);
var n="number"!=typeof t.retry?1:t.retry,o=document.createElement("script"),r=document.head||document.getElementsByTagName("head")[0]||document.documentElement,d=t.url+"&t="+Math.random(),a=t.callbackName,i="uninitialized",u="undefined"==typeof t.successCode?200:t.successCode,c="undefined"==typeof t.timeoutCode?500:t.timeoutCode,l="undefined"==typeof t.scriptErrorCode?400:t.scriptErrorCode,s=!1,f=null,m=function(e){
o&&!s&&(s=!0,f&&(clearTimeout(f),f=null),o.onload=o.onreadystatechange=o.onerror=null,
r&&o.parentNode&&r.removeChild(o),o=null,a&&-1==a.indexOf(".")&&(window[a]=null),
e!=u&&"loaded"!=i&&"function"==typeof t.onerror&&t.onerror(e));
};
if(a&&"function"==typeof t.callback){
var p=a;
-1==a.indexOf(".")&&(a=window[a]?a+e.counter++:a,window[a]=function(){
i="loaded",t.callback.apply(null,arguments);
}),d=d.replace("="+p,"="+a);
}
o.onload=o.onreadystatechange=function(){
var e=navigator.userAgent.toLowerCase();
(-1!=e.indexOf("opera")||-1==e.indexOf("msie")||/loaded|complete/i.test(this.readyState))&&m("loaded"==i?u:l);
},o.onerror=function(){
return n>0?(t.retry=n-1,void e(t)):void m(l);
},t.timeout&&(f=setTimeout(function(){
m(c);
},parseInt(t.timeout,10))),i="loading",o.charset="utf-8",setTimeout(function(){
o.src=d;
try{
r.insertBefore(o,r.lastChild);
}catch(e){}
},0);
}
return e;
});define("appmsg/emotion/dom.js",["biz_common/dom/event.js"],function(t){
"use strict";
function n(t){
if("string"==typeof t)var n=document.querySelectorAll(t);else n=[t];
return{
el:n,
on:function(t,n){
return this.each(function(e){
i.on(e,t,n);
}),this;
},
hide:function(){
return this.each(function(t){
t.style.display="none";
}),this;
},
show:function(){
return this.each(function(t){
t.style.display="block";
}),this;
},
each:function(t){
return e(this.el,t),this;
},
width:function(){
return this.el[0].clientWidth;
},
css:function(t){
return this.each(function(n){
for(var e in t)n.style[e]=t[e];
}),this;
},
attr:function(t,n){
var e=this.el[0];
return n?(e.setAttribute(t,n),this):e.getAttribute(t);
},
append:function(t){
return t.el&&(t=t.el[0]),this.el[0].appendChild(t),this;
},
html:function(t){
this.each(function(n){
n.innerHTML=t;
});
}
};
}
function e(t,n){
for(var e=0,i=t.length;i>e;e++)n(t[e],e);
}
var i=t("biz_common/dom/event.js");
return n.el=function(t){
return document.createElement(t);
},n.later=function(t){
setTimeout(t,3);
},n.log=function(){},n.each=e,n;
});define("appmsg/my_comment_tpl.html.js",[],function(){
return'<!-- 发表留言 -->\n<div id="js_cmt_mine" class="discuss_container editing access" style="display:none;">\n    <div class="discuss_container_inner">\n        <h2 class="rich_media_title"><#=window.msg_title.htmlDecode()#></h2>\n        <span id="log"></span>\n        <div class="frm_textarea_box_wrp">\n            <span class="frm_textarea_box">\n                <textarea id="js_cmt_input" class="frm_textarea" placeholder="留言将由公众号筛选后显示，对所有人可见。"></textarea>\n                <div class="emotion_tool">\n                    <span class="emotion_switch" style="display:none;"></span>\n                    <span id="js_emotion_switch" class="pic_emotion_switch_wrp">\n                        <img class="pic_default" src="<#=window.icon_emotion_switch#>" alt="">\n                        <img class="pic_active" src="<#=window.icon_emotion_switch_active#>" alt="">\n                    </span>\n                    <div class="emotion_panel" id="js_emotion_panel">\n                        <span class="emotion_panel_arrow_wrp" id="js_emotion_panel_arrow_wrp">\n                            <i class="emotion_panel_arrow arrow_out"></i>\n                            <i class="emotion_panel_arrow arrow_in"></i>\n                        </span>\n                        <div class="emotion_list_wrp" id="js_slide_wrapper">\n                            <!--<ul class="emotion_list"></ul>-->\n                            <!--<li class="emotion_item"><i class="icon_emotion"></i></li>-->\n                        </div>\n                        <ul class="emotion_navs" id="js_navbar">\n                            <!--<li class="emotion_nav"></li>-->\n                        </ul>\n                    </div>\n                </div>\n            </span>\n        </div>\n        <div class="discuss_btn_wrp"><a id="js_cmt_submit" class="btn btn_primary btn_discuss btn_disabled" href="javascript:;">提交</a></div>\n        <div class="discuss_list_wrp" style="display:none">\n            <div class="rich_tips with_line title_tips discuss_title_line">\n                <span class="tips">我的留言</span>\n            </div>\n            <ul class="discuss_list" id="js_cmt_mylist"></ul>\n        </div>\n        <div class="rich_tips tips_global loading_tips" id="js_mycmt_loading">\n            <img src="<#=window.icon_loading_white#>" class="rich_icon icon_loading_white" alt="">\n            <span class="tips">加载中</span>\n        </div>\n        <div class="wx_poptips" id="js_cmt_toast" style="display:none;">\n            <img alt="" class="icon_toast" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGoAAABqCAYAAABUIcSXAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3NpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoyMTUxMzkxZS1jYWVhLTRmZTMtYTY2NS0xNTRkNDJiOGQyMWIiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6MTA3QzM2RTg3N0UwMTFFNEIzQURGMTQzNzQzMDAxQTUiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6MTA3QzM2RTc3N0UwMTFFNEIzQURGMTQzNzQzMDAxQTUiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChNYWNpbnRvc2gpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6NWMyOGVjZTMtNzllZS00ODlhLWIxZTYtYzNmM2RjNzg2YjI2IiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjIxNTEzOTFlLWNhZWEtNGZlMy1hNjY1LTE1NGQ0MmI4ZDIxYiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/Pmvxj1gAAAVrSURBVHja7J15rF1TFMbXk74q1ZKHGlMkJVIhIgg1FH+YEpEQJCKmGBpThRoSs5jVVNrSQUvEEENIhGiiNf9BiERICCFIRbUiDa2qvudbOetF3Tzv7XWGffa55/uS7593977n3vO7e5+199p7v56BgQGh0tcmvAUERREUQVEERREUQVEERREUQVEERREUQVEERREUQVEERREUQVEERVAUQVEERVAUQbVYk+HdvZVG8b5F0xj4RvhouB+eCy8KrdzDJc1RtAX8ILxvx98V1GyCSkN98Cx4z/95/Wn4fj6j6tUEeN4wkFSnw1MJqj5NhBfAuwaUHREUg4lqNMmePVsHll/HFhVfe1t3FwpJI8DXCCquDrCWNN4B6Tb4M3Z98aTPmTvh0YHl18PXw29yZiKejoPvcUD6E74yFBJbVDk6Bb7K8aP/Hb4c/tRzEYIqprPhSxzlf4Uvhb/0Xoig8qnHAJ3lqPMzfDH8XZ4LEpRf2sVdA5/sqPO9Qfop70UJyn+/boaPddT5yrq7VUUvTIVJI7q74MMddXR8NB1eXcYvhBpZm0s2w72/o86HFoKvLau/pYaXzjLMdUJ6y0LwtWV9CIIaXtvA8+G9HHV03u5q+K+yH47U0NoRngPv7KjzHDwTLj0bS1BDazfJJlcnOOostC6ysnCT+q80G/sIvFVgeW09D8FPVT0uoP7VfvAD8NjA8pqmuAN+OcYAjso0RbIZ8DGB5TVNcRO8JMaHY9SXSdfa3eeANJimWBLrA7JFiZwIXye+NMUV8CcxP2SRFjXefok7NRjSGZJlWUPvw2/wtNiQirSoXWyMsR28wR7AzzYM0oXw+Y7yK+CLJGeaoqjyrJSdZJD6Ov4+z5y6NJc0Az7NUecHydIUy+v60KNyQHoM3nKI1y7YCFiq0i7uBvgER52vDdKqWn9djhY1Dn4G3n6Ecqm2rF74dvgoR53S0hQxW9RJAZAGW5bSn58QJA27dQ7uIEedjywEX5NKVxCqsY6y+qA+LxFI4+yZ6oH0trWkNan80jygtIUsc5SflgAsDXgehfdx1KkkTRE76tN+Xue2jnTU0Ru1oIbvpt30bBtKhOp5yaaRkts0lic8V1i6dPcIRx2d/l8Y8XtNNEg7OOo8bl1kmmOKnDsO88CaYzejau0hWZqiL7C83oCH4SeTHvwV2BqqsHRVztSEYOmWF80NeXZT6Hd4KflResE9vCnBOlCyGfDNAstHTVPUDWoQ1t3iW+9WNizvlhfd4aerXd+ThqiMfNR6+9LvOOro5OY5JX2H4+F7HZD+kGzlamMgldWiirQsjcwWFbjmqZJteekJLK9pisvgL6RhKvuciZiwzrWWGapfrPy30kBVcSBIrw0aD3PU0XB6cehntq7rTMf7/2iQlktDVdXJLXlg6VjmiYBn6rWSTRCH6hvJ0hQrpcGq8oidsmHpTP8t8DGO9/vcWt9qabiqPgup1yKyQwvC2tSefZ73SSpNkUJ4PlLorlHZ+446nc8f3fIyywlJhwrTuwVSjBa1ccvSxN0hjjoK5xVrYZMd9V6XbFfgBukixTwGLg8sDam3dZR/wZ6L/dJlin1en8LS+bgpFbz3Ygvzu1J1HKxYNqxGpCmaCEo12rrBorD6LRp8UbpcdR5VWhTW35KlKd6QFqjuM2XzwlpnMxTvSkuUwuG/Xlg6NtPjbT6WFimF/VG6LEvXgn8QGDjMbBukVECFwhpoS+CQatfX2Q1q6H7wENHdrfCr0lKleEB9JyxNneus+VJpsVL9TwI6W65LovWIGl3KtVJaLv7LBwYTFEERFEVQFEERFEVQFEERFEVQFEERFEVQFEERFEVQFEERFFWq/hFgADUMN4RzT6/OAAAAAElFTkSuQmCC">\n            <p class="toast_content">已留言</p>\n        </div>\n    </div>\n</div>\n';
});define("biz_wap/utils/hashrouter.js",[],function(){
"use strict";
function e(e,s){
h.push([e,s]);
}
function s(){
var e,s,t,i,r=a.hash.substr(1),o=!1,u=[];
for(e=0;e<h.length;e++)if(s=h[e],t=s[0],i=s[1],"default"!==t){
if("string"==typeof t&&t==r||t instanceof RegExp&&t.test(r)){
i(n),o=!0;
break;
}
}else u.push(i);
o||u.forEach(function(e){
e(n);
}),n=r;
}
var t=top.window,a=t.location,n=a.hash.substr(1),h=t.__HashMap=t.__HashMap||[];
return t.__hasListenedHashChange||(t.addEventListener("hashchange",s),t.addEventListener("load",s),
t.__hasListenedHashChange=!0),{
get:e
};
});define("a/gotoappdetail.js",["biz_common/dom/event.js","biz_common/utils/report.js","biz_wap/utils/ajax.js","biz_wap/utils/position.js","biz_common/dom/class.js","appmsg/a_report.js","biz_wap/jsapi/core.js","biz_common/utils/url/parse.js"],function(t){
"use strict";
function e(t){
"undefined"!=typeof c&&c.log&&c.log(t);
}
function a(t,e){
o("http://mp.weixin.qq.com/mp/ad_report?action=follow&type="+t+e.report_param);
}
function n(n){
var o=n.btn,p=n.js_app_rating,f=n.url_scheme;
if(!o)return!1;
var g={},j=n.adData,v="",w="",h=j.md5sum,b="",k=n.pos_type||0;
if(function(){
var t=1*j.app_rating;
t>5&&(t=5),0>t&&(t=0);
var e=["","one","two","three","four","five"],a="",n=Math.floor(t);
if(a="star_"+e[n],t>n&&(t=n+.5,a+="_half"),p&&t>0){
var i=p.getElementsByClassName("js_stars"),o=p.getElementsByClassName("js_scores");
i&&o&&i[0]&&o[0]&&(i=i[0],o=o[0],i.style.display="inline-block",r.addClass(i,a));
}
}(),"104"==j.pt){
var y=j.androiddownurl;
if(w=v=j.channel_id||"",y&&y.match){
var z=/&channelid\=([^&]*)/,x=y.match(z);
x&&x[1]&&(v=x[1],j.androiddownurl=y.replace(z,""));
}
v&&(v="&channelid="+v),n.via&&(b=["&via=ANDROIDWX.YYB.WX.ADVERTISE",n.via].join("."));
}
c.ready(function(){
"104"==j.pt&&(c.invoke("getInstallState",{
packageName:m
},function(t){
var a=t.err_msg;
e("getInstallState @yingyongbao : "+a);
var n=a.lastIndexOf("_")+1,i=a.substring(n);
1*i>=u&&a.indexOf("get_install_state:yes")>-1&&(_=!0);
}),c.invoke("getInstallState",{
packageName:j.pkgname
},function(t){
var a=t.err_msg;
e("getInstallState @"+j.pkgname+" : "+a);
var n=a.lastIndexOf("_")+1,i=a.substring(n);
1*i>=j.versioncode&&a.indexOf("get_install_state:yes")>-1&&(l=!0,f?o.innerHTML="进入":(o.innerHTML="已安装",
r.removeClass(o,"btn_download"),r.addClass(o,"btn_installed")));
})),i.on(o,"click",function(i){
if(e("click @js_app_action"),l&&"104"==j.pt&&!f)return!1;
var o=function(){
if("104"==j.pt){
if(_&&!f)return a(24,n),void(location.href="tmast://download?oplist=1;2&pname="+j.pkgname+v+b);
a(25,n);
var e=j.url,i=t("biz_common/utils/url/parse.js");
return e=!e||0!=e.indexOf("http://mp.weixin.qq.com/tp/")&&0!=e.indexOf("https://mp.weixin.qq.com/tp/")?"http://mp.weixin.qq.com/mp/ad_app_info?t=ad/app_detail&app_id="+j.app_id+(n.appdetail_params||"")+"&channel_id="+w+"&md5sum="+h+"&auto=1#wechat_redirect":i.join(e,{
auto:"1"
}),f&&(e=i.join(e,{
is_installed:"1"
})),void(location.href=e);
}
if("103"==j.pt){
a(23,n);
var o="http://"+location.host+"/mp/ad_redirect?url="+encodeURIComponent(j.appinfo_url)+"&uin="+uin+"&ticket="+(n.ticket||window.ticket);
c.invoke("downloadAppInternal",{
appUrl:j.appinfo_url
},function(t){
t.err_msg&&-1!=t.err_msg.indexOf("ok")||(location.href=o);
});
}
};
if(j.rl&&j.traceid){
if(!g[j.traceid]){
g[j.traceid]=!0;
var r,p,m,u,y=!!i&&i.target;
y&&(r=s.getX(y,"js_ad_link")+i.offsetX,p=s.getY(y,"js_ad_link")+i.offsetY,m=document.getElementsByClassName("js_ad_link")[0]&&document.getElementsByClassName("js_ad_link")[0].clientWidth,
u=document.getElementsByClassName("js_ad_link")[0]&&document.getElementsByClassName("js_ad_link")[0].clientHeight),
d({
type:j.type,
report_type:2,
click_pos:0,
url:encodeURIComponent(j.androiddownurl),
tid:j.traceid,
rl:encodeURIComponent(j.rl),
__biz:biz,
pos_type:k,
pt:j.pt,
pos_x:r,
pos_y:p,
ad_w:m||0,
ad_h:u||0
},function(){
g[j.traceid]=!1,o();
});
}
}else o();
return!1;
});
});
}
var i=t("biz_common/dom/event.js"),o=t("biz_common/utils/report.js"),s=(t("biz_wap/utils/ajax.js"),
t("biz_wap/utils/position.js")),r=t("biz_common/dom/class.js"),l=!1,p=t("appmsg/a_report.js"),d=p.AdClickReport,c=t("biz_wap/jsapi/core.js"),_=("https:"==top.location.protocol?5:0,
window.__report,!1),m="com.tencent.android.qqdownloader",u=1060125;
return n;
});define("a/ios.js",["biz_common/dom/event.js","biz_common/utils/report.js","biz_wap/utils/ajax.js","biz_wap/jsapi/core.js"],function(t){
"use strict";
function i(t){
"undefined"!=typeof WeixinJSBridge&&WeixinJSBridge.log&&WeixinJSBridge.log(t);
}
function o(t,i){
n("http://mp.weixin.qq.com/mp/ad_report?action=follow&type="+t+i.report_param);
}
function e(t){
var e=t.btn;
if(!e)return!1;
var n=t.adData,p=!1,c={};
t.report_param=t.report_param||"";
var d="http://"+location.host+"/mp/ad_redirect?url="+encodeURIComponent(n.appinfo_url)+"&uin"+uin+"&ticket="+(t.ticket||window.ticket);
r.on(e,"click",function(){
if(i("click @js_app_action"),p)return i("is_app_installed"),o(n.is_appmsg?17:13,t),
void(location.href=n.app_id+"://");
var e=function(){
i("download"),o(n.is_appmsg?15:11,t),i("go : "+d),location.href=d;
};
return i("download"),n.rl&&n.traceid?c[n.traceid]||(c[n.traceid]=!0,a({
url:"/mp/advertisement_report?report_type=2&type="+n.type+"&url="+encodeURIComponent(n.appinfo_url)+"&tid="+n.traceid+"&rl="+encodeURIComponent(n.rl)+"&pt="+n.pt+t.report_param,
type:"GET",
timeout:1e3,
complete:function(){
i("ready to download"),c[n.traceid]=!1,e();
},
async:!0
})):e(),!1;
});
}
{
var r=t("biz_common/dom/event.js"),n=t("biz_common/utils/report.js"),a=t("biz_wap/utils/ajax.js");
t("biz_wap/jsapi/core.js");
}
return e;
});define("a/android.js",["biz_common/dom/event.js","biz_common/utils/report.js","biz_wap/utils/ajax.js","biz_wap/jsapi/core.js"],function(n,a,e,t){
"use strict";
function o(n){
"undefined"!=typeof s&&s.log&&s.log(n);
}
function i(n,a){
r("http://mp.weixin.qq.com/mp/ad_report?action=follow&type="+n+a.report_param);
}
function d(n){
function a(){
s.invoke("getInstallState",{
packageName:c.pkgname
},function(n){
var a=n.err_msg;
a.indexOf("get_install_state:yes")>-1&&(window.clearInterval(T),k=!0,d.innerHTML=x.installed);
});
}
function e(){
b&&s.invoke("queryDownloadTask",{
download_id:b
},function(a){
if(a&&a.state){
if("download_succ"==a.state){
o("download_succ"),i(c.is_appmsg?18:14,n),window.clearInterval(y),I=!1,j=!0,d.innerHTML=x.downloaded;
var e=document.createEvent("MouseEvents");
e.initMouseEvent("click",!0,!0,window,0,0,0,0,0,!1,!1,!1,!1,0,null),d.dispatchEvent(e);
}
if("downloading"==a.state)return;
("download_fail"==a.state||"default"==a.state)&&(o("fail, download_state : "+a.state),
window.clearInterval(y),I=!1,t("下载失败"),d.innerHTML=x.download);
}
});
}
var d=n.btn;
if(!d)return!1;
var r={},c=n.adData,u="",m="",_=c.androiddownurl;
if(_&&_.match){
var p=/&channelid\=([^&]*)/,f=_.match(p);
f&&f[1]&&(u="&channelid="+f[1],c.androiddownurl=_.replace(p,""));
}
n.via&&(m=["&via=ANDROIDWX.YYB.WX.ADVERTISE",n.via].join("."));
var w=!1,v="com.tencent.android.qqdownloader",g=1060125,k=!1,I=!1,j=!1,b=0,y=null,T=null,x={
download:"下载",
downloading:"下载中",
downloaded:"安装",
installed:"已安装"
};
d.innerHTML=x.download,s.ready(function(){
s.invoke("getInstallState",{
packageName:v
},function(n){
var a=n.err_msg;
o("getInstallState @yingyongbao : "+a);
var e=a.lastIndexOf("_")+1,t=a.substring(e);
1*t>=g&&a.indexOf("get_install_state:yes")>-1&&(w=!0);
}),s.invoke("getInstallState",{
packageName:c.pkgname
},function(n){
var a=n.err_msg;
o("getInstallState @"+c.pkgname+" : "+a);
var e=a.lastIndexOf("_")+1,t=a.substring(e);
1*t>=c.versioncode&&a.indexOf("get_install_state:yes")>-1&&(k=!0,d.innerHTML=x.installed);
}),d.addEventListener("click",function(){
if(o("click @js_app_action"),!I){
if(k)return!1;
if(j)return s.invoke("installDownloadTask",{
download_id:b,
file_md5:c.md5sum
},function(n){
var e=n.err_msg;
o("installDownloadTask : "+e),e.indexOf("install_download_task:ok")>-1?T=setInterval(a,1e3):t("安装失败！");
}),!1;
var _=function(){
return w?(i(c.is_appmsg?16:12,n),void(location.href="tmast://download?oplist=1,2&pname="+c.pkgname+u+m)):void s.invoke("addDownloadTask",{
task_name:c.appname,
task_url:c.androiddownurl,
extInfo:n.task_ext_info,
file_md5:c.md5sum
},function(a){
var r=a.err_msg;
o("addDownloadTask : "+r),r.indexOf("add_download_task:ok")>-1?(i(c.is_appmsg?15:11,n),
I=!0,b=a.download_id,o("download_id : "+b),d.innerHTML=x.downloading,y=setInterval(e,1e3)):t("调用下载器失败！");
});
};
return c.rl&&c.traceid?r[c.traceid]||(r[c.traceid]=!0,l({
url:"/mp/advertisement_report?report_type=2&type="+c.type+"&url="+encodeURIComponent(c.androiddownurl)+"&tid="+c.traceid+"&rl="+encodeURIComponent(c.rl)+"&__biz="+biz+"&pt="+c.pt+"&r="+Math.random(),
type:"GET",
timeout:1e3,
complete:function(){
r[c.traceid]=!1,_();
},
async:!0
})):_(),!1;
}
});
});
}
var r=(n("biz_common/dom/event.js"),n("biz_common/utils/report.js")),l=n("biz_wap/utils/ajax.js"),s=n("biz_wap/jsapi/core.js");
return d;
});