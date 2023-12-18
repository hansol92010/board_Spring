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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.icia.common.model.FileData;
import com.icia.common.util.StringUtil;
import com.icia.web.model.Board;
import com.icia.web.model.BoardFile;
import com.icia.web.model.Response;
import com.icia.web.model.User;
import com.icia.web.service.BoardService;
import com.icia.web.service.UserService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;

@Controller("boardController")
public class BoardController {
	
	private static Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private UserService userService;
	
	@RequestMapping(value="/board/list", method=RequestMethod.GET)
	public String boardList(Model model) {
		Board board = boardService.boardSelect();
		System.out.println(board.getRegDate());
		model.addAttribute("board", board);
		return "/board/list";
	}
	
	@RequestMapping(value="/board/write", method=RequestMethod.GET)
	public String boardList(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId);
		model.addAttribute("user", user);
		
		return "/board/writeForm";
	}
	
	@RequestMapping(value="/board/writeProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProc(MultipartHttpServletRequest request, HttpServletResponse response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String bbsTitle = HttpUtil.get(request, "bbsTitle");
		String bbsContent = HttpUtil.get(request, "bbsContent");
		FileData fileData = HttpUtil.getFile(request, "bbsFile", UPLOAD_SAVE_DIR);
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		if(!StringUtil.isEmpty(bbsTitle) && !StringUtil.isEmpty(bbsContent)) {
			Board board = new Board();
			board.setUserId(cookieUserId);
			board.setBbsTitle(bbsTitle);
			board.setBbsContent(bbsContent);
			
			if(fileData != null && fileData.getFileSize() > 0) {
				BoardFile boardFile = new BoardFile();
				
				boardFile.setFileName(fileData.getFileName());
				boardFile.setFileOrgName(fileData.getFileOrgName());
				boardFile.setFileExt(fileData.getFileExt());
				boardFile.setFileSize(fileData.getFileSize());
				
				board.setBoardFile(boardFile);
			}
			
			try {
				if(boardService.boardInsert(board) > 0) {
					ajaxResponse.setResponse(0, "Success");
				} else {
					ajaxResponse.setResponse(500, "Internal Server Error");
				}
			} catch(Exception e) {
				logger.error("[BoardController] /board/writeProc Exception", e);
				ajaxResponse.setResponse(500, "Internal Server Error2");
			}
		} else {
			ajaxResponse.setResponse(400, "Band Request");
		}
	
		return ajaxResponse;
	
	}

}
