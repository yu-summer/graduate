package com.summer.test;

import com.summer.graduation.Comparators.MapValueComparator;
import org.json.JSONObject;
import redis.clients.jedis.Jedis;

import java.util.*;

/**
 * @ClassName com.summer.test.OperateRedisDemo
 * @Description TODO
 * @Author summer
 * @Date 2019/2/26 20:06
 * @Version 1.0
 **/
public class OperateRedisDemo {
	public static void main(String[] args) {

		Jedis jedis = new Jedis("127.0.0.1", 6379);
		jedis.auth("manager");

		//存放所有日志
		List<String> logList = jedis.lrange("log", 0, jedis.llen("log"));

		//存放来源IP
		Map<String, Integer> srcIP = new HashMap<>();
		//存放来源port
		Map<String, Integer> srcPort = new HashMap<>();
		//存放目的ip
		Map<String, Integer> descIP = new HashMap<>();
		//存放目的port
		Map<String, Integer> descPort = new HashMap<>();
		//存放目的alert
		Map<String, Integer> alert = new HashMap<>();

		List<JSONObject> allLogs = new ArrayList<>();

		for (String logStr : logList) {
			JSONObject json = new JSONObject(logStr);
			String src_ip = json.get("src_ip").toString();
			String src_port = json.get("src_port").toString();
			String desc_ip = json.get("desc_ip").toString();
			String desc_port = json.get("desc_port").toString();

			//srcip
			if (!srcIP.containsKey(src_ip)) {
				srcIP.put(src_ip, 1);
			} else {
				srcIP.put(src_ip, srcIP.get(src_ip) + 1);
			}

			//srcport
			if (!srcPort.containsKey(src_port)) {
				srcPort.put(src_port, 1);
			} else {
				srcPort.put(src_port, srcPort.get(src_port) + 1);
			}

			//descip
			if (!descIP.containsKey(desc_ip)) {
				descIP.put(desc_ip, 1);
			} else {
				descIP.put(desc_ip, descIP.get(desc_ip) + 1);
			}

			//descport
			if (!descPort.containsKey(desc_port)) {
				descPort.put(desc_port, 1);
			} else {
				descPort.put(desc_port, descPort.get(desc_port) + 1);
			}

			allLogs.add(json);
		}

		Map<String, Integer> srcIP2 = sortMapByValue(srcIP);
		Map<String, Integer> srcPort2 = sortMapByValue(srcPort);
		Map<String, Integer> descIP2 = sortMapByValue(descIP);
		Map<String, Integer> descPort2 = sortMapByValue(descPort);

		Map<String, Object> resultMap = new HashMap<>();

		resultMap.put("fin_allLogs", allLogs.subList(0, 20));
		resultMap.put("fin_srcIP", getTop20(srcIP2));
		resultMap.put("fin_srcPort", getTop20(srcPort2));
		resultMap.put("fin_descIP", getTop20(descIP2));
		resultMap.put("fin_descPort", getTop20(descPort2));

		System.out.println(transformData(getTop20(srcIP2)));
		System.out.println(transformData(getTop20(srcPort2)));
		System.out.println(transformData(getTop20(descIP2)));
		System.out.println(transformData(getTop20(descPort2)));
	}

	/**
	 * 将数据转化为图表需要的数据格式
	 *
	 * @return
	 */
	public static List<String> transformData(Map<String, Integer> map) {
		List<String> test = new ArrayList<>();
		for (Map.Entry<String, Integer> entry : map.entrySet()) {
			test.add("{value: " + entry.getValue() + ", name: " + entry.getKey() + "}");
		}
		return test;
	}

	/**
	 * 使用 Map按value进行排序
	 *
	 * @param oriMap
	 * @return
	 */
	private static Map<String, Integer> sortMapByValue(Map<String, Integer> oriMap) {
		if (oriMap == null || oriMap.isEmpty()) {
			return null;
		}
		Map<String, Integer> sortedMap = new LinkedHashMap<>();
		List<Map.Entry<String, Integer>> entryList = new ArrayList<>(
				oriMap.entrySet());
		Collections.sort(entryList, new MapValueComparator());

		Iterator<Map.Entry<String, Integer>> iter = entryList.iterator();
		Map.Entry<String, Integer> tmpEntry = null;
		while (iter.hasNext()) {
			tmpEntry = iter.next();
			sortedMap.put(tmpEntry.getKey(), tmpEntry.getValue());
		}
		return sortedMap;
	}

	/**
	 * @param map
	 * @return
	 */
	private static Map<String, Integer> getTop20(Map<String, Integer> map) {
		if (map.size() > 20) {
			Map<String, Integer> topMap = new HashMap<>();

			int i = 0;
			for (Map.Entry<String, Integer> entry : map.entrySet()) {
				i++;
				topMap.put("'" + entry.getKey() + "'", entry.getValue());
				if (i >= 20) break;
			}
			return topMap;
		} else {
			return map;
		}
	}
}
