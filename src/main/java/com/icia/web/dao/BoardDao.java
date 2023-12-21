package com.icia.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.icia.web.model.Board;
import com.icia.web.model.BoardFile;

@Repository("boardDao")
public interface BoardDao {
	
	public long boardCount(Board board);
	
	public List<Board> boardList(Board board);
	
	public int boardInsert(Board board);
	
	public int boardFileInsert(BoardFile boardFile);
	
	public Board boardSelect(long bbsSeq);
	
	public BoardFile boardFileSelect(long bbsSeq);
	
	public int bbsReadCntIncrement(long bbsSeq);
	
	public int boardReplyInsert(Board board);
	
	public int boardGroupOrderUpdate(Board board);
	
	public int boardDelete(long bbsSeq);
	
	public int boardFileDelete(long bbsSeq);
	
	public int boardAnswersCnt(long bbsSeq);
}
