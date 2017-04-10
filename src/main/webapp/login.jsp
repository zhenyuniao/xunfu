<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<base href="<%=request.getContextPath()+"/" %>">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="renderer" content="webkit">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<title>系统登录</title>
<script src="B-JUI/js/jquery-1.11.3.min.js"></script>
<script src="B-JUI/js/jquery.cookie.js"></script>
<link href="B-JUI/themes/css/bootstrap.min.css" rel="stylesheet">

<style type="text/css">
html, body { height: 100%; overflow: hidden; }
body {
    font-family: "Verdana", "Tahoma", "Lucida Grande", "Microsoft YaHei", "Hiragino Sans GB", sans-serif;
    background: url(images/loginbg_01.jpg) no-repeat center center fixed;
    background-size: cover;
}
.form-control{height:37px;}
.main_box{position:absolute; top:45%; left:50%; margin:-200px 0 0 -180px; padding:15px 20px; width:360px; height:400px; min-width:320px; background:#FAFAFA; background:rgba(255,255,255,0.5); box-shadow: 1px 5px 8px #888888; border-radius:6px;}
.login_msg{height:30px;}
.input-group >.input-group-addon.code{padding:0;}
#captcha_img{cursor:pointer;}
.main_box .logo img{height:35px;}
@media (min-width: 768px) {
    .main_box {margin-left:-240px; padding:15px 55px; width:480px;}
    .main_box .logo img{height:80px;}
}
</style>
<script type="text/javascript">
var COOKIE_NAME = 'sys_em_username';
$(function() {
    choose_bg();
    changeCode();
   
    if ($.cookie(COOKIE_NAME)){
        $("#j_username").val($.cookie(COOKIE_NAME));
        $("#j_password").focus();
        $("#j_remember").attr("checked",true);
    } else {
        $("#j_username").focus();
    }
    $("#captcha_img").click(function(){
        changeCode();
    });
    $("#login_ok").click(function() {
			var issubmit = true;
			var i_index = 0;
			$(this).find('.form-control').each(function(i) {
				if ($.trim($(this).val()).length == 0) {
					$(this).css('border', '1px #ff0000 solid');
					issubmit = false;
					if (i_index == 0)
						i_index = i;
				}
			});
			if (!issubmit) {
				$(this).find('.form-control').eq(i_index).focus();
				return false;
			}
			var $remember = $("#j_remember");
			if ($remember.attr('checked')) {
				$.cookie(COOKIE_NAME, $("#j_username").val(), {
					path : '/',
					expires : 15
				});
			} else {
				$.cookie(COOKIE_NAME, null, {
					path : '/'
				}); //删除cookie
			}
			
			$("#login_ok").attr("disabled", "disabled");
			$("#login_ok").text(" 登录中... ");
			$.ajax({	 
				cache : false,
				type : "POST",
				url : "loginAction/login.do",
				data : $('#login_form').serialize(),
				dataType : "json",
				error : function(request) {
					alert("Connection error");
					return false;
				},
				success : function(data) {
					if (data.statusCode == 200){
						console.info(data);
					    window.location.href = 'index.jsp';
					}else{
						alert( data.message);
						$("#login_ok").text(" 登 录 ");
						$("#login_ok").removeAttr("disabled");
					}
					return false;	
				}
			});
		});
});
function changeCode(){
    //$("#captcha_img").attr("src", "sys/login/getCaptcha?t="+ (new Date().getTime()));
}
function choose_bg() {
    var bg = Math.floor(Math.random() * 0 + 1);
    $('body').css('background-image', 'url(images/loginbg_0'+ bg +'.png)');
}
</script>
</head>
<body>
<!--[if lte IE 7]>
<style type="text/css">
#errorie {position: fixed; top: 0; z-index: 100000; height: 30px; background: #FCF8E3;}
#errorie div {width: 900px; margin: 0 auto; line-height: 30px; color: orange; font-size: 14px; text-align: center;}
#errorie div a {color: #459f79;font-size: 14px;}
#errorie div a:hover {text-decoration: underline;}
</style>
<div id="errorie"><div>您还在使用老掉牙的IE，请升级您的浏览器到 IE8以上版本  <a target="_blank" href="http://windows.microsoft.com/zh-cn/internet-explorer/ie-8-worldwide-languages">点击升级</a>&nbsp;&nbsp;强烈建议您更改换浏览器<a href="http://down.tech.sina.com.cn/content/40975.html" target="_blank">谷歌­ Chrome</a></div></div>
<![endif]-->
<div class="container">
    <div class="main_box">
    	<div class="setting">
			<a href="javascript:;" onclick="choose_bg();" title=""></a>
		</div>
        <form  id="login_form" >
            <input type="hidden" value="" id="j_randomKey" />
            <input type="hidden" name="jfinal_token" value="" />
            <p class="text-center logo"><img src="images/logo.png" width="112" height="45"></p>
            <div class="login_msg text-center"><font color="red"></font></div>
            <div class="form-group">
                <div class="input-group">
                    <span class="input-group-addon" id="sizing-addon-user"><span class="glyphicon glyphicon-user"></span></span>
                    <input type="text" class="form-control" id="j_username" name="username" value="" placeholder="登录账号" aria-describedby="sizing-addon-user">
                </div>
            </div>
            <div class="form-group">
                <div class="input-group">
                    <span class="input-group-addon" id="sizing-addon-password"><span class="glyphicon glyphicon-lock"></span></span>
                    <input type="password" class="form-control" id="j_password" name="password" value="" placeholder="登录密码" aria-describedby="sizing-addon-password">
                </div>
            </div>
            <!-- <div class="form-group">
                <div class="input-group">
                    <span class="input-group-addon" id="sizing-addon-password"><span class="glyphicon glyphicon-exclamation-sign"></span></span>
                    <input type="text" class="form-control" id="j_captcha" name="captcha" placeholder="验证码" aria-describedby="sizing-addon-password">
                    <span class="input-group-addon code" id="basic-addon-code"><img id="captcha_img" src="images/captcha.jpg" alt="点击更换" title="点击更换" class="m"></span>
                </div>
            </div> -->
            <div class="form-group">
                <div class="checkbox">
                    <label for="j_remember" class="m"><input id="j_remember" type="checkbox" value="true">&nbsp;记住登陆账号</label>
                </div>
            </div>
            <div class="text-center">
                <button type="button" id="login_ok" class="btn btn-primary btn-lg">&nbsp;登&nbsp;录&nbsp;</button>&nbsp;&nbsp;&nbsp;&nbsp;
                <button type="reset" class="btn btn-default btn-lg">&nbsp;重&nbsp;置&nbsp;</button>
            </div>
            <div class="text-center">
                <hr>
                2016 - 2017 <a href="javascript:;" onclick="choose_bg()">收单云系统</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>