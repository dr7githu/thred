package kr.go.molit.thred.cmlib.test.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author podo_dev2team
 *
 */
@Controller
public class DemoMay {

	private final static Logger logger = LoggerFactory.getLogger(DemoMay.class);
	
	/**
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/cmWorldDemoBasic.do")
	public String CmWorldDemoBasic(ModelMap model) {
		
		return "thred/pilot/CmWorldDemoBasic";
	}
	
	@RequestMapping(value="/cmDemoCameraMoveThrowPath.do")
	public String CmDemoCameraMoveThrowPath(ModelMap model) {
		
		return "thred/pilot/CmDemoCameraMoveThrowPath";
	}
	
	/**
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/cmDemoGrid.do")
	public String CmDemoGrid(ModelMap model) {
		
		return "thred/pilot/CmDemoGrid";
	}
	
}
