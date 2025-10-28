/*
 * - 데이터 딕셔너리란?
 * 데이터베이스에 저장된 데이터구조, 메타데이터 정보를 포함하는
 * 데이터베이스 객체.
 *
 * 일반적으로 데이터베이스 시스템은 데이터 딕셔너리를 사용하여
 * 데이터베이스의 테이블, 뷰, 인덱스, 제약조건 등과 관련된 정보를 저장하고 관리함.
 *
 * * USER_TABLES : 계정이 소유한 객체 등에 관한 정보를 조회 할 수 있는 딕셔너리 뷰
 * * USER_CONSTRAINTS : 계정이 작성한 제약조건을 확인할 수 있는 딕셔너리 뷰
 * * USER_CONS_COLUMNS : 제약조건이 걸려있는 컬럼을 확인하는 딕셔너리 뷰
 * */




SELECT * FROM USER_TABLES;
SELECT * FROM USER_CONSTRAINTS;
SELECT * FROM USER_CONS_COLUMNS;


---------------------------------------------------------------------

-- DDL (DATA DEFINITION LANGUAGE) : 데이터 정의 언어
-- 객체(OBJECT)를 만들고(CREATE), 수정(ALTER)하고, 삭제(DROP) 등
-- 데이터의 전체 구조를 정의하는 언어로 주로 DB관리자, 설계자가 사용함.


-- 객체 : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE),
--        인덱스(INDEX), 사용자(USER),
--        패키지(PACKAGE), 트리거(TRIGGER)
--        프로시져(PROCEDURE), 함수(FUNCTION)
--        동의어(SYNONYM)..


----------------------------------------------------------------------


-- CREATE(생성)


-- 테이블이나 인덱스, 뷰 등 다양한 데이터베이스 객체를 생성하는 구문
-- 테이블로 생성된 객체는 DROP 구문을 통해 제거 할 수 있음
-- DROP TABLE MEMBER;


/*
 * -- 표현식
 *
 * CREATE TABLE 테이블명 (
 *    컬럼명 자료형(크기),
 *    컬럼명 자료형(크기),
 *    ...
 * );
 *
 * */


/*
 * 자료형
 *
 * NUMBER : 숫자형(정수, 실수)
 *
 * CHAR(크기) : 고정길이 문자형 (2000 BYTE) : 데이터베이스의 기본 문자 세트(UTF-8)로 인코딩
 *    --> 바이트 수 기준.
 *    --> 영어/숫자/기호 1BYTE, 한글 3BYTE
 *    --> CHAR(10) 컬럼에 'ABC' 3BYTE 문자열만 저장해도 10BYTE 저장공간 모두 사용(남은 공간 공백으로 채움 -> 낭비)
 *
 * VARCHAR2(크기) : 가변길이 문자형 (최대 4000 BYTE) : 데이터베이스의 기본 문자 세트(UTF-8)로 인코딩
 *    --> 바이트 수 기준.
 *    --> 영어/숫자/기호 1BYTE, 한글 3BYTE
 *    --> VARCHAR2(10) 컬럼에 'ABC' 3BYTE 문자열만 저장하면 나머지 7BYTE 남은 공간 반환
 *
 * NVARCHAR2(문자수) : 가변길이 문자형 (최대 4000 BYTE -> 2000글자) : UTF-16로 인코딩
 *    --> 문자길이 수 기준.
 *    --> 모든문자 2BYTE
 *    --> NVARCHAR2(10) 컬럼에 10 글자길이 아무글자(영어,숫자,한글 등) 가능
 *    --> NVARCHAR2(10) 컬럼에 '안녕'과 같은 2글자(유니코드 문자)를 입력했을 때,
 *      나머지 8개의 문자 남은 공간 반환
 *
 * DATE : 날짜 타입
 * BLOB : 대용량 이진 데이터 (4GB)
 * CLOB : 대용량 문자 데이터 (4GB)
 *
 * */

-- MEMBER 테이블 생성
CREATE TABLE MEMBER (
	MEMBER_ID VARCHAR2(20),
	MEMBER_PWD VARCHAR2(20),
	MEMBER_NAME VARCHAR2(30),
	MEMBER_SSN CHAR(14), -- '991213-1234567'
	ENROLL_DATE DATE DEFAULT SYSDATE
);

