/**
 * @Project:crm
 * @Title:LoginIntercepptor.java
 * @Author:Riozenc
 * @Datetime:2016年10月16日 下午8:16:45
 * 
 */
package sds.web.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

public class LoginInterceptor implements HandlerInterceptor {
	private final static String LOGIN_URL = "/pages/jsp/login.jsp";

	@Override
	public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse,
			Object object, Exception exception) throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse,
			Object object, ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub

	}

	// 在执行handler之前来执行的
	// 用于用户认证校验、用户权限校验
	@Override
	public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse,
			Object object) throws Exception {
		// TODO Auto-generated method stub
		// 得到请求的url
		String url = httpServletRequest.getRequestURI();
		System.out.println(url);
		// 判断是否是公开 地址
		// 实际开发中需要公开 地址配置在配置文件中
		// 从配置中取逆名访问url
		// List<String> open_urls =
		// ResourcesUtil.gekeyList("config/anonymousURL");
		// 遍历公开 地址，如果是公开 地址则放行
		// for (String open_url : open_urls) {
		// if (url.indexOf(open_url) >= 0) {
		// // 如果是公开 地址则放行
		// return true;
		// }
		// }
		// 判断用户身份在session中是否存在
		// HttpSession session = httpServletRequest.getSession();
		// ActiveUser activeUser = (ActiveUser)
		// session.getAttribute("activeUser");
		// 如果用户身份在session中存在放行
		// if (activeUser != null) {
		// return true;
		// }
		// 执行到这里拦截，跳转到登陆页面，用户进行身份认证
		httpServletRequest.getRequestDispatcher(LOGIN_URL).forward(httpServletRequest, httpServletResponse);

		// 如果返回false表示拦截不继续执行handler，如果返回true表示放行
		return false;
	}

}
