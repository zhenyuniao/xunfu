/**
 * @Title:BaseInterceptor.java
 * @Author:Riozenc
 * @Datetime:2016年1月6日 下午5:27:49
 * @Project:esi
 */
package sds.web.interceptor;

import java.lang.reflect.Method;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.riozenc.quicktool.common.util.date.DateUtil;
import com.riozenc.quicktool.common.util.json.JSONUtil;
import com.riozenc.quicktool.common.util.log.ExceptionLogUtil;
import com.riozenc.quicktool.common.util.log.LogUtil;
import com.riozenc.quicktool.common.util.log.LogUtil.LOG_TYPE;
import com.riozenc.quicktool.exception.LoginTimeOutException;

import sds.common.exception.InvalidAppCodeException;
import sds.common.json.JsonResult;

public class BaseInterceptor extends HandlerInterceptorAdapter {

	// 参数中的Object handler是下一个拦截器。

	// 最后执行，可用于释放资源
	// 在afterCompletion中，可以根据e是否为null判断是否发生了异常，进行日志记录

	@Override
	public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse,
			Object object, Exception exception) throws Exception {
		// TODO Auto-generated method stub

		if (null != exception) {
			// 设置头信息,字符集UTF-8
			httpServletResponse.setHeader("Content-type", "text/html;charset=UTF-8");
			// 登录超时异常
			if (exception instanceof LoginTimeOutException) {
				httpServletResponse.getWriter().println(JSONUtil.toJsonString(new JsonResult(202, "请重新登录...")));
			} else if (exception instanceof InvalidAppCodeException) {
				httpServletResponse.getWriter()
						.println(JSONUtil.toJsonString(new JsonResult(JsonResult.ERROR, exception.getMessage())));
			} else {
				httpServletResponse.getWriter().println(exception.getMessage());
			}

			// httpServletResponse.setHeader("Content-type",
			// "text/html;charset=UTF-8");
			// httpServletResponse.getWriter().println(ExceptionLogUtil.log(exception));
			httpServletResponse.getWriter().close();

			LogUtil.getLogger(LOG_TYPE.ERROR)
					.error("[" + DateUtil.formatDateTime(new Date()) + "]{" + httpServletRequest.getRemoteAddr()
							+ "} 执行" + getClassMethod(object) + "[" + httpServletRequest.getMethod() + "]:"
							+ ExceptionLogUtil.log(exception));
		}

	}

	// Action之后,生成视图之前执行
	// 在postHandle中，有机会修改ModelAndView
	@Override
	public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse,
			Object object, ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub

		if (null != modelAndView) {
			// // 设置头信息,字符集UTF-8
			// httpServletResponse.setHeader("Content-type",
			// "text/html;charset=UTF-8");
			// httpServletResponse.getWriter().println(modelAndView.getModel().get("json"));
			//
			// httpServletResponse.getWriter().close();
			//
			// LogUtil.getLogger(LOG_TYPE.OTHER)
			// .info("[" + httpServletRequest.getRemoteAddr() + "]" +
			// modelAndView.getModel().get("json"));
		}
		System.out.println("postHandler");
	}

	// Action之前执行
	// 在preHandle中，可以进行编码、安全控制等处理
	@Override
	public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse,
			Object object) throws Exception {
		// TODO Auto-generated method stub

		LogUtil.getLogger(LOG_TYPE.OTHER)
				.info("[" + DateUtil.formatDateTime(new Date()) + "]{" + httpServletRequest.getRemoteAddr() + "} 执行"
						+ getClassMethod(object) + "[" + httpServletRequest.getMethod() + "]--("
						+ JSONUtil.toJsonString(httpServletRequest.getParameterMap()) + ")");

		// if (RequestMethod.GET.name().equals(httpServletRequest.getMethod()))
		// {
		// // 只支持GET方法
		// return true;
		// } else {
		// return false;
		// }
		return true;

	}

	private String getClassMethod(Object object) {
		if (object instanceof HandlerMethod) {
			HandlerMethod handlerMethod = (HandlerMethod) object;
			Class<?> clazz = handlerMethod.getBeanType();
			Method method = handlerMethod.getMethod();

			return clazz.getName() + "." + method.getName();
		} else {
			return "执行未知操作:" + object.getClass();
		}

	}
}