-- 만든 테이블 확인
SELECT * FROM MEMBER;

-- 2. ✔️컬럼에 주석 달기
-- [표현식]
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '주석 내용';
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER.MEMBER_SSN IS '회원 주민등록번호';
COMMENT ON COLUMN MEMBER.ENROLL_DATE IS '회원 가입일';

SELECT * FROM MEMBER;

-- MEMBER 테이블에 샘플 데이터 삽입
INSERT INTO MEMBER 
VALUES ('MEM01', '123ABC', '홍길동', '991213-1234567', DEFAULT);
--> DATE에 DEFAULT를 넣으면 DEFAULT로 설정한 값이 들어감

SELECT * FROM MEMBER;

-- * INSERT/UPDATE 시 컬럼 값으로 DEFAULT를 작성하면 
-- 테이블 생성 시 해당 컬럼에 지정된 DEFAULT 값으로 삽입이 된다! *


-- 데이터 삽입 확인
SELECT * FROM MEMBER;

COMMIT;

INSERT INTO MEMBER 
VALUES ('MEM02', 'QWER1234', '김영희', '000123-2233445', SYSDATE);

--> 가입일 -> INSERT 시 미작성 하는 경우
-- DEFAULT 값이 반영되는지 확인

INSERT INTO MEMBER (MEMBER_ID, MEMBER_PWD, MEMBER_NAME)
VALUES ('MEM03', '1Q2W3E', '이지연');

SELECT * FROM MEMBER;

COMMIT;

-- ** NUMBER 타입의 문제점 **
-- MEMBER2 테이블 (아이디, 비밀번호, 이름, 전화번호)

CREATE TABLE MEMBER2(
	MEMBER_ID VARCHAR2(20),
	MEMBER_PWD VARCHAR2(20),
	MEMBER_NAME VARCHAR2(30),
	MEMBER_TEL NUMBER
);

INSERT INTO MEMBER2 
VALUES('MEM01', 'PASS01', '고길동', 01012341234);

SELECT * FROM MEMBER2;
-- 숫자 타입은 맨앞에 0이 있으면 지워버림
--> NUMBER 타입 컬럼에 데이터 삽입 시
-- 제일 앞에 0이 있으면 이를 자동으로 제거함
--> 전화번호, 주민등록번호처럼 숫자로만 되어있는 데이터라도
-- 0으로 시작할 가능성이 있으면 CHAR, VHACHAR2 같은 문자형 이용해야함 !!!

-- 2025-10-23
----------------------------------------------------------------------
-- 2025-10-24
-- 제약 조건 (CONSTRAINTS)

/*
 * 사용자가 원하는 조건의 데이터만 유지하기 위해서
 * 특정 컬럼에 설정하는 제약.
 * -> 중복 데이터 X
 * 
 * 입력 데이터에 문제가 없는지 자동으로 검사하는 목적
 * 데이터의 수정/삭제 가능 여부 검사하는 목적으로 함.
 * --> 제약조건을 위배하는 DML 구문은 수행할 수 없다.
 * 
 * 제약조건 종류
 * PRIMARY KEY, NOT NULL, UNIQUE, CHECK, FOREIGN KEY
 * 
 * */

-- 1. NOT NULL
-- 해당 컬럼에 반드시 값이 기록되어야 하는 경우 사용
-- 삽입/수정 시 NULL 값을 허용하지 않도록 컬럼레벨에서 제한

-- * 컬럼레벨 : 테이블 생성 시 컬럼을 정의하는 부분에 작성하는 것

CREATE TABLE USER_USED_NN (
	USER_NO NUMBER NOT NULL, -- 사용자 번호(모든 사용자는 사용자 번호가 있어야한다)
	USER_ID VARCHAR2(20), 
	USER_PWD VARCHAR2(20),
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(20),
	EMAIL VARCHAR2(50) -- 마지막 컬럼 작성 부분까지 컬럼 레벨
	-- 테이블 레벨
);

