package kr.go.molit.thred.pilot.web;

import java.lang.reflect.Method;
import java.util.Map;
import java.util.TreeMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.IncludedCompInfoVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import nifty.demo.web.Widget;

@Controller
public class CmWorldPilotController implements ApplicationContextAware {

	private ApplicationContext applicationContext;
	private Map<Integer, IncludedCompInfoVO> map;
	
	public void afterPropertiesSet() throws Exception {}
	
	private final static Logger logger = LoggerFactory.getLogger(CmWorldPilotController.class);
	
	@Override
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		// get the application context object
		this.applicationContext = applicationContext;
		
		logger.info("Widget setApplicationContext method has called!");
	}
	
	
	
	@RequestMapping(value="/cmworld/pilot/cmLoadPilot.do")
	public String CmLoadPilot(ModelMap model) {
		/* 최초 한 번만 실행하여 map에 저장해 놓는다. */
		if (map == null) {
			map = new TreeMap<Integer, IncludedCompInfoVO>();
			RequestMapping rmAnnotation;
			IncludedInfo annotation;
			IncludedCompInfoVO zooVO;

			/*
			 * EgovLoginController가 AOP Proxy되는 바람에 클래스를 reflection으로 가져올 수 없음
			 */
			try {
				Class<?> loginController = Class.forName("egovframework.com.uat.uia.web.EgovLoginController");
				Method[] methods = loginController.getMethods();
				for (int i = 0; i < methods.length; i++) {
					annotation = methods[i].getAnnotation(IncludedInfo.class);

					if (annotation != null) {
						logger.debug("Found @IncludedInfo Method : {}", methods[i]);
						zooVO = new IncludedCompInfoVO();
						zooVO.setName(annotation.name());
						zooVO.setOrder(annotation.order());
						zooVO.setGid(annotation.gid());

						rmAnnotation = methods[i].getAnnotation(RequestMapping.class);
						if ("".equals(annotation.listUrl()) && rmAnnotation != null) {
							zooVO.setListUrl(rmAnnotation.value()[0]);
						} else {
							zooVO.setListUrl(annotation.listUrl());
						}
						map.put(zooVO.getOrder(), zooVO);
					}
				}
			} catch (ClassNotFoundException e) {
				logger.error("No egovframework.com.uat.uia.web.EgovLoginController!!");
			}
			/* 여기까지 AOP Proxy로 인한 코드 */

			/*@Controller Annotation 처리된 클래스를 모두 찾는다.*/
			Map<String, Object> myZoos = applicationContext.getBeansWithAnnotation(Controller.class);
			logger.debug("How many Controllers : ", myZoos.size());
			for (final Object myZoo : myZoos.values()) {
				Class<? extends Object> zooClass = myZoo.getClass();

				Method[] methods = zooClass.getMethods();
				logger.debug("Controller Detected {}", zooClass);
				for (int i = 0; i < methods.length; i++) {
					annotation = methods[i].getAnnotation(IncludedInfo.class);

					if (annotation != null) {
						//LOG.debug("Found @IncludedInfo Method : " + methods[i] );
						zooVO = new IncludedCompInfoVO();
						zooVO.setName(annotation.name());
						zooVO.setOrder(annotation.order());
						zooVO.setGid(annotation.gid());
						/*
						 * 목록형 조회를 위한 url 매핑은 @IncludedInfo나 @RequestMapping에서 가져온다
						 */
						rmAnnotation = methods[i].getAnnotation(RequestMapping.class);
						if ("".equals(annotation.listUrl())) {
							zooVO.setListUrl(rmAnnotation.value()[0]);
						} else {
							zooVO.setListUrl(annotation.listUrl());
						}

						map.put(zooVO.getOrder(), zooVO);
					}
				}
			}
		}
		
//		NiftyCommonService niftyCommonService = new NiftyCommonService();
//		map = niftyCommonService.demoWidget();

		model.addAttribute("resultList", map.values());
		
		logger.debug("EgovComIndexController index is called ");
		
		model.addAttribute("pageTitle", "CM World Load Pilot");
		return "cmworld/pilot/CmLoadPilot";
	}

	@RequestMapping(value="/cmworld/pilot/cmWorldGridPilot.do")
	public String CmWorldGridPilot(ModelMap model) {
		/* 최초 한 번만 실행하여 map에 저장해 놓는다. */
		if (map == null) {
			map = new TreeMap<Integer, IncludedCompInfoVO>();
			RequestMapping rmAnnotation;
			IncludedInfo annotation;
			IncludedCompInfoVO zooVO;

			/*
			 * EgovLoginController가 AOP Proxy되는 바람에 클래스를 reflection으로 가져올 수 없음
			 */
			try {
				Class<?> loginController = Class.forName("egovframework.com.uat.uia.web.EgovLoginController");
				Method[] methods = loginController.getMethods();
				for (int i = 0; i < methods.length; i++) {
					annotation = methods[i].getAnnotation(IncludedInfo.class);

					if (annotation != null) {
						logger.debug("Found @IncludedInfo Method : {}", methods[i]);
						zooVO = new IncludedCompInfoVO();
						zooVO.setName(annotation.name());
						zooVO.setOrder(annotation.order());
						zooVO.setGid(annotation.gid());

						rmAnnotation = methods[i].getAnnotation(RequestMapping.class);
						if ("".equals(annotation.listUrl()) && rmAnnotation != null) {
							zooVO.setListUrl(rmAnnotation.value()[0]);
						} else {
							zooVO.setListUrl(annotation.listUrl());
						}
						map.put(zooVO.getOrder(), zooVO);
					}
				}
			} catch (ClassNotFoundException e) {
				logger.error("No egovframework.com.uat.uia.web.EgovLoginController!!");
			}
			/* 여기까지 AOP Proxy로 인한 코드 */

			/*@Controller Annotation 처리된 클래스를 모두 찾는다.*/
			Map<String, Object> myZoos = applicationContext.getBeansWithAnnotation(Controller.class);
			logger.debug("How many Controllers : ", myZoos.size());
			for (final Object myZoo : myZoos.values()) {
				Class<? extends Object> zooClass = myZoo.getClass();

				Method[] methods = zooClass.getMethods();
				logger.debug("Controller Detected {}", zooClass);
				for (int i = 0; i < methods.length; i++) {
					annotation = methods[i].getAnnotation(IncludedInfo.class);

					if (annotation != null) {
						//LOG.debug("Found @IncludedInfo Method : " + methods[i] );
						zooVO = new IncludedCompInfoVO();
						zooVO.setName(annotation.name());
						zooVO.setOrder(annotation.order());
						zooVO.setGid(annotation.gid());
						/*
						 * 목록형 조회를 위한 url 매핑은 @IncludedInfo나 @RequestMapping에서 가져온다
						 */
						rmAnnotation = methods[i].getAnnotation(RequestMapping.class);
						if ("".equals(annotation.listUrl())) {
							zooVO.setListUrl(rmAnnotation.value()[0]);
						} else {
							zooVO.setListUrl(annotation.listUrl());
						}

						map.put(zooVO.getOrder(), zooVO);
					}
				}
			}
		}
		
//		NiftyCommonService niftyCommonService = new NiftyCommonService();
//		map = niftyCommonService.demoWidget();

		model.addAttribute("resultList", map.values());
		
		logger.debug("EgovComIndexController index is called ");
		
		model.addAttribute("pageTitle", "CM World Grid Pilot");
		return "cmworld/pilot/CmWorldGridPilot";
	}
	
	@RequestMapping(value="/cmworld/pilot/cmWorldCameraPilot.do")
	public String CmWorldCameraPilot(ModelMap model) {
		/* 최초 한 번만 실행하여 map에 저장해 놓는다. */
		if (map == null) {
			map = new TreeMap<Integer, IncludedCompInfoVO>();
			RequestMapping rmAnnotation;
			IncludedInfo annotation;
			IncludedCompInfoVO zooVO;

			/*
			 * EgovLoginController가 AOP Proxy되는 바람에 클래스를 reflection으로 가져올 수 없음
			 */
			try {
				Class<?> loginController = Class.forName("egovframework.com.uat.uia.web.EgovLoginController");
				Method[] methods = loginController.getMethods();
				for (int i = 0; i < methods.length; i++) {
					annotation = methods[i].getAnnotation(IncludedInfo.class);

					if (annotation != null) {
						logger.debug("Found @IncludedInfo Method : {}", methods[i]);
						zooVO = new IncludedCompInfoVO();
						zooVO.setName(annotation.name());
						zooVO.setOrder(annotation.order());
						zooVO.setGid(annotation.gid());

						rmAnnotation = methods[i].getAnnotation(RequestMapping.class);
						if ("".equals(annotation.listUrl()) && rmAnnotation != null) {
							zooVO.setListUrl(rmAnnotation.value()[0]);
						} else {
							zooVO.setListUrl(annotation.listUrl());
						}
						map.put(zooVO.getOrder(), zooVO);
					}
				}
			} catch (ClassNotFoundException e) {
				logger.error("No egovframework.com.uat.uia.web.EgovLoginController!!");
			}
			/* 여기까지 AOP Proxy로 인한 코드 */

			/*@Controller Annotation 처리된 클래스를 모두 찾는다.*/
			Map<String, Object> myZoos = applicationContext.getBeansWithAnnotation(Controller.class);
			logger.debug("How many Controllers : ", myZoos.size());
			for (final Object myZoo : myZoos.values()) {
				Class<? extends Object> zooClass = myZoo.getClass();

				Method[] methods = zooClass.getMethods();
				logger.debug("Controller Detected {}", zooClass);
				for (int i = 0; i < methods.length; i++) {
					annotation = methods[i].getAnnotation(IncludedInfo.class);

					if (annotation != null) {
						//LOG.debug("Found @IncludedInfo Method : " + methods[i] );
						zooVO = new IncludedCompInfoVO();
						zooVO.setName(annotation.name());
						zooVO.setOrder(annotation.order());
						zooVO.setGid(annotation.gid());
						/*
						 * 목록형 조회를 위한 url 매핑은 @IncludedInfo나 @RequestMapping에서 가져온다
						 */
						rmAnnotation = methods[i].getAnnotation(RequestMapping.class);
						if ("".equals(annotation.listUrl())) {
							zooVO.setListUrl(rmAnnotation.value()[0]);
						} else {
							zooVO.setListUrl(annotation.listUrl());
						}

						map.put(zooVO.getOrder(), zooVO);
					}
				}
			}
		}
		
//		NiftyCommonService niftyCommonService = new NiftyCommonService();
//		map = niftyCommonService.demoWidget();

		model.addAttribute("resultList", map.values());
		
		logger.debug("EgovComIndexController index is called ");
		
		model.addAttribute("pageTitle", "CM World Camera Pilot");
		return "cmworld/pilot/CmWorldCameraPilot";
	}
	
	@RequestMapping(value="/cmworld/pilot/cmWorldDataLoadPilot.do")
	public String CmWorldDataLoadPilot(ModelMap model) {
		/* 최초 한 번만 실행하여 map에 저장해 놓는다. */
		if (map == null) {
			map = new TreeMap<Integer, IncludedCompInfoVO>();
			RequestMapping rmAnnotation;
			IncludedInfo annotation;
			IncludedCompInfoVO zooVO;

			/*
			 * EgovLoginController가 AOP Proxy되는 바람에 클래스를 reflection으로 가져올 수 없음
			 */
			try {
				Class<?> loginController = Class.forName("egovframework.com.uat.uia.web.EgovLoginController");
				Method[] methods = loginController.getMethods();
				for (int i = 0; i < methods.length; i++) {
					annotation = methods[i].getAnnotation(IncludedInfo.class);

					if (annotation != null) {
						logger.debug("Found @IncludedInfo Method : {}", methods[i]);
						zooVO = new IncludedCompInfoVO();
						zooVO.setName(annotation.name());
						zooVO.setOrder(annotation.order());
						zooVO.setGid(annotation.gid());

						rmAnnotation = methods[i].getAnnotation(RequestMapping.class);
						if ("".equals(annotation.listUrl()) && rmAnnotation != null) {
							zooVO.setListUrl(rmAnnotation.value()[0]);
						} else {
							zooVO.setListUrl(annotation.listUrl());
						}
						map.put(zooVO.getOrder(), zooVO);
					}
				}
			} catch (ClassNotFoundException e) {
				logger.error("No egovframework.com.uat.uia.web.EgovLoginController!!");
			}
			/* 여기까지 AOP Proxy로 인한 코드 */

			/*@Controller Annotation 처리된 클래스를 모두 찾는다.*/
			Map<String, Object> myZoos = applicationContext.getBeansWithAnnotation(Controller.class);
			logger.debug("How many Controllers : ", myZoos.size());
			for (final Object myZoo : myZoos.values()) {
				Class<? extends Object> zooClass = myZoo.getClass();

				Method[] methods = zooClass.getMethods();
				logger.debug("Controller Detected {}", zooClass);
				for (int i = 0; i < methods.length; i++) {
					annotation = methods[i].getAnnotation(IncludedInfo.class);

					if (annotation != null) {
						//LOG.debug("Found @IncludedInfo Method : " + methods[i] );
						zooVO = new IncludedCompInfoVO();
						zooVO.setName(annotation.name());
						zooVO.setOrder(annotation.order());
						zooVO.setGid(annotation.gid());
						/*
						 * 목록형 조회를 위한 url 매핑은 @IncludedInfo나 @RequestMapping에서 가져온다
						 */
						rmAnnotation = methods[i].getAnnotation(RequestMapping.class);
						if ("".equals(annotation.listUrl())) {
							zooVO.setListUrl(rmAnnotation.value()[0]);
						} else {
							zooVO.setListUrl(annotation.listUrl());
						}

						map.put(zooVO.getOrder(), zooVO);
					}
				}
			}
		}
		
//		NiftyCommonService niftyCommonService = new NiftyCommonService();
//		map = niftyCommonService.demoWidget();

		model.addAttribute("resultList", map.values());
		
		logger.debug("EgovComIndexController index is called ");
		
		model.addAttribute("pageTitle", "CM World DataLoad Pilot");
		return "cmworld/pilot/CmWorldDataLoadPilot";
	}
	
	@RequestMapping(value="/cmworld/pilot/cmWorldChemicalsHazardPilot.do")
	public String CmWorldChemicalsHazardPilot(ModelMap model) {
		/* 최초 한 번만 실행하여 map에 저장해 놓는다. */
		if (map == null) {
			map = new TreeMap<Integer, IncludedCompInfoVO>();
			RequestMapping rmAnnotation;
			IncludedInfo annotation;
			IncludedCompInfoVO zooVO;

			/*
			 * EgovLoginController가 AOP Proxy되는 바람에 클래스를 reflection으로 가져올 수 없음
			 */
			try {
				Class<?> loginController = Class.forName("egovframework.com.uat.uia.web.EgovLoginController");
				Method[] methods = loginController.getMethods();
				for (int i = 0; i < methods.length; i++) {
					annotation = methods[i].getAnnotation(IncludedInfo.class);

					if (annotation != null) {
						logger.debug("Found @IncludedInfo Method : {}", methods[i]);
						zooVO = new IncludedCompInfoVO();
						zooVO.setName(annotation.name());
						zooVO.setOrder(annotation.order());
						zooVO.setGid(annotation.gid());

						rmAnnotation = methods[i].getAnnotation(RequestMapping.class);
						if ("".equals(annotation.listUrl()) && rmAnnotation != null) {
							zooVO.setListUrl(rmAnnotation.value()[0]);
						} else {
							zooVO.setListUrl(annotation.listUrl());
						}
						map.put(zooVO.getOrder(), zooVO);
					}
				}
			} catch (ClassNotFoundException e) {
				logger.error("No egovframework.com.uat.uia.web.EgovLoginController!!");
			}
			/* 여기까지 AOP Proxy로 인한 코드 */

			/*@Controller Annotation 처리된 클래스를 모두 찾는다.*/
			Map<String, Object> myZoos = applicationContext.getBeansWithAnnotation(Controller.class);
			logger.debug("How many Controllers : ", myZoos.size());
			for (final Object myZoo : myZoos.values()) {
				Class<? extends Object> zooClass = myZoo.getClass();

				Method[] methods = zooClass.getMethods();
				logger.debug("Controller Detected {}", zooClass);
				for (int i = 0; i < methods.length; i++) {
					annotation = methods[i].getAnnotation(IncludedInfo.class);

					if (annotation != null) {
						//LOG.debug("Found @IncludedInfo Method : " + methods[i] );
						zooVO = new IncludedCompInfoVO();
						zooVO.setName(annotation.name());
						zooVO.setOrder(annotation.order());
						zooVO.setGid(annotation.gid());
						/*
						 * 목록형 조회를 위한 url 매핑은 @IncludedInfo나 @RequestMapping에서 가져온다
						 */
						rmAnnotation = methods[i].getAnnotation(RequestMapping.class);
						if ("".equals(annotation.listUrl())) {
							zooVO.setListUrl(rmAnnotation.value()[0]);
						} else {
							zooVO.setListUrl(annotation.listUrl());
						}

						map.put(zooVO.getOrder(), zooVO);
					}
				}
			}
		}
		
//		NiftyCommonService niftyCommonService = new NiftyCommonService();
//		map = niftyCommonService.demoWidget();

		model.addAttribute("resultList", map.values());
		
		logger.debug("EgovComIndexController index is called ");
		
		model.addAttribute("pageTitle", "CM World Chemicals Hazard Pilot");
		return "cmworld/pilot/CmWorldChemicalsHazardPilot";
	}

}
