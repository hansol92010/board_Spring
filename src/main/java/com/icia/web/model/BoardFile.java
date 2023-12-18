package com.icia.web.model;

import java.io.Serializable;

public class BoardFile implements Serializable {
	
	private static final long serialVersionUID = 126981963824964666L;
	
	private long bbsSeq;			// 게시물 번호
	private int fileSeq;			// 파일 번호
	private String fileOrgName;		// 원본 파일명
	private String fileName;		// 파일명
	private String fileExt;			// 파일 확장자
	private long fileSize;			// 파일크기(byte)
	private String regDate;			// 등록일
	
	public BoardFile() {
		this.bbsSeq = 0;
		this.fileSeq = 0;
		this.fileOrgName = "";
		this.fileName = "";
		this.fileExt = "";
		this.fileSize = 0;
		this.regDate = "";
	}

	public long getBbsSeq() {
		return bbsSeq;
	}

	public void setBbsSeq(long bbsSeq) {
		this.bbsSeq = bbsSeq;
	}

	public int getFileSeq() {
		return fileSeq;
	}

	public void setFileSeq(int fileSeq) {
		this.fileSeq = fileSeq;
	}

	public String getFileOrgName() {
		return fileOrgName;
	}

	public void setFileOrgName(String fileOrgName) {
		this.fileOrgName = fileOrgName;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileExt() {
		return fileExt;
	}

	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}

	public long getFileSize() {
		return fileSize;
	}

	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	
}
