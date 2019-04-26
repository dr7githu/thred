package nifty.demo.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.service.EgovProperties;

@Controller
public class GetStart {

/**
getstarted-collapsed-navigation.html   getStartedCollapsedNavigation
getstarted-error-page.html             getStartedErrorPage
getstarted-expanded-navigation.html    getStartedExpandedNavigation
getstarted-login-page-bg.html          getStartedLoginPageBg
getstarted-login-page.html             getStartedLoginPage
getstarted-offcanvas-navigation.html   getStartedOffcanvasNavigation
getstarted-revealing-navigation.html   getStartedRevealingNavigation
getstarted-slide-in-navigation.html    getStartedSlideInNavigation
index.html                             niftyIndex
*/
	
	@RequestMapping(value="/nifty/getStarted/getStartedCollapsedNavigation.do")
	public String getstartedCollapsedNavigation(ModelMap model) {
		
		String ostype = EgovProperties.getProperty("Globals.OsType");
		model.addAttribute("osType", ostype);
		return "nifty/getStarted/GetStartedCollapsedNavigation";
	}
	
	@RequestMapping(value="/nifty/getStarted/getStartedErrorPage.do")
	public String getStartedErrorPage() {
		return "nifty/getStarted/getStartedErrorPage";
	}
	
	@RequestMapping(value="/nifty/getStarted/getStartedExpandedNavigation.do")
	public String getStartedExpandedNavigation(HttpServletRequest req, ModelMap model) {
		return "nifty/getStarted/getStartedExpandedNavigation";
	}
	
	@RequestMapping(value="/nifty/getStarted/getStartedLoginPageBg.do")
	public String getStartedLoginPageBg() {
		return "nifty/getStarted/getStartedLoginPageBg";
	}
	
	@RequestMapping(value="/nifty/getStarted/getStartedLoginPage.do")
	public String getStartedLoginPage() {
		return "nifty/getStarted/getStartedLoginPage";
	}
	
	@RequestMapping(value="/nifty/getStarted/getStartedOffcanvasNavigation.do")
	public String getStartedOffcanvasNavigation() {
		return "nifty/getStarted/getStartedOffcanvasNavigation";
	}
	
	@RequestMapping(value="/nifty/getStarted/getStartedRevealingNavigation.do")
	public String getStartedRevealingNavigation() {
		return "nifty/getStarted/getStartedRevealingNavigation";
	}
	
	@RequestMapping(value="/nifty/getStarted/getStartedSlideInNavigation.do")
	public String getStartedSlideInNavigation() {
		return "nifty/getStarted/getStartedSlideInNavigation";
	}
	
	@RequestMapping(value="/nifty/getStarted/niftyIndex.do")
	public String niftyIndex() {
		return "nifty/getStarted/niftyIndex";
	}
	
	
}
