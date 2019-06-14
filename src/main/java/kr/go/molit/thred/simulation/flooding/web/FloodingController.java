package kr.go.molit.thred.simulation.flooding.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class FloodingController {

	@RequestMapping(value="/simulation/flooding/gangnam.do")
	public String GangNamFlooding(ModelMap model) {
		
		model.addAttribute("pageTitle", "Flooding Analysis");
		model.addAttribute("pageTitleBodyText", "Place in Bang Bang Intersection");
		
		return "cmworld/simulation/flooding/gangnam/GangNamFlooding";
	}
}
