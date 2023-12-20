package com.icia.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.icia.web.dao.BoardDao;
import com.icia.web.model.Board;
import com.icia.web.model.BoardFile;

@Service("boardService")
public class BoardService {
	
	private static Logger logger = LoggerFactory.getLogger(BoardService.class);

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
	public List<Board> boardSelect(Board board) {
		List list = null;
		
		try {
			list = boardDao.boardSelect(board);
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
	
	// 게시물 상세보기
	public Board boardDetail(long bbsSeq) {
		Board board = null;
		
		try {
			board = boardDao.boardDetail(bbsSeq);
		} catch(Exception e) {
			logger.error("[BoardService] boardDetail Exception", e);
		}
		
		return board;
	}
}