INSERT INTO USER_USED_NN VALUES(1, 'USER01', 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr');

INSERT INTO USER_USED_NN VALUES(NULL, 'USER01', 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr');
-- NULL을 ("KH_AJH"."USER_USED_NN"."USER_NO") 안에 삽입할 수 없습니다
--> NOT NULL 제약조건 위배되어 오류 발생!

SELECT * FROM USER_USED_NN;

--------------------------------------------------------------

-- 2. UNIQUE 제약조건
-- 컬럼에 입력값에 대해서 중복을 제한하는 제약조건
-- 컬럼레벨에서 설정 가능, 테이블레벨에서 설정 가능
-- 단, UNIQUE 제약조건이 설정된 컬럼에 NULL 값은 중복 삽입 가능.

-- * 테이블 레벨 : 테이블 생성 시 컬럼 정의가 끝난 후, 마지막에 작성

-- * 제약조건 지정 방법
-- 1) 컬럼 레벨 : [CONSTRAINT 제약조건명] 제약조건
-- 2) 테이블 레벨 : [CONSTRAINT 제약조건명] 제약조건(컬럼명)

-- UNIQUE 제약조건 테이블 생성
CREATE TABLE USER_USED_UK (
	USER_NO NUMBER NOT NULL, -- 사용자 번호(모든 사용자는 사용자 번호가 있어야한다)
	-- USER_ID VARCHAR2(20) UNIQUE, -- 컬럼레벨 (제약조건명 미지정) 
	-- USER_ID VARCHAR2(20) CONSTRAINT USER_ID_U UNIQUE, -- 컬럼레벨 (제약조건명 지정 -> USER_ID_U)
	USER_ID VARCHAR2(20), -- UNIQUE 제약조건 설정된 컬럼(회원 아이디)
	USER_PWD VARCHAR2(20),
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(20),
	EMAIL VARCHAR2(50),
	-- 테이블 레벨
	-- UNIQUE(USER_ID) -- 테이블레벨(제약조건명 미지정)
	CONSTRAINT USER_ID_U UNIQUE(USER_ID) -- 테이블레벨(제약조건명 지정)
);


