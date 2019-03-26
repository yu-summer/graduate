package com.summer.graduation.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @ClassName com.summer.graduation.controller.ErrorPageController
 * @Description TODO
 * @Author summer
 * @Date 2019/2/21 15:10
 * @Version 1.0
 **/
@Controller
public class ErrorPageController {
	@RequestMapping("404.do")
	public String page_404() {
		return "404";
	}
}
