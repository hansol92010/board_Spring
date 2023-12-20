package com.icia.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.icia.web.model.Board;
import com.icia.web.model.BoardFile;

@Repository("boardDao")
public interface BoardDao {
	
	public long boardCount(Board board);
	
	public List<Board> boardSelect(Board board);
	
	public int boardInsert(Board board);
	
	public int boardFileInsert(BoardFile boardFile);
	
	public Board boardDetail(long bbsSeq);
}
