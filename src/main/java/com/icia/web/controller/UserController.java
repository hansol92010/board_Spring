package com.icia.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.icia.common.util.StringUtil;
import com.icia.web.model.Response;
import com.icia.web.model.User;
import com.icia.web.service.UserService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;
import com.icia.web.util.JsonUtil;

/**
 * <pre>
 * 패키지명   : com.icia.web.controller
 * 파일명     : UserController.java
 * 작성일     : 2021. 1. 20.
 * 작성자     : daekk
 * 설명       : 사용자 컨트롤러
 * </pre>
 */
@Controller("userController")
public class UserController
{
	private static Logger logger = LoggerFactory.getLogger(UserController.class);
	
	// 쿠키명
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Autowired
	private UserService userService;
	
	/* 로그인 */
	@RequestMapping(value="/user/loginProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> loginProc(HttpServletRequest request, HttpServletResponse response) {
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		Response<Object> ajaxResponse = new Response<Object>();
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)) {
			User user = userService.userSelect(userId);
			if(user != null) {
				if(StringUtil.equals(userPwd, user.getUserPwd())) {
					CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));
					ajaxResponse.setResponse(0, "Success");
				} else {
					ajaxResponse.setResponse(-1, "Password does not match");
				}
			} else {
				ajaxResponse.setResponse(404, "Not Found");
			}
		} else {
			ajaxResponse.setResponse(400, "Bad request");
		}
		
		if(logger.isDebugEnabled()) {
			logger.debug("[UserController] /user/loginProc\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	/* 회원 가입 페이지  */
	@RequestMapping(value="/user/regForm", method=RequestMethod.GET)
	public String regForm(HttpServletRequest request, HttpServletResponse response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if(cookieUserId.isEmpty()) {
			return "/user/regForm";
		} else {
			CookieUtil.deleteCookie(request, response, AUTH_COOKIE_NAME);
			return "redirect:/";
		}
		
	}
	
	/* 아이디 중복체크 */
	@RequestMapping(value="/user/idCheck", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> idCheck(HttpServletRequest request, HttpServletResponse response) {
		
		String userId = HttpUtil.get(request, "userId");
		Response<Object> ajaxResponse = new Response<Object>();
		
		if(!StringUtil.isEmpty(userId)) {
			if(userService.userSelect(userId) == null ) {
				ajaxResponse.setResponse(0, "Success");
			} else {
				ajaxResponse.setResponse(100, "Duplicate");
			}
		} else {
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		if(logger.isDebugEnabled()) {
			logger.debug("[UserController] /user/idcheck\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		return ajaxResponse;
	}
	
	
	/* 회원 가입 */
	@RequestMapping(value="/user/regProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> regProc(HttpServletRequest request, HttpServletResponse response) {
		
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String userEmail = HttpUtil.get(request, "userEmail");
		Response<Object> ajaxResponse = new Response<Object>();
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail)) {
			if(userService.userSelect(userId) == null) {
				User user = new User();
				user.setUserId(userId);
				user.setUserPwd(userPwd);
				user.setUserName(userName);
				user.setUserEmail(userEmail);
				user.setStatus("Y");
				
				if(userService.userInsert(user) > 0) {
					ajaxResponse.setResponse(0, "Success");
				} else {
					ajaxResponse.setResponse(500, "Internal Server Error");
				}
			} else {
				ajaxResponse.setResponse(100, "Duplicate ID");
			}
		} else {
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		return ajaxResponse;
	}
	
	/* 회원 수정 페이지 */
	@RequestMapping(value="/user/updateForm", method=RequestMethod.GET)
	public String updateForm(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		String cookieUserId = "";
		
		if(CookieUtil.getCookie(request, AUTH_COOKIE_NAME) != null) {
			cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
			User user = userService.userSelect(cookieUserId);
			model.addAttribute("user", user);
			return "/user/updateForm";
		} else {
			CookieUtil.deleteCookie(request, response, AUTH_COOKIE_NAME);
			return "redirect:/";
		}
	}
	
	/* 회원 정보 수정 */
	@RequestMapping(value="/user/updateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String userEmail = HttpUtil.get(request, "userEmail");
		Response<Object> ajaxResponse = new Response<Object>();
		
		if(!StringUtil.isEmpty(cookieUserId)) {
			User user  = userService.userSelect(cookieUserId);
			if(user != null) {
				if(StringUtil.equals(user.getStatus(), "Y")) {
					if(!StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail)) {
						user.setUserPwd(userPwd);
						user.setUserName(userName);
						user.setUserEmail(userEmail);
						
						if(userService.userUpdate(user) > 0) {
							ajaxResponse.setResponse(0, "Success");
						} else {
							ajaxResponse.setResponse(500, "Internal Server Error");
						}
					} else {
						ajaxResponse.setResponse(401, "Bad Request 1");
					}
				} else {
					ajaxResponse.setResponse(402, "Bad Request 2 (Suspension of use)");
				}
			} else {
				CookieUtil.deleteCookie(request, response, AUTH_COOKIE_NAME);
				ajaxResponse.setResponse(404, "Not Found");
			}
		} else {
			CookieUtil.deleteCookie(request, response, AUTH_COOKIE_NAME);
			ajaxResponse.setResponse(-1,  "cookie not exist");
		}
		return ajaxResponse;
	}
	
	/* 로그 아웃 */
	@RequestMapping(value="/user/logoutProc", method=RequestMethod.GET)
	public String logout(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if(!StringUtil.isEmpty(cookieUserId) || cookieUserId != null) {
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
		}
		
		return "redirect:/index";
	}
	
}