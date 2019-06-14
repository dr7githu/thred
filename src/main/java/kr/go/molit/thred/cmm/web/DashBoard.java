package kr.go.molit.thred.cmm.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class DashBoard {

	private static final Logger logger = LoggerFactory.getLogger(DashBoard.class);
	
	@RequestMapping(value = "/cmm/dashBoard.do")
	public String DashBoard(ModelMap model) {
		logger.info("Get started a dash board.");
		return "thred/cmm/dashboard/DashBoard";
	}
}
