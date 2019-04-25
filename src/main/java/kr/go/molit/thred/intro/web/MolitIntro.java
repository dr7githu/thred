package kr.go.molit.thred.intro.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MolitIntro {
	
	private final static Logger logger = LoggerFactory.getLogger(MolitIntro.class);

	@RequestMapping(value="/molitIntro.do")
	public String molitIntro(ModelMap map) {
		
		logger.info("url molitIntro was called");
		return "egovframework/com/cmm/EgovUnitMain";
	}
}