INSERT INTO USER_USED_UK VALUES
(1, 'USER01', 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr');

INSERT INTO USER_USED_UK VALUES
(1, 'USER01', 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr');
-- ORA-00001: 무결성 제약 조건(KH_AJH.USER_ID_U)에 위배됩니다

INSERT INTO USER_USED_UK VALUES
(1, NULL, 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr');
-- 아이디에 NULL값 삽입 가능 확인 (UNIQUE 제약조건 있어도 NULL 값 허용)

INSERT INTO USER_USED_UK VALUES
(1, NULL, 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr');

--> 아이디에 NULL값 중복 삽입 가능 확인 (UNIQUE 제약조건은 NULL값은 중복 허용)

---------------------------------------------------------------

-- ✔️
-- UNIQUE 복합키
-- 두 개 이상의 컬럼을 묶어서 하나의 UNIQUE 제약조건을 설정함

-- * 복합키 지정은 테이블 레벨만 가능하다! *
-- * 복합키는 지정된 모든 컬럼의 값이 같을 때 위배된다 ! *

CREATE TABLE USER_USED_UK2 (
	USER_NO NUMBER NOT NULL, 
	USER_ID VARCHAR2(20), 
	USER_PWD VARCHAR2(20),
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(20),
	EMAIL VARCHAR2(50),
	-- 컬럼 레벨에서는 복합키가 불가능
	-- 테이블 레벨 UNIQUE 복합키 지정
	CONSTRAINT USER_ID_NAME_U UNIQUE(USER_ID, USER_NAME)
);

INSERT INTO USER_USED_UK2 VALUES
(1, 'USER01', 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr');


INSERT INTO USER_USED_UK2 VALUES
(1, 'USER02', 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr');

INSERT INTO USER_USED_UK2 VALUES
(1, 'USER02', 'PASS01', '고길동', '남자', '010-1234-5678', 'hong@kr.or.kr');

INSERT INTO USER_USED_UK2 VALUES
(1, 'USER02', 'PASS01', '고길동', '남자', '010-1234-5678', 'hong@kr.or.kr');

-- ORA-00001: 무결성 제약 조건(KH_AJH.USER_ID_NAME_U)에 위배됩니다
--> 복합키로 지정된 컬럼값 중 하나라도 다르면 위배되지 않음
--> 모든 컬럼의 값이 중복되면 위배된다!

------------------------------------------------------------

-- ✔️
-- 3. PRIMARY KEY (기본키)
-- 테이블에서 한 행의 정보를 찾기 위해 사용할 컬럼을 의미함.
-- 테이블에 대한 식별자(회원 번호, 학번..) 역할을 함

-- NOT NULL + UNIQUE 제약조건의 의미 -> 중복되지 않는 값이 필수로 존재해야함.

-- 한 테이블당 한 개 설정할 수 있음
-- 컬럼레벨, 테이블레벨 둘 다 설정 가능
-- 한 개 컬럼에 설정할 수 있고, 복합키로 설정가능 (PRIMARY 복합키)
-- -> 즉, 복합키로 한개 만들 수도 있다는 의미
CREATE TABLE USER_USED_PK(
	-- USER_NO NUMBER CONSTRAINT USER_NO_PK PRIMARY KEY, -- 컬럼 레벨(제약조건명 지정)
	USER_NO NUMBER PRIMARY KEY, -- 컬럼 레벨(제약조건명 지정 X)
	USER_ID VARCHAR2(20), 
	USER_PWD VARCHAR2(20),
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(20),
	EMAIL VARCHAR2(50)
	-- 테이블 레벨
	-- CONSTRAINT USER_NO_PK PRIMARY KEY(USER_NO)
);


INSERT INTO USER_USED_PK VALUES
(1, 'USER01', 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr');

INSERT INTO USER_USED_PK VALUES
(1, 'USER02', 'PASS02', '이순신', '남자', '010-2222-3333', 'lee@kr.or.kr');
-- ORA-00001: 무결성 제약 조건(KH_AJH.SYS_C007408)에 위배됩니다
--> 기본키 중복 오류!

INSERT INTO USER_USED_PK VALUES
(NULL, 'USER02', 'PASS02', '이순신', '남자', '010-2222-3333', 'lee@kr.or.kr');
-- ORA-01400: NULL을 ("KH_AJH"."USER_USED_PK"."USER_NO") 안에 삽입할 수 없습니다
--> 기본키 NULL 이므로 오류!

INSERT INTO USER_USED_PK VALUES
(2, 'USER02', 'PASS02', '이순신', '남자', '010-2222-3333', 'lee@kr.or.kr');
-- 삽입 가능!

---------------------------------------------------

-- PRIMARY KEY 복합키 (테이블 레벨만 가능)
CREATE TABLE USER_USED_PK2 (
	USER_NO NUMBER, 
	USER_ID VARCHAR2(20), 
	USER_PWD VARCHAR2(20),
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(20),
	EMAIL VARCHAR2(50),
	-- 테이블 레벨
	CONSTRAINT PK_USERNO_USERID PRIMARY KEY(USER_NO, USER_ID)
);

INSERT INTO USER_USED_PK2 VALUES
(1, 'USER01', 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr');

INSERT INTO USER_USED_PK2 VALUES
(1, 'USER02', 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr');

INSERT INTO USER_USED_PK2 VALUES
(2, 'USER02', 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr');

INSERT INTO USER_USED_PK2 VALUES
(2, 'USER02', 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr');
-- ORA-00001: 무결성 제약 조건(KH_AJH.PK_USERNO_USERID)에 위배됩니다
--> USER_NO, USER_ID 둘 다 중복되었을 때만 제약조건 위배!

INSERT INTO USER_USED_PK2 VALUES
(NULL, 'USER02', 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr');
-- ORA-01400: NULL을 ("KH_AJH"."USER_USED_PK2"."USER_NO") 안에 삽입할 수 없습니다
-- 아무리 복합키라도, 둘중에 하나라도 NULL이면 위배됌

INSERT INTO USER_USED_PK2 VALUES
(3, NULL, 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr');
-- ORA-01400: NULL을 ("KH_AJH"."USER_USED_PK2"."USER_ID") 안에 삽입할 수 없습니다

--> 복합키 중, 하나라도 NULL이면 제약조건 위배!

SELECT * FROM USER_USED_PK2;

----------------------------------------------------------------

-- ✔️
-- 4. FOREIGN KEY(외래키/외부키) 제약조건 

-- 참조(REFERENCES)된 다른 테이블의 컬럼이 제공하는 값만 사용할 수 있음
-- FOREIGN KEY 제약조건에 의해서 테이블간의 관계가 형성됨
-- 제공되는 값 외에는 NULL 을 사용할 수 있음.

-- 컬럼레벨일 경우
-- 컬럼명 자료형(크기) [CONSTRAINT 이름] 
-- REFERENCES 참조할테이블명[(참조할컬럼명)] [삭제룰]

-- 테이블레벨일 경우
-- [CONSTRAINT 이름] FOREIGN KEY (적용할컬럼명) 
-- REFERENCES 참조할테이블명 [(참조할컬럼명)] [삭제룰]

-- * 참조될 수 있는 컬럼은 PRIMARY KEY 컬럼과, UNIQUE 지정된 컬럼만 외래키로 사용 가능
-- 참조할 테이블의 참조할 컬럼명이 생략되면, PRIMARY KEY로 설정된 컬럼이
-- 자동 참조할 컬럼이 됨.


-- 부모테이블 / 참조할 테이블 / 레퍼런스 테이블 (대상이 되는 테이블)
CREATE TABLE USER_GRADE (
	GRADE_CODE NUMBER PRIMARY KEY, -- 등급 고유식별 번호
	GRADE_NAME VARCHAR2(30) NOT NULL  -- 등급 명칭
);

INSERT INTO USER_GRADE VALUES(10, '일반회원');
INSERT INTO USER_GRADE VALUES(20, '우수회원');
INSERT INTO USER_GRADE VALUES(30, '특별회원');

SELECT * FROM USER_GRADE;

-- 자식 테이블 (USER_GRADE 테이블을 참조하여 사용할 테이블)
CREATE TABLE USER_USED_FK(
	USER_NO NUMBER PRIMARY KEY, -- 사용자번호(고유한 번호 : 중복 X / NULL X)
	USER_ID VARCHAR2(20) UNIQUE, -- 사용자 아이디(중복 X)
	USER_PWD VARCHAR2(20) NOT NULL, -- 사용자 비밀번호(NULL X)
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(20),
	EMAIL VARCHAR2(50),
	GRADE_CODE NUMBER CONSTRAINT GRADE_CODE_FK REFERENCES USER_GRADE -- GRADE_CODE 생략가능
								-- 컬럼명 미작성 시 USER_GRADE 테이블의 PK를 자동 참조
	-- 테이블레벨
	-- , CONSTRAINT GRADE_CODE_FK FOREIGN KEY(GRADE_CODE) REFERENCES USER_GRADE -- (GRADE_CODE)
	--> FOREIGN KEY 명령어는 테이블 레벨에서만 사용!
);

INSERT INTO USER_USED_FK VALUES
(1, 'USER01', 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr', 10);
-- USER_GRADE(부모테이블/참조테이블)에 10이라는 GRADE_CODE가 존재하므로
-- 자식테이블이 10이라는 값 사용 가능

INSERT INTO USER_USED_FK VALUES
(2, 'USER02', 'PASS02', '이순신', '남자', '010-3333-4444', 'lee@kr.or.kr', 10);
-- USER_GRADE(부모테이블/참조테이블)에 10이라는 GRADE_CODE가 존재하므로
-- 자식테이블이 10이라는 값 사용 가능

INSERT INTO USER_USED_FK VALUES
(3, 'USER03', 'PASS03', '유관순', '여자', '010-3333-1111', 'yoo@kr.or.kr', 30);
-- USER_GRADE(부모테이블/참조테이블)에 10이라는 GRADE_CODE가 존재하므로
-- 자식테이블이 10이라는 값 사용 가능

INSERT INTO USER_USED_FK VALUES
(4, 'USER04', 'PASS04', '안중근', '남자', '010-2222-1111', 'ahn@kr.or.kr', NULL);
--> NULL 사용 가능

INSERT INTO USER_USED_FK VALUES
(5, 'USER05', 'PASS05', '윤봉길', '남자', '010-6666-6666', 'yoon@kr.or.kr', 50);
-- ORA-02291: 무결성 제약조건(KH_AJH.GRADE_CODE_FK)이 위배되었습니다- 부모 키가 없습니다
--> 외래키 제약조건에 위배되어 오류 발생(부모의 GRADE_CODE에는 50이 없음)

----------------------------------------------------------------

-- * FOREIGN KEY 삭제 옵션
-- 부모 테이블의 데이터 삭제 시 자식 테이블의 데이터를
-- 어떤 식으로 처리할지에 대한 내용을 설정할 수 있다.

-- 1) ON DELETE RESTRICTED(삭제 제한)로 기본 지정되어 있음.
-- FOREIGN KEY로 지정된 컬럼에서 사용되고 있는 값일 경우
-- 제공하는 컬럼의 값은 삭제하지 못함
--> 이미 부모 테이블에서 자식에게 제공하고, 자식에서 해당 컬럼을 쓰고있다면 부모 테이블에서 삭제해도
--  자식 테이블에서 삭제안함

DELETE FROM USER_GRADE WHERE GRADE_CODE = 30;
-- ORA-02292: 무결성 제약조건(KH_AJH.GRADE_CODE_FK)이 위배되었습니다- 자식 레코드가 발견되었습니다
-- 즉, 자식 테이블에서 이미 사용중이기 떄문에 삭제할 수 없다는 것

DELETE FROM USER_GRADE WHERE GRADE_CODE = 20;
-- GRADE_CODE 중 20은 외래키로 참조되고 있지 않으므로 삭제가 가능함.

SELECT * FROM USER_GRADE;
ROLLBACK; 

-- 2) ON DELETE SET NULL : 부모키 삭제 시 자식키를 NULL로 변경하는 옵션

CREATE TABLE USER_GRADE2 (
	GRADE_CODE NUMBER PRIMARY KEY, -- 등급 고유식별 번호
	GRADE_NAME VARCHAR2(30) NOT NULL  -- 등급 명칭
);

INSERT INTO USER_GRADE2 VALUES(10, '일반회원');
INSERT INTO USER_GRADE2 VALUES(20, '우수회원');
INSERT INTO USER_GRADE2 VALUES(30, '특별회원');

CREATE TABLE USER_USED_FK2(
	USER_NO NUMBER PRIMARY KEY, -- 사용자번호(고유한 번호 : 중복 X / NULL X)
	USER_ID VARCHAR2(20) UNIQUE, -- 사용자 아이디(중복 X)
	USER_PWD VARCHAR2(20) NOT NULL, -- 사용자 비밀번호(NULL X)
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(20),
	EMAIL VARCHAR2(50),
	GRADE_CODE NUMBER CONSTRAINT 
	GRADE_CODE_FK2 REFERENCES USER_GRADE2 ON DELETE SET NULL 
											/* 삭제 옵션 */
);
INSERT INTO USER_USED_FK2 VALUES
(1, 'USER01', 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr', 10);

INSERT INTO USER_USED_FK2 VALUES
(2, 'USER02', 'PASS02', '이순신', '남자', '010-3333-4444', 'lee@kr.or.kr', 10);

INSERT INTO USER_USED_FK2 VALUES
(3, 'USER03', 'PASS03', '유관순', '여자', '010-3333-1111', 'yoo@kr.or.kr', 30);

INSERT INTO USER_USED_FK2 VALUES
(4, 'USER04', 'PASS04', '안중근', '남자', '010-2222-1111', 'ahn@kr.or.kr', NULL);

INSERT INTO USER_USED_FK3 VALUES
(5, 'USER05', 'PASS05', '윤봉길', '남자', '010-6666-6666', 'yoon@kr.or.kr', 50);


COMMIT;


-- 부모테이블인 USER_GRADE3에서 GRADE_CODE = 10 삭제

DELETE FROM USER_GRADE2
WHERE GRADE_CODE = 10;
-- 10을 사용하고 있던 자식값이 NULL이 됨을 확인

-- 3) ON DELETE CASCASE : 부모키 삭제시 자식키도 함께 삭제됨
-- 부모키 삭제 시 값을 사용하고 있던 자식 테이블의 행이 삭제됨
SELECT * FROM USER_GRADE2;
SELECT * FROM USER_USED_FK2;

CREATE TABLE USER_GRADE3 (
	GRADE_CODE NUMBER PRIMARY KEY, -- 등급 고유식별 번호
	GRADE_NAME VARCHAR2(30) NOT NULL  -- 등급 명칭
);

INSERT INTO USER_GRADE3 VALUES(10, '일반회원');
INSERT INTO USER_GRADE3 VALUES(20, '우수회원');
INSERT INTO USER_GRADE3 VALUES(30, '특별회원');

CREATE TABLE USER_USED_FK3(
	USER_NO NUMBER PRIMARY KEY, -- 사용자번호(고유한 번호 : 중복 X / NULL X)
	USER_ID VARCHAR2(20) UNIQUE, -- 사용자 아이디(중복 X)
	USER_PWD VARCHAR2(20) NOT NULL, -- 사용자 비밀번호(NULL X)
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(20),
	EMAIL VARCHAR2(50),
	GRADE_CODE NUMBER CONSTRAINT 
	GRADE_CODE_FK3 REFERENCES USER_GRADE3 ON DELETE CASCADE
);

INSERT INTO USER_USED_FK3 VALUES
(1, 'USER01', 'PASS01', '홍길동', '남자', '010-1234-5678', 'hong@kr.or.kr', 10);

INSERT INTO USER_USED_FK3 VALUES
(2, 'USER02', 'PASS02', '이순신', '남자', '010-3333-4444', 'lee@kr.or.kr', 10);

INSERT INTO USER_USED_FK3 VALUES
(3, 'USER03', 'PASS03', '유관순', '여자', '010-3333-1111', 'yoo@kr.or.kr', 30);

INSERT INTO USER_USED_FK3 VALUES
(4, 'USER04', 'PASS04', '안중근', '남자', '010-2222-1111', 'ahn@kr.or.kr', NULL);


SELECT * FROM USER_GRADE3;
SELECT * FROM USER_USED_FK3;

-- 부모테이블인 USER_GRADE3에서 GRADE_CODE = 10 삭제

DELETE FROM USER_GRADE3
WHERE GRADE_CODE = 10;

SELECT * FROM USER_GRADE3; -- 10 삭제됨
SELECT * FROM USER_USED_FK3; 
-- 부모의 10을 참조하고 있던 자식행 삭제됨을 확인

--------------------------------------------------------------------

-- 5. CHECK 제약조건 : 컬럼에 기록되는 값에 조건 설정을 할 수 있음
-- CHECK (컬럼명 비교연산자 비교값)
-- EX) GENDER -> CHECK(GENDER IN('남', '여'))
CREATE TABLE USER_USED_CHECK(
	USER_NO NUMBER PRIMARY KEY,
	USER_ID VARCHAR2(20) UNIQUE, 
	USER_PWD VARCHAR2(20) NOT NULL, 
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10) CONSTRAINT GENDER_CHECK CHECK(GENDER IN ('남', '여')),
	PHONE VARCHAR2(20),
	EMAIL VARCHAR2(50) 
	-- 테이블 레벨
	--, CONSTRAINT GENDER_CHECK CHECK(GENDER IN ('남', '여'))
);

INSERT INTO USER_USED_CHECK VALUES
(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-5678', 'hong@kr.or.kr');
-- ORA-02290: 체크 제약조건(KH_AJH.GENDER_CHECK)이 위배되었습니다
-- CHECK로 '남'으로 했기 때문에, 위배
-- '남' 가능

INSERT INTO USER_USED_CHECK VALUES
(2, 'USER02', 'PASS02', '유관순', '여', '010-3333-1111', 'yoo@kr.or.kr');
-- ORA-02290: 체크 제약조건(KH_AJH.GENDER_CHECK)이 위배되었습니다
-- '여' 가능

--> GENDER 컬럼에 CHECK 제약조건으로 '남' 또는 '여'만 삽입 가능하도록 설정해둠.
--> 이 외의 값이 들어오면 체크 제약조건 위배되어 에러 발생!!

SELECT * FROM USER_USED_CHECK;











