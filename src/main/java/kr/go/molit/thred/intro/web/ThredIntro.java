package kr.go.molit.thred.intro.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ThredIntro {
	
	private final static Logger logger = LoggerFactory.getLogger(ThredIntro.class);

	@RequestMapping(value="/thredIntro.do")
	public String ThredIntro(ModelMap map) {
		logger.info("url Thred Intro was called");
		return "thred/comm/intro/ThredIntro";
	}
	
	@RequestMapping(value="/thredIndex.do")
	public String ThredIndex(ModelMap model) {
		logger.info("url Thred Intro was called");
		return "forward:/thredIntro.do";
	}
}
