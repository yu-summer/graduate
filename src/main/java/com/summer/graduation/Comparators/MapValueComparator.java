package com.summer.graduation.Comparators;

import java.util.Comparator;
import java.util.Map;

/**
 * @ClassName com.summer.graduation.Comparators.MapValueComparator
 * @Description 比较器
 * @Author summer
 * @Date 2019/2/26 15:50
 * @Version 1.0
 **/
public class MapValueComparator implements Comparator<Map.Entry<String, Integer>> {
	@Override
	public int compare(Map.Entry<String, Integer> o1, Map.Entry<String, Integer> o2) {
		return o2.getValue().compareTo(o1.getValue());
	}
}
