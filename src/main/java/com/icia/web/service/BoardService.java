package com.icia.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.icia.common.util.FileUtil;
import com.icia.web.dao.BoardDao;
import com.icia.web.model.Board;
import com.icia.web.model.BoardFile;

@Service("boardService")
public class BoardService {
	
	private static Logger logger = LoggerFactory.getLogger(BoardService.class);
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;

	@Autowired
	private BoardDao boardDao;
	
	// 총 게시물 수
	public long boardCount(Board board) {
		long count = 0;
		
		try {
			count = boardDao.boardCount(board);
		} catch(Exception e) {
			logger.error("[BoardService] boardCount Exception", e);
		}
		
		return count;
	}
	
	// 총 게시물 조회
	public List<Board> boardList(Board board) {
		List list = null;
		
		try {
			list = boardDao.boardList(board);
		} catch(Exception e) {
			logger.error("[BoardService] boardSelect Exception", e);
		}
		
		return list;
	}
	
	// 게시물 등록(파일 처리도 함께 한다)
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)	// Propagation.REQUIRED : 트랜잭션이 있으면 그 트랜젝션에서 실행, 없으면 새로운 트랜잭션을 실행(기본설정)
	public int boardInsert(Board board) throws Exception {
		int count = boardDao.boardInsert(board);
		
		if(count > 0 && board.getBoardFile() != null) {
			BoardFile boardFile = board.getBoardFile();
			boardFile.setBbsSeq(board.getBbsSeq());
			boardFile.setFileSeq((short)1);
			
			boardDao.boardFileInsert(board.getBoardFile());
		}

		return count;
	}
	
	// 게시물 존재 여부 조회용(조회수, 첨부파일 조회와는 상관X)
	public Board boardSelect(long bbsSeq) {
		Board board = null;
		
		try {
			board = boardDao.boardSelect(bbsSeq);
		} catch(Exception e) {
			logger.error("[BoardService] boardSelect Exception", e);
		}
		
		return board;
	}
	
	// 게시물 첨부파일만 조회
	public BoardFile boardFileSelect(long bbsSeq) {
		BoardFile boardFile = null;
		try {
			boardFile = boardDao.boardFileSelect(bbsSeq);
		} catch(Exception e) {
			logger.error("[BoardService] boardFileSelect Exception", e);
		}
		return boardFile;
	}
	
	// 게시물 상세보기용(조회수, 첨부파일 조회까지)
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public Board boardView(long bbsSeq) throws Exception {
		Board board = null;
		
		board = boardDao.boardSelect(bbsSeq);
		if(board != null) {
			boardDao.bbsReadCntIncrement(bbsSeq);	// 조회수 증가
			
			BoardFile boardFile = boardDao.boardFileSelect(bbsSeq);		// 해당 게시물에 첨부파일 여부를 조회
			if(boardFile != null) {
				board.setBoardFile(boardFile);
			}
		}
		return board;
	}
	
	// 게시물 답글 등록
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardReplyInsert(Board board) throws Exception {
		int count = 0;
		boardDao.boardGroupOrderUpdate(board);		// 아래 reply 등록(boardReplyInsert)보다 먼저 업데이트가 이루어져야 한다
		count = boardDao.boardReplyInsert(board);
		if(count > 0 && board.getBoardFile() != null) {
			BoardFile boardFile = board.getBoardFile();
			boardFile.setBbsSeq(boardFile.getBbsSeq());
			boardFile.setFileSeq((short)1);
			
			boardDao.boardFileInsert(boardFile);
		}
		return count;
	}
	
	// 게시물 삭제(첨부파일 삭제)
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardDelete(long bbsSeq) throws Exception {
		int count = 0;
		Board board = boardDao.boardSelect(bbsSeq);
		if(board != null) {
			count = boardDao.boardDelete(bbsSeq);
			if(count > 0) {
				BoardFile boardFile = boardDao.boardFileSelect(bbsSeq);
				if(boardFile != null) {
					if(boardDao.boardFileDelete(bbsSeq) > 0) {
						FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + boardFile.getFileName());
						logger.debug("servcie==============================================");
						logger.debug("UPLOAD_SAVE_DIR : " + UPLOAD_SAVE_DIR);
						logger.debug("FileUtil.getFileSeparator() : " + FileUtil.getFileSeparator());
						logger.debug("hiBoardFile.getFileName() : " + boardFile.getFileName());
						logger.debug("=====================================================");
					}
				}
			}
		}
		return count;
	}
	
	// 게시글의 답글 수
	public int boardAnswersCnt(long bbsSeq) {
		int count = 0;
		try {
			count = boardDao.boardAnswersCnt(bbsSeq);
		} catch(Exception e) {
			logger.debug("[BoardService] boardAnswersCnt Exception", e);
		}
		return count;
	}
	
	// 게시글 수정 페이지 조회 항목(상세보기용 조회에서 조회수 카운트만 빼고)
	public Board boardUpdateFormView(long bbsSeq) {
		Board board = null;
		
		try {
			board = boardDao.boardSelect(bbsSeq);
			if(board != null) {		
				BoardFile boardFile = boardDao.boardFileSelect(bbsSeq);	
				
				if(boardFile != null) {
					board.setBoardFile(boardFile);
				}
			}
		} catch(Exception e) {
			logger.error("[BoardService] boardUpdateView Exception", e);
		}
		
		return board;
	}
	
	
	// 게시글 수정
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardUpdate(Board board) throws Exception {
		int count = boardDao.boardUpdate(board);
		if(count > 0 && board.getBoardFile() != null) {
			// 기존 첨부파일
			BoardFile preBoardFile = boardDao.boardFileSelect(board.getBbsSeq());
			
			// 기존 첨부파일 삭제
			if(preBoardFile != null) {
				FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + preBoardFile.getFileName());
				boardDao.boardFileDelete(board.getBbsSeq());
			}
			
			// 새로운 첨부파일
			BoardFile newBoardFile = board.getBoardFile();
			
			// 새로운 첨부파일 삽입
			newBoardFile.setBbsSeq(board.getBbsSeq());
			newBoardFile.setFileSeq((short)1);
			boardDao.boardFileInsert(newBoardFile);
		}
		
		
		return count;
	}
}
