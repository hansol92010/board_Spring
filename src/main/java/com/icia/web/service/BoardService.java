package com.icia.web.service;

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
	
	// 게시물 조회
	public Board boardSelect() {
		Board board = null;
		
		try {
			board = boardDao.boardSelect();
		} catch(Exception e) {
			logger.error("[BoardService] boardSelect Exception", e);
		}
		
		return board;
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
}
