package com.icia.web.controller;

import java.util.ArrayList;
import java.util.List;

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
import com.icia.web.model.Paging;
import com.icia.web.model.Response;
import com.icia.web.model.User;
import com.icia.web.service.BoardService;
import com.icia.web.service.UserService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;
import com.icia.web.util.JsonUtil;

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
	
	private static final int LIST_COUNT = 5;
	private static final int PAGE_COUNT = 5;
	
	// 게시물 조회 리스트
	@RequestMapping(value="/board/list", method=RequestMethod.GET)
	public String boardList(HttpServletRequest request, Model model) {
		
		System.out.println("###################################");
		
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		long totalCount = 0;
		Board board = new Board();
		Paging paging = null;
		List<Board> list  = null;
		
		if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
			board.setSearchType(searchType);
			board.setSearchValue(searchValue);
		}
		
		totalCount = boardService.boardCount(board);
		logger.debug("==========================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("==========================================");
		
		if(totalCount > 0) {
			paging = new Paging("/board/list", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			board.setStartRow(paging.getStartRow());
			board.setEndRow(paging.getEndRow());
			
			list = boardService.boardList(board);
			logger.debug("size" + list.size());
		}
		
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("paging", paging);
		
		return "/board/list";
	}
	
	@RequestMapping(value="/board/write", method=RequestMethod.GET)
	public String writeForm(HttpServletRequest request, HttpServletResponse response, Model model) {
		
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
	
	@RequestMapping(value="/board/view", method=RequestMethod.GET)
	public String detailView(HttpServletRequest request, Model model) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		Long bbsSeq = Long.parseLong(HttpUtil.get(request, "bbsSeq"));
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		// 로그인 아이디가 게시물의 작성자인지 여부
		String boardMe = "N";
		
		Board board = null;
		
		if(bbsSeq > 0) {
			try {
				board = boardService.boardView(bbsSeq);
				if(board != null && StringUtil.equals(cookieUserId, board.getUserId())) {
					boardMe = "Y";
				}
			} catch(Exception e) {
				logger.debug("[BoardController] detailView Exception", e);
			}
		}
		
		model.addAttribute("board", board);
		model.addAttribute("curPage", curPage);
		model.addAttribute("boardMe", boardMe);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		
		return "/board/view";
	}
	
	// 답변 쓰기 페이지
	@RequestMapping(value="/board/reply", method=RequestMethod.GET)
	public String reply(HttpServletRequest request, Model model) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long bbsSeq = HttpUtil.get(request, "bbsSeq", (long)0);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		Board board = null;
		User user = null;
		
		if(bbsSeq > 0) {
			board = boardService.boardSelect(bbsSeq);
			if(board != null) {
				user = userService.userSelect(cookieUserId);
			}
		}
		
		model.addAttribute("board", board);
		model.addAttribute("user", user);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		
		return "/board/replyForm";
	}
	
	@RequestMapping(value="/board/replyProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> replyProc(MultipartHttpServletRequest request, HttpServletResponse response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long bbsSeq = HttpUtil.get(request, "bbsSeq", (long)0);
		String bbsTitle = HttpUtil.get(request, "bbsTitle");
		String bbsContent = HttpUtil.get(request, "bbsContent");
		FileData fileData = HttpUtil.getFile(request, "bbsFile", UPLOAD_SAVE_DIR);
		
		System.out.println("#########################" + bbsSeq);
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		if(bbsSeq > 0 && !StringUtil.isEmpty(bbsTitle) && !StringUtil.isEmpty(bbsContent)) {
			Board parentBoard = boardService.boardSelect(bbsSeq);
			
			if(parentBoard != null) {
				Board board = new Board();
				board.setUserId(cookieUserId);
				board.setBbsTitle(bbsTitle);
				board.setBbsContent(bbsContent);
				board.setBbsGroup(parentBoard.getBbsGroup());
				board.setBbsOrder(parentBoard.getBbsOrder() + 1);
				board.setBbsIndent(parentBoard.getBbsIndent() + 1);
				board.setBbsParent(bbsSeq);
				
				if(fileData != null && fileData.getFileSize() > 0) {
					BoardFile boardFile = new BoardFile();
					boardFile.setFileName(fileData.getFileName());
					boardFile.setFileOrgName(fileData.getFileOrgName());
					boardFile.setFileExt(fileData.getFileExt());
					boardFile.setFileSize(fileData.getFileSize());
					
					board.setBoardFile(boardFile);
				}
				
				try {
					if(boardService.boardReplyInsert(board) > 0) {
						ajaxResponse.setResponse(0, "Success");
					} else {
						ajaxResponse.setResponse(500, "Internal Server Error1");
					}
				} catch(Exception e) {
					logger.error("[BoardController] /board/replyProc Exception", e);
					ajaxResponse.setResponse(500, "Internal Server Error2");
				}
			} else {
				ajaxResponse.setResponse(400, "Not Found");
			}
		} else {
			ajaxResponse.setResponse(404, "Bad Request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /board/replyProc response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;	
	}
	
	// 게시물 삭제
	@RequestMapping(value="/board/deleteProc", method=RequestMethod.GET)
	@ResponseBody
	public Response<Object> boardDelete(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long bbsSeq = HttpUtil.get(request, "bbsSeq", (long)0);
		
		Board board = null;
		Response<Object> ajaxResponse = new Response<Object>();
		
		if(bbsSeq > 0) {
			board = boardService.boardSelect(bbsSeq);
			if(board != null) {
				if(StringUtil.equals(cookieUserId, board.getUserId())) {
					try {
						if(boardService.boardAnswersCnt(bbsSeq) > 0) {
							ajaxResponse.setResponse(-999, "answer exist and cannot be deleted");
						} else {
							if(boardService.boardDelete(board.getBbsSeq()) > 0) {
								ajaxResponse.setResponse(0, "Success");
							} else {
								ajaxResponse.setResponse(500, "Internal Server Error1");
							}
						}
					} catch(Exception e) {
						logger.debug("[BoardController] boardDelete Exception", e);
						ajaxResponse.setResponse(500, "Internal Server Error2");
					}
				} else {
					ajaxResponse.setResponse(404, "Not Found1");
				} 
			} else {
				ajaxResponse.setResponse(404, "Not Found2");
			}
		} else {
			ajaxResponse.setResponse(400, "Bad Request");
		}
		return ajaxResponse;
	}

}
