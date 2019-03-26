package com.summer.graduation.handler;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

/**
 * @ClassName com.summer.graduation.handler.WebExceptionHandle
 * @Description 全局异常处理类
 * @Author summer
 * @Date 2019/2/21 11:00
 * @Version 1.0
 **/
@ControllerAdvice
@ResponseBody
@Controller
public class WebExceptionHandle {

	/**
	 * 405
	 *
	 * @param e
	 * @return
	 */
	@ResponseStatus(HttpStatus.METHOD_NOT_ALLOWED)
	@ExceptionHandler
	public ModelAndView handleHttpRequestMethodNotSupportedException(HttpRequestMethodNotSupportedException e) {
		return new ModelAndView("login");
	}

}
