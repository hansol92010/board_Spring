package com.icia.web.dao;

import org.springframework.stereotype.Repository;

import com.icia.web.model.Board;
import com.icia.web.model.BoardFile;

@Repository("boardDao")
public interface BoardDao {
	
	public Board boardSelect();
	
	public int boardInsert(Board board);
	
	public int boardFileInsert(BoardFile boardFile);
}
