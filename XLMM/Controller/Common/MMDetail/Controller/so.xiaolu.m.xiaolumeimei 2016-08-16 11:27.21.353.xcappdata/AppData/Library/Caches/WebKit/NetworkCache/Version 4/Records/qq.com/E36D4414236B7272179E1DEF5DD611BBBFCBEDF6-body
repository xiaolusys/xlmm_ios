define("a/profile.js",["biz_common/dom/event.js","biz_common/utils/report.js","appmsg/a_report.js","biz_wap/utils/ajax.js","biz_wap/utils/position.js","biz_wap/jsapi/core.js"],function(t){
"use strict";
function e(t,e){
a("http://mp.weixin.qq.com/mp/ad_report?action=follow&type="+t+e.report_param);
}
function n(t){
location.href=t;
}
function o(t){
var o=t.adData,s=t.pos_type||0,l={};
t.report_param=t.report_param||"",function(){
function _(t){
{
var e=m.dataset;
"https:"==top.location.protocol?1500:1200;
}
if(e.rl&&e.url&&e.type&&e.tid){
var n=e.tid,o=e.type,i=e.url,a=e.rl;
if(!l[n]){
l[n]=!0;
var c,_,d,u,j=!!t&&t.target;
j&&(c=r.getX(j,"js_ad_link")+t.offsetX,_=r.getY(j,"js_ad_link")+t.offsetY,d=document.getElementsByClassName("js_ad_link")[0]&&document.getElementsByClassName("js_ad_link")[0].clientWidth,
u=document.getElementsByClassName("js_ad_link")[0]&&document.getElementsByClassName("js_ad_link")[0].clientHeight),
p({
type:o,
report_type:2,
click_pos:0,
url:encodeURIComponent(i),
tid:n,
rl:encodeURIComponent(a),
__biz:biz,
pos_type:s,
pt:100,
pos_x:c,
pos_y:_,
ad_w:d||0,
ad_h:u||0
},function(){
l[n]=!1,f();
});
}
}else f();
}
var m=t.btnAddContact,d=t.btnViewProfile;
if(m&&m.dataset){
var u=function(i,s){
var p=i.err_msg,r=o.is_appmsg?6:1;
-1!=p.indexOf("ok")?(d.style.display="inline-block",m.style.display="none",r=o.is_appmsg?9:4):"add_contact:added"==p?r=o.is_appmsg?7:2:"add_contact:cancel"==p?r=o.is_appmsg?8:3:(--s,
s>=0?c.invoke("addContact",{
scene:scene,
webtype:"1",
username:o.usename
},function(t){
u(t,s);
}):(p="addContact:fail|msg:"+p+"|uin:"+uin+"|biz:"+biz,a("http://mp.weixin.qq.com/mp/jsreport?key=13&content="+p+"&r="+Math.random()),
n(o.url))),e(r,t);
},f=function(){
e(o.is_appmsg?10:5,t),c.invoke("addContact",{
scene:scene,
webtype:"1",
username:o.usename
},function(t){
u(t,1);
});
};
i.on(m,"click",_);
}
}(),function(){
var e=t.btnViewProfile;
e&&i.on(e,"click",function(){
return n(o.url),!1;
});
}();
}
{
var i=t("biz_common/dom/event.js"),a=t("biz_common/utils/report.js"),s=t("appmsg/a_report.js"),p=s.AdClickReport,r=(t("biz_wap/utils/ajax.js"),
t("biz_wap/utils/position.js")),c=t("biz_wap/jsapi/core.js");
"https:"==top.location.protocol?5:0,window.__report;
}
return o;
});define("a/mpshop.js",["biz_common/dom/event.js","biz_common/utils/report.js","appmsg/a_report.js","biz_wap/utils/ajax.js","biz_wap/utils/position.js","biz_wap/jsapi/core.js","biz_common/utils/url/parse.js"],function(t){
"use strict";
function e(t,e){
s("http://mp.weixin.qq.com/mp/ad_report?action=follow&type="+t+e.report_param);
}
function o(t){
var o=t.adData,s=t.pos_type||0,a=o.tid,_=o.type,m=(o.adid,o.outer_id),l=o.url,c=o.rl,d={};
t.report_param=t.report_param||"";
var j=t.btn;
if(j){
i.on(j,"click",function(o){
if(!d[a]){
d[a]=!0;
var i,j,u,b,f=!!o&&o.target;
f&&(i=p.getX(f,"js_ad_link")+o.offsetX,j=p.getY(f,"js_ad_link")+o.offsetY,u=document.getElementsByClassName("js_ad_link")[0]&&document.getElementsByClassName("js_ad_link")[0].clientWidth,
b=document.getElementsByClassName("js_ad_link")[0]&&document.getElementsByClassName("js_ad_link")[0].clientHeight),
n({
type:_,
report_type:2,
click_pos:0,
url:encodeURIComponent(l),
tid:a,
rl:encodeURIComponent(c),
__biz:biz,
pos_type:s,
pt:106,
pos_x:i,
pos_y:j,
ad_w:u||0,
ad_h:b||0
},function(){
d[a]=!1,e(61,t),location.href=r.join(l,{
outer_id:m
});
});
}
return!1;
});
}
}
var i=t("biz_common/dom/event.js"),s=t("biz_common/utils/report.js"),a=t("appmsg/a_report.js"),n=a.AdClickReport,p=(t("biz_wap/utils/ajax.js"),
t("biz_wap/utils/position.js")),r=(t("biz_wap/jsapi/core.js"),t("biz_common/utils/url/parse.js"));
return o;
});define("a/card.js",["biz_common/dom/event.js","biz_common/utils/report.js","appmsg/a_report.js","biz_wap/utils/ajax.js","biz_wap/utils/position.js","biz_wap/jsapi/core.js","biz_wap/jsapi/cardticket.js"],function(e,t,a,i){
"use strict";
function s(e,t){
p("http://mp.weixin.qq.com/mp/ad_report?action=follow&type="+e+t.report_param);
}
function o(e){
var t=e.adData,a=e.pos_type||0,i=t.tid,p=t.type,r=t.url,d=t.rl,l={};
e.report_param=e.report_param||"";
var m=e.btn;
if(m){
n.on(m,"click",function(n){
if(!l[i]){
l[i]=!0;
var m,j,u,f,b=!!n&&n.target;
b&&(m=_.getX(b,"js_ad_link")+n.offsetX,j=_.getY(b,"js_ad_link")+n.offsetY,u=document.getElementsByClassName("js_ad_link")[0]&&document.getElementsByClassName("js_ad_link")[0].clientWidth,
f=document.getElementsByClassName("js_ad_link")[0]&&document.getElementsByClassName("js_ad_link")[0].clientHeight),
c({
type:p,
report_type:2,
click_pos:0,
url:encodeURIComponent(r),
tid:i,
rl:encodeURIComponent(d),
__biz:biz,
pos_type:a,
pt:105,
pos_x:m,
pos_y:j,
ad_w:u||0,
ad_h:f||0
},function(){
l[i]=!1,s(37,e),o.openCardDetail(t.card_id,t.card_ext,e);
});
}
return!1;
});
}
}
var n=e("biz_common/dom/event.js"),p=e("biz_common/utils/report.js"),r=e("appmsg/a_report.js"),c=r.AdClickReport,_=(e("biz_wap/utils/ajax.js"),
e("biz_wap/utils/position.js")),d=(e("biz_wap/jsapi/core.js"),e("biz_wap/jsapi/cardticket.js"));
return o.openCardDetail=function(e,t,a){
d.openCardDetail({
card_id:e,
card_ext:t,
success:function(){
!!a&&s(38,a);
},
error:function(){
!!a&&s(39,a),i("调起卡券错误");
},
access_denied:function(){
!!a&&s(40,a),i("异常错误[access_denied]");
}
});
},o;
});define("biz_wap/utils/position.js",[],function(){
"use strict";
function e(t,f){
var s=t.offsetLeft;
if(t.offsetParent&&t.offsetParent.className){
var a=t.offsetParent.className;
-1==a.indexOf(f)&&(s+=e(t.offsetParent,f));
}
return s;
}
function t(e,f){
var s=e.offsetTop;
if(e.offsetParent&&e.offsetParent.className){
var a=e.offsetParent.className;
-1==a.indexOf(f)&&(s+=t(e.offsetParent,f));
}
return s;
}
return{
getX:e,
getY:t
};
});define("appmsg/a_report.js",["biz_wap/utils/ajax.js","biz_wap/jsapi/core.js","biz_wap/utils/mmversion.js"],function(t){
"use strict";
function o(t,o){
var a="https:"==top.location.protocol?1500:1200,p="/mp/advertisement_report?r="+Math.random()+"&",c=[],u=!1;
for(var j in t)t.hasOwnProperty(j)&&c.push(j+"="+t[j]);
p+=c.join("&"),t.tid&&e.gtVersion("6.3.22",!0)&&s.invoke("adDataReport",{
ad_info:t.tid
},function(){}),i({
url:p,
mayAbort:!0,
type:"GET",
success:function(){
r&&r(56+n);
},
error:function(){
r&&r(57+n);
},
complete:function(){
u||(u=!0,!!o&&o());
},
async:!0
}),setTimeout(function(){
u||(u=!0,window.__ajaxtest="1",!!o&&o());
},a);
}
var i=t("biz_wap/utils/ajax.js"),r=window.__report,a=top.location.protocol,n="https:"==a?5:0,s=t("biz_wap/jsapi/core.js"),e=t("biz_wap/utils/mmversion.js");
return{
AdClickReport:o
};
});define("biz_common/utils/respTypes.js",[],function(require,exports,module){
"use strict";
var logList=[],log=function(r){
logList.push(r);
},printLog=function(){
for(var r=0,e=logList.length;e>r;++r)console.log("[RespType]"+logList[r]);
},isArray=function(r){
return"[object Array]"==Object.prototype.toString.call(r);
},getValueType=function(r){
return isArray(r)?"array":typeof r;
},parseRtDesc=function(r,e){
var t="mix",o=!1,c=e;
if(e){
var n="_R",s=e.indexOf(n),i=e.length-n.length;
o=-1!=s&&s==i,c=o?e.substring(0,i):e;
}
return"string"==typeof r?t=r:isArray(r)?t="array":"object"==typeof r&&(t="object"),
{
key:c,
type:t,
isRequired:o
};
},checkForArrayRtDesc=function(r,e){
if(!isArray(r))return!1;
for(var t=0,o=r.length;o>t;++t){
for(var c,n=r[t],s=0,i=!1;c=e[s++];)if(checkForRtDesc(n,c)){
i=!0;
break;
}
if(!i&&s>0)return!1;
}
return!0;
},checkForStringRtDesc=function(r,e){
var t=getValueType(r),o=parseRtDesc(e),c=o.type==t;
return c||log("miss match type : "+t+" !== "+o.type),c;
},checkForObjectRtDesc=function(r,e){
if("object"!=typeof r||isArray(r))return log("must be object"),!1;
var t=r,o=r;
for(var c in e)if(e.hasOwnProperty(c)){
var n=e[c],s=parseRtDesc(n,c),i=s.key;
o=t[i];
var u=getValueType(o);
if(s.isRequired&&void 0===o)return log("is required @key="+i),!1;
if(void 0!==o){
if(u!=s.type&&"mix"!=s.type)return log("miss match type : "+u+" !== "+s.type+" @key="+i),
!1;
if(("array"==u||"object"==u)&&"mix"!=s.type&&!checkForRtDesc(o,n))return!1;
}
}
return!0;
},checkForRtDesc=function(r,e){
return isArray(e)?checkForArrayRtDesc(r,e):"object"==typeof e?checkForObjectRtDesc(r,e):"string"==typeof e?checkForStringRtDesc(r,e):!1;
},check=function(json,rtDescs){
if("string"==typeof json)try{
json=eval("("+json+")");
}catch(e){
return log("parse json error"),!1;
}
if("object"!=typeof json)return log("must be object"),!1;
isArray(rtDesc)||(rtDescs=[rtDescs]);
for(var rtDesc,i=0;rtDesc=rtDescs[i++];)if(checkForRtDesc(json,rtDesc))return!0;
return!1;
};
return{
check:function(r,e){
logList=[];
try{
var t=check(r,e);
return t||printLog(),t;
}catch(o){
return logList.push("[rtException]"+o.toString()),printLog(),!1;
}
},
getMsg:function(){
return logList.join(";");
}
};
});define("appmsg/cmt_tpl.html.js",[],function(){
return'<li class="discuss_item" id="cid<# if (is_from_me == 1) { #><#=my_id#><# } else { #><#=content_id#><# } #>">\n    <# if(is_elected == 1){ #>\n    <div class="discuss_opr">\n        <span class="media_tool_meta tips_global meta_praise js_comment_praise <# if(like_status == 1){ #>praised<# } #>" data-status="<#=like_status#>" data-content-id=\'<#=content_id#>\'>\n            <i class="icon_praise_gray"></i>\n            <span class="praise_num"><# if(like_num_format !== 0){ #><#=like_num_format#> <# } #></span>\n        </span>\n    </div>\n    <# } #>\n    <div class="user_info">\n        <strong class="nickname"><#=nick_name#><# if(is_from_friend == 1){ #>(朋友)<# } #></strong>\n        <img class="avatar" src="<#=logo_url#>">\n    </div>\n    <div class="discuss_message">\n        <span class="discuss_status"><#=status#></span>\n        <div class="discuss_message_content">\n        <#=content#>\n        </div>\n    </div>\n    <p class="discuss_extra_info">\n        <#=time#>               \n        <# if (is_from_me == 1) { #>\n        <a class="discuss_del js_del" href="javascript:;" data-my-id="<#=my_id#>" data-content-id="<#=content_id#>">删除</a>\n        <# } #>\n    </p>\n    <# if(reply && reply.reply_list && reply.reply_list.length > 0){ #>\n        <div class="reply_result">\n            <div class="nickname">作者回复</div>\n            <div class="discuss_message">\n                <div class="discuss_message_content">\n                <#=reply.reply_list[0].content#>\n                </div>\n            </div>\n            <p class="discuss_extra_info"><#=reply.reply_list[0].time#></p>\n        </div>\n    <# } #>\n        \n</li>';
});define("sougou/a_tpl.html.js",[],function(){
return'<h3 class="rich_media_area_title">相关文章</h3>\n<ul class="relate_article_list">\n    <# for(var i in list){#>\n    <li class="relate_article_item">\n        <a class="relate_article_link sg_link" href="<#=list[i].url#>" target="_blank"><#=list[i].title#></a>\n    </li>\n    <#}#>\n</ul>\n';
});define("appmsg/emotion/emotion.js",["appmsg/emotion/dom.js","appmsg/emotion/slide.js","appmsg/emotion/common.js","appmsg/emotion/nav.js","appmsg/emotion/textarea.js","appmsg/emotion/map.js"],function(t,n){
"use strict";
function i(){
var t={};
j.each(b,function(n,i){
t[n]=i+1;
}),b=t;
}
function e(){
w.WIDTH=h=j("#js_article").width()||j("#js_cmt_mine").width(),w.pageCount=_=o(),
a(),s(),r();
}
function o(){
d=h-2*N,v=parseInt(d/k),f=3*v-1;
var t=parseInt(M/f);
return M%f!==0&&t++,t;
}
function a(){
var t=j("#js_slide_wrapper"),n=w.wrapperWidth=_*h;
t.css({
width:n+"px"
});
}
function s(){
for(var t=j("#js_slide_wrapper").el[0],n=(h-v*k)/2,i=0,e=_;e>i;i++){
var o=document.createElement("ul");
o.setAttribute("class","emotion_list"),t.appendChild(o),j(o).css({
width:h+"px",
"float":"left",
"padding-left":n+"px",
"padding-right":"0"
}),c(o,i);
}
}
function r(){
for(var t=j("#js_navbar"),n=0,i=_;i>n;n++){
var e=j(j.el("li"));
e.attr("class","emotion_nav js_emotion_nav"),T.push(e),t.append(e);
}
w.navs=T;
}
function c(t){
for(var n=0,i=f;i>n;n++){
var e=document.createElement("li");
if(S++,S>M)break;
e=p(S),j(t).append(e);
}
var o=m();
j(t).append(o);
}
function p(t){
var n=j(j.el("li")),i=j(j.el("i")),e=27===t?-1:1;
i.attr("class","icon_emotion icon"+t),i.css({
"background-position":(1-t)*C-e+"px -1px"
}),n.attr("class","emotion_item js_emotion_item"),n.attr("data-index",t);
var o=k+"px";
return n.css({
width:o,
height:o
}),n.append(i),n;
}
function m(){
var t=j(j.el("li")),n=j(j.el("i"));
t.attr("class","emotion_item del js_emotion_item"),t.attr("data-index",-1),n.attr("class","icon_emotion del");
var i=k+"px";
return t.css({
width:i,
height:i
}),t.append(n),t;
}
function l(){
function t(){
o.show(),O.show(),e.blur(),j.later(function(){
e.blur();
});
}
function n(){
o.hide(),O.hide(),e.focus(),j.later(function(){
e.focus();
});
}
O=j("#js_emotion_panel");
var i=j("#js_cmt_input"),e=i.el[0],o=j("#js_emotion_panel_arrow_wrp");
O.hide(),j("#js_emotion_switch").on("tap",function(i){
i.preventDefault(),i.stopPropagation(),E=!E,E?t():n();
}),i.on("tap",function(){
O.hide(),E=!1;
});
}
function u(){
function t(t){
if(!w.isMoved){
var n=j(t.currentTarget),i=+n.attr("data-index");
I.inputEmotion(i);
}
}
j("li.js_emotion_item").on("click",t),j("li.js_emotion_item").on("touchend",t);
}
var d,_,f,v,h,j=t("appmsg/emotion/dom.js"),g=t("appmsg/emotion/slide.js"),w=t("appmsg/emotion/common.js"),x=t("appmsg/emotion/nav.js"),I=t("appmsg/emotion/textarea.js"),n=(j.each,
{}),E=!1,O=null,b=t("appmsg/emotion/map.js"),T=[],N=15,M=w.EMOTIONS_COUNT,k=w.EMOTION_LI_SIZE,C=w.EMOTION_SIZE;
n.init=function(){
l(),e(),g.init(),x.activeNav(0),u(),I.init(),i();
};
var S=0;
return n.encode=function(t){
var n=/\/([\u4e00-\u9fa5\w]{1,3})/g,i=t.match(n);
return i?(j.each(i,function(n){
var i=n.replace("/",""),e=[i.slice(0,1),i.slice(0,2),i.slice(0,3)];
j.each(e,function(n){
if(void 0!==b[n]){
var i=b[n],e='<i class="icon_emotion_single icon'+i+'"></i>';
t=t.replace("/"+n,e);
}
});
}),t):t;
},n.hidePannel=function(){
O.hide();
},n;
});define("biz_common/utils/report.js",[],function(){
"use strict";
return function(n){
var e=new Image;
e.src=n;
};
});define("biz_common/utils/huatuo.js",[],function(){
"use strict";
var t=window.performance&&window.performance.timing,n="http://report.huatuo.qq.com/report.cgi?appid=10065&speedparams=",o=t?["unloadEventStart","unloadEventEnd","redirectStart","redirectEnd","fetchStart","domainLookupStart","domainLookupEnd","connectStart","connectEnd","requestStart","responseStart","responseEnd","domLoading","domInteractive","domContentLoadedEventStart","domContentLoadedEventEnd","domComplete","loadEventStart","loadEventEnd"]:[],e={
points:[],
setFlags:function(n,r,a){
e.points=["flag1="+n,"flag2="+r,"flag3="+a];
for(var d=0;d<o.length;++d)e.points.push(d+1+"="+t[o[d]]);
},
setPoint:function(t,n){
return this.points.push(t+"="+n),this;
},
report:function(){
var t=this.points.join("&");
t=encodeURIComponent(t),(new Image).src=n+t,e.points=[];
}
};
return e;
});define("biz_common/utils/cookie.js",[],function(){
"use strict";
var e={
get:function(e){
if(""==e)return"";
var t=new RegExp(e+"=([^;]*)"),n=document.cookie.match(t);
return n&&n[1]||"";
},
set:function(e,t,n){
var o=new Date;
return o.setDate(o.getDate()+(n||1)),n=o.toGMTString(),document.cookie=e+"="+t+";expires="+n,
!0;
}
};
return e;
});define("appmsg/topic_tpl.html.js",[],function(){
return'<span class="db topic_wrp">\n    <span class="topic_thumb" style="background-image:url({img_url});"></span>\n    <span class="topic_content">\n        <strong class="topic_title">{title}</strong>\n        <span class="topic_desc">{author}</span>\n        <span class="topic_info">\n            <span class="topic_info_extra"><span class="icon_topic"></span>话题</span>\n            <span class="topic_info_primary">相关文章{msg_num}篇</span>\n        </span>\n    </span>\n</span>\n';
});define("pages/voice_tpl.html.js",[],function(){
return'<span id="voice_main_<#=voiceid#>_<#=posIndex#>" class="db audio_area <#if(!musicSupport){#> unsupport<#}#>">\n    <span class="tc tips_global unsupport_tips" <#if(show_not_support!==true){#>style="display:none;"<#}#>>\n    当前浏览器不支持播放音乐或语音，请在微信或其他浏览器中播放    </span>\n    <span class="audio_wrp db">\n        <span id="voice_play_<#=voiceid#>_<#=posIndex#>" class="audio_play_area">\n            <i class="icon_audio_default"></i>\n            <i class="icon_audio_playing"></i>\n            <img src="<#=window.icon_audio_unread#>" alt="" class="pic_audio_default">\n        </span>\n        <span class="audio_length tips_global"><#=duration_str#></span>\n        <span class="db audio_info_area">\n            <strong class="db audio_title"><#=title#></strong>\n            <span class="audio_source tips_global"><#if(window.nickname){#>来自<#=window.nickname#><#}#></span>\n        </span>\n        <span id="voice_progress_<#=voiceid#>_<#=posIndex#>" class="progress_bar" style="width:0px;"></span>\n    </span>\n</span>\n';
});define("pages/voice_component.js",["biz_common/dom/event.js","biz_common/tmpl.js","pages/loadscript.js","pages/music_player.js","biz_common/dom/class.js","pages/report.js"],function(t,o,e,i){
"use strict";
function r(t){
this._o={
type:0,
comment_id:"",
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
webUrl:[location.protocol,"//mp.weixin.qq.com/s?referFrom=#referFrom#&songid=#songId#&__biz=",window.biz,"&mid=",window.mid,"&idx=",window.idx,"&sn=",window.sn,"#wechat_redirect"].join(""),
playingCss:"",
playCssDom:"",
playArea:"",
progress:"",
detailUrl:"",
detailArea:""
},this._init(t);
}
function n(t,o,e,i){
m.num++,o.musicSupport=m.musicSupport,o.show_not_support=!1,m.musicSupport||1!=m.num||(o.show_not_support=!0);
var r=document.createElement("div"),n="";
n=i?_.render(t,o):_.tmpl(t,o),r.innerHTML=n;
var p=e.parentNode;
p&&(p.lastChild===e?p.appendChild(r.children[0]):p.insertBefore(r.children[0],e.nextSibling));
}
function p(){
"undefined"==typeof window.reportVoiceid&&(window.reportVoiceid=[]),"undefined"==typeof window.reportMid&&(window.reportMid=[]);
}
function s(){
u.on(window,"unload",a);
}
function a(){
for(var t in m.reportData)l.musicreport({
data:m.reportData[t]
});
}
function c(t){
var o="//open.music.qq.com/fcgi-bin/fcg_music_get_song_info_weixin.fcg?song_id=#songid#&mid=#mid#&format=json&app_id=100311669&app_key=55d6cdaee6fb3a41275a48067f8d7638&device_id=weixin&file_type=mp3&qqmusic_fromtag=50&callback=get_song_info_back";
o=o.replace("#mid#",t.mid).replace("#songid#",t.id),y({
url:o,
timeout:3e4,
callbackName:"get_song_info_back",
callback:function(o){
if(!o||"undefined"==typeof o.ret)return void("function"==typeof t.onError&&t.onError({
errcode:1
}));
var e=1;
1001==o.ret?e=0:1002==o.ret?e=2:1003==o.ret?e=3:1004==o.ret&&(e=4),t.onSuc({
status:e
});
},
onerror:function(o){
var e=4;
switch(1*o){
case 400:
e=2;
break;

case 500:
e=3;
break;

default:
e=4;
}
"function"==typeof t.onError&&t.onError({
errcode:e
});
}
});
}
function d(t){
return new r(t);
}
var u=t("biz_common/dom/event.js"),_=t("biz_common/tmpl.js"),y=t("pages/loadscript.js"),h=t("pages/music_player.js"),g=t("biz_common/dom/class.js"),l=t("pages/report.js"),m={
musicSupport:h.getSurportType(),
reportData:{},
posIndex:{},
qqMusiceSongId:"http://thirdparty.gtimg.com/#songId#.m4a?fromtag=38&songid=#songId#",
qqMusiceMid:"http://thirdparty.gtimg.com/C100#mid#.m4a?fromtag=38&songid=#songId#",
num:0
};
return p(),s(),r.prototype._init=function(t){
this._extend(t),this._g={
copyright:-1,
check_copyright:!1
},this._initSrc(),this._initQQmusicLyric(),this._initReportData(),this._initPlayer(),
this._playEvent();
},r.prototype._initSrc=function(){
var t=this._o;
t.src||(0==t.type||1==t.type)&&(t.mid?t.src=m.qqMusiceMid.replace("#mid#",t.mid).replace(/#songId#/g,t.songId||""):t.songId&&(t.src=m.qqMusiceSongId.replace(/#songId#/g,t.songId||"")));
},r.prototype._initQQmusicLyric=function(){
var t=this._o;
t.webUrl=0==t.type||1==t.type?t.webUrl.replace("#songId#",t.songId||"").replace("#referFrom#","music.qq.com"):t.webUrl.replace("#songId#","").replace("#referFrom#","");
},r.prototype._initReportData=function(){
var t=this._o;
2==t.type||3==t.type?window.reportVoiceid.push(t.songId):(0==t.type||1==t.type)&&window.reportMid.push(t.songId),
"undefined"==typeof m.reportData[t.type]&&(m.reportData[t.type]=l.getMusicReportData(t),
m.posIndex[t.type]=0),this._g.posIndex=m.posIndex[t.type]++;
var o=m.reportData[t.type];
o.musicid.push(t.songId),o.commentid.push(t.comment_id),o.hasended.push(0),o.mtitle.push(t.title),
o.detail_click.push(0),o.duration.push(parseInt(1e3*t.duration)),o.errorcode.push(0),
o.play_duration.push(0);
},r.prototype._initPlayer=function(){
m.musicSupport&&(this._o.onStatusChange=this._statusChangeCallBack(),this._o.onTimeupdate=this._timeupdateCallBack(),
this._o.onError=this._errorCallBack(),this.player=new h.init(this._o));
},r.prototype._playEvent=function(){
var t=this,o=this._o,e=this._g;
if(m.musicSupport){
var i=0;
2==o.type||3==o.type?i=3:(0==o.type||1==o.type)&&(i=1),u.tap(o.playArea,function(){
return g.hasClass(o.playCssDom,o.playingCss)?(t.player.stop(),l.report({
type:i,
comment_id:o.comment_id,
voiceid:o.songId,
action:5
})):3==i?t._playMusic(3):1==i&&t._checkCopyright(function(){
t._playMusic(1);
}),!1;
});
}
o.detailUrl&&o.detailArea&&u.tap(o.detailArea,function(){
t._checkCopyright(function(){
m.reportData[o.type].detail_click[e.posIndex]=1,window.location.href=o.detailUrl;
});
});
},r.prototype._checkCopyright=function(t){
var o=this,e=this._o,i=this._g;
return 1*i.copyright===1&&"function"==typeof t?void t():void(this._musicCopyrightWarnning()!==!0&&(i.check_copyright||(i.check_copyright=!0,
c({
id:e.songId,
mid:e.mid,
onSuc:function(e){
return i.check_copyright=!1,i.copyright=1*e.status,1==i.copyright?void("function"==typeof t&&t()):void(o._musicCopyrightWarnning(!0)===!0);
},
onError:function(t){
i.check_copyright=!1,o.player.monitor(1==t.errcode?"copyright_cgi_err":2==t.errcode?"copyright_net_err":3==t.errcode?"copyright_timeout":"copyright_other_err");
}
}))));
},r.prototype._musicCopyrightWarnning=function(t){
var o=this._g;
return 1*o.copyright===0?(i("该歌曲版权已过期，无法播放"),t===!0&&this.player.monitor("no_copyright"),
!0):1*o.copyright===2?(i("抱歉，应版权方要求，当前国家或地区暂不提供此歌曲服务"),t===!0&&this.player.monitor("overseas"),
!0):1*o.copyright===3?(i("该歌曲版权已过期，无法播放"),t===!0&&this.player.monitor("fee"),!0):1*o.copyright===4?(i("抱歉，歌曲信息不正确"),
t===!0&&this.player.monitor("musicid_error"),!0):!1;
},r.prototype._playMusic=function(t){
var o=this._o,e=this._g;
this.player.play(0),m.reportData[o.type].hasended[e.posIndex]=1,l.report({
type:t,
comment_id:o.comment_id,
voiceid:o.songId,
action:4
});
},r.prototype._extend=function(t){
for(var o in t)this._o[o]=t[o];
},r.prototype._statusChangeCallBack=function(){
var t=this;
return function(o,e){
t._updatePlayerCss(this,e);
};
},r.prototype._timeupdateCallBack=function(){
var t=this,o=this._o,e=this._g;
return function(i,r){
t._updateProgress(this,r),0!=r&&(m.reportData[o.type].play_duration[e.posIndex]=parseInt(1e3*r));
};
},r.prototype._errorCallBack=function(){
var t=this,o=this._o,e=this._g;
return function(i,r){
m.reportData[o.type].errorcode[e.posIndex]=r,t._updatePlayerCss(this,3);
};
},r.prototype._updatePlayerCss=function(t,o){
var e=this._o,i=e.playCssDom,r=e.progress;
2==o||3==o?(g.removeClass(i,e.playingCss),!!r&&(r.style.width=0)):1==o&&g.addClass(i,e.playingCss);
},r.prototype._updateProgress=function(t,o){
var e=this._o,i=e.progress,r=t.getDuration();
r&&i&&(i.style.width=this._countProgress(r,o));
},r.prototype._countProgress=function(t,o){
return o/t*100+"%";
},{
init:d,
renderPlayer:n
};
});define("pages/qqmusic_tpl.html.js",[],function(){
return'<span id="qqmusic_main_<#=comment_id#>_<#=posIndex#>" class="db qqmusic_area <#if(!musicSupport){#> unsupport<#}#>">\n    <span class="tc tips_global unsupport_tips" <#if(show_not_support!==true){#>style="display:none;"<#}#>>\n    当前浏览器不支持播放音乐或语音，请在微信或其他浏览器中播放    </span>\n    <span class="db qqmusic_wrp">\n        <span class="db qqmusic_bd">\n            <span id="qqmusic_play_<#=musicid#>_<#=posIndex#>" class="play_area">\n                <i class="icon_qqmusic_switch"></i>\n                <img src="<#=window.icon_qqmusic_default#>" alt="" class="pic_qqmusic_default">\n                <img src="<#=music_img#>" data-autourl="<#=audiourl#>" data-musicid="<#=musicid#>" class="qqmusic_thumb" alt="">\n            </span>\n            <!--\n            <%@if($show_comment.DATA$=1)%>\n            <span id="qqmusic_love_icon_<#=musicid#>_<#=posIndex#>" class="qqmusic_love">\n                <i class="icon_love"></i>\n                <span id="love_text_<#=comment_id#>_<#=posIndex#>" class="love_num">赞</span>\n            </span>\n            <%@endif%>\n            -->\n            <a id="qqmusic_home_<#=musicid#>_<#=posIndex#>" href="javascript:void(0);" class="access_area">\n                <span class="qqmusic_songname"><#=music_name#></span>\n                <span class="qqmusic_singername"><#=singer#></span>\n                <span class="qqmusic_source"><img src="<#=window.icon_qqmusic_source#>" alt=""></span>\n            </a>\n        </span>\n    </span>       \n</span>\n';
});