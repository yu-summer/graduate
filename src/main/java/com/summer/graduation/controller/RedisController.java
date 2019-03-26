package com.summer.graduation.controller;

import com.summer.graduation.bs.OperateRedis;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.exceptions.JedisConnectionException;
import redis.clients.jedis.exceptions.JedisDataException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @ClassName com.summer.graduation.controller.RedisController
 * @Description TODO
 * @Author summer
 * @Date 2019/2/25 10:57
 * @Version 1.0
 **/
@Controller
public class RedisController {
	private Jedis jedis = null;
	Map<String, Object> dataResult = null;    //显示的数据

	@RequestMapping(value = "doLogin.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> login(String ip, String port, String password) {
		String result_mesg = "success";  //登录结果

		try {
			//登陆的具体逻辑
			String ip2 = ip.replace("\\s*", "");   //去掉空白
			String port2 = port.replace("\\s*", "");
			String password2 = password.replace("\\s*", "");

			jedis = new Jedis(ip2, Integer.parseInt(port2));
			jedis.auth(password2);
		} catch (JedisConnectionException | JedisDataException e) {
			result_mesg = e.getMessage();
		} catch (Exception e) {
			result_mesg = "未知错误";
		}

		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("result", result_mesg);

		return resultMap;
	}

	@RequestMapping("login.do")
	public String toLoginPage() {
		return "login";
	}

	//相应主界面
	@RequestMapping(value = "index.do")
	public ModelAndView toIndex() {
		//TODO 测试代码
		jedis = new Jedis("127.0.0.1", 6379);
		jedis.auth("manager");

		if (jedis == null) {
			ModelAndView modelAndView = new ModelAndView("login");
			return modelAndView;
		}

		dataResult = new OperateRedis().dataResult(jedis);
		ModelAndView modelAndView = new ModelAndView("main");
		modelAndView.addObject("top20Logs", dataResult.get("fin_allLogs"));
		modelAndView.addObject("allCount", dataResult.get("allCount"));
		modelAndView.addObject("alertType", dataResult.get("alertType"));

		Map<String, Integer> log = null;

		//来源ip数据
		log = (Map<String, Integer>) dataResult.get("fin_srcIP");
		modelAndView.addObject("top20scrIP_key", log.keySet());
		modelAndView.addObject("top20scrIP", transformData(log));

		//来源port数据
		log = (Map<String, Integer>) dataResult.get("fin_srcPort");
		modelAndView.addObject("top20scrPort_key", log.keySet());
		modelAndView.addObject("top20scrPort", transformData(log));

		//目的IP数据
		log = (Map<String, Integer>) dataResult.get("fin_descIP");
		modelAndView.addObject("top20descIP_key", log.keySet());
		modelAndView.addObject("top20descIP", transformData(log));

		//目的port数据
		log = (Map<String, Integer>) dataResult.get("fin_descPort");
		modelAndView.addObject("top20descPort_key", log.keySet());
		modelAndView.addObject("top20descPort", transformData(log));

		return modelAndView;
	}

	@RequestMapping("chart.do")
	public ModelAndView toChart() {
		if (jedis == null) {
			ModelAndView modelAndView = new ModelAndView("login");
			return modelAndView;
		}
		ModelAndView modelAndView = new ModelAndView();

		Map<String, Integer> log = null;

		//来源ip数据
		log = (Map<String, Integer>) dataResult.get("fin_srcIP");
		modelAndView.addObject("top20scrIP_key", log.keySet());
		modelAndView.addObject("top20scrIP", transformData(log));

		//来源port数据
		log = (Map<String, Integer>) dataResult.get("fin_srcPort");
		modelAndView.addObject("top20scrPort_key", log.keySet());
		modelAndView.addObject("top20scrPort", transformData(log));

		//目的IP数据
		log = (Map<String, Integer>) dataResult.get("fin_descIP");
		modelAndView.addObject("top20descIP_key", log.keySet());
		modelAndView.addObject("top20descIP", transformData(log));

		//目的port数据
		log = (Map<String, Integer>) dataResult.get("fin_descPort");
		modelAndView.addObject("top20descPort_key", log.keySet());
		modelAndView.addObject("top20descPort", transformData(log));

		return modelAndView;
	}

	/**
	 * 将数据转化为图表需要的数据格式
	 *
	 * @return
	 */
	private static List<String> transformData(Map<String, Integer> map) {
		List<String> result = new ArrayList<>();
		for (Map.Entry<String, Integer> entry : map.entrySet()) {
			result.add("{value: " + entry.getValue() + ", name: " + entry.getKey() + "}");
		}
		return result;
	}

	@RequestMapping("pdf.do")
	public ModelAndView toPDF() {
		if (jedis == null) {
			ModelAndView modelAndView = new ModelAndView("pdf");
			return modelAndView;
		}
		ModelAndView modelAndView = new ModelAndView();

		modelAndView.addObject("top20Logs", dataResult.get("fin_allLogs"));
		modelAndView.addObject("allCount", dataResult.get("allCount"));
		modelAndView.addObject("alertType", dataResult.get("alertType"));

		Map<String, Integer> log = null;

		//来源ip数据
		log = (Map<String, Integer>) dataResult.get("fin_srcIP");
		modelAndView.addObject("top20scrIP_key", log.keySet());
		modelAndView.addObject("top20scrIP", transformData(log));

		//来源port数据
		log = (Map<String, Integer>) dataResult.get("fin_srcPort");
		modelAndView.addObject("top20scrPort_key", log.keySet());
		modelAndView.addObject("top20scrPort", transformData(log));

		//目的IP数据
		log = (Map<String, Integer>) dataResult.get("fin_descIP");
		modelAndView.addObject("top20descIP_key", log.keySet());
		modelAndView.addObject("top20descIP", transformData(log));

		//目的port数据
		log = (Map<String, Integer>) dataResult.get("fin_descPort");
		modelAndView.addObject("top20descPort_key", log.keySet());
		modelAndView.addObject("top20descPort", transformData(log));

		return modelAndView;
	}
}
