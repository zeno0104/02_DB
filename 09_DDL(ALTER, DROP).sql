-- DDL(Data Definition Language) : 데이터 정의 언어
-- 객체를 만들고(CREATE), 바꾸고(ALTER), 삭제(DROP) 하는 데이터

/* ALTER(바꾸다, 수정하다, 변조하다)
 * 
 * -- 테이블에서 수정할 수 있는 것
 * 1) 제약 조건(추가/삭제) * 제약조건 자체를 수정하는 구문은 별도 존재하지 않음
 * 					  * 삭제 후 추가해야함.
 * 2) 컬럼(추가/수정/삭제)
 * 3) 이름변경 (테이블명, 컬럼명, 제약조건명)
 * 
 * 제약조건 5가지
 * PK, NOT NULL, UNIQUE, FORIGN KEY(부모자식 관계 테이블), CHECK
 */ 
-- 1) 제약조건(추가/삭제)

-- [작성법]
-- 1) 추가 : ALTER TABLE 테이블명
--		    ADD [CONSTRAINT 제약조건명] 제약조건(지정할컬럼명)
--		    [REFERENCES 테이블명[(컬럼명)]]; <-- FK인 경우 추가
-- 2) 삭제 : ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

-- DEPARTMENT 테이블 복사 (컬럼명, 데이터타입, NOT NULL 만 복사)
CREATE TABLE DEPT_COPY 
AS SELECT * FROM DEPARTMENT;

-- DEPT_COPY의 DEPT_TITLE 컬럼에 UNIQUE 추가
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_COPY_TITLE_U UNIQUE(DEPT_TITLE);

-- DEPT_COPY의 DEPT_TITLE 컬럼에 설정된 UNIQUE 삭제
ALTER TABLE DEPT_COPY
DROP CONSTRAINT DEPT_COPY_TITLE_U;

-- *** DEPT_COPY의 DEPT_TITLE 컬럼에 NOT NULL 제약조건 추가/삭제 ***

ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_COPY_TITLE_NN NOT NULL(DEPT_TITLE)
-- ORA-00904: : 부적합한 식별자
--> NOT NULL 제약조건은 새로운 조건을 추가하는 것이 아닌
-- 컬럼 자체에 NULL 허용/비허용을 제어하는 성질 변경의 형태로 인식됨.

-- MODIFY(수정하다) 구문을 사용해서 NULL 제어
ALTER TABLE DEPT_COPY 
MODIFY DEPT_TITLE NOT NULL; -- DEPT_TITLE 컬럼에 NULL 비허용

ALTER TABLE DEPT_COPY 
MODIFY DEPT_TITLE NULL; -- DEPT_TITLE 컬럼에 NULL 허용


-- 2025-10-24
-------------------------------------------------------------------
-- 2025-10-27

-- 2. 컬럼 (추가/수정/삭제)

-- 컬럼 추가
-- ALTER TABLE 테이블명 ADD(컬럼명 데이터타입 [DEFAULT '값']);

-- 컬럼 수정 
-- ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입; --> 데이터 타입 변경
-- ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT '값'ㅣ --> DEFAULT 값 변경

-- 컬럼 삭제
-- ALTER TABLE 테이블명 DROP (삭제할 컬럼명);
-- ALTER TABLE 테이블명 DROP COLUMN 삭제할컬럼명;

SELECT * FROM DEPT_COPY;

-- CNAME 컬럼 추가
ALTER TABLE DEPT_COPY ADD(CNAME VARCHAR(30));

SELECT * FROM DEPT_COPY;

-- LNAME 컬럼 추가 (기본값 '한국')
ALTER TABLE DEPT_COPY ADD(LNAME VARCHAR(30) DEFAULT '한국');

SELECT * FROM DEPT_COPY;
--> 컬럼이 생성되면서 DEFAULT 값이 자동 삽입되었음을 확인

-- D10 개발1팀 추가 
INSERT INTO DEPT_COPY 
VALUES('D10', '개발1팀', 'L1', DEFAULT, DEFAULT);
-- DEFAULT가 NULL이여도 NULL로 들어감

-- ORA-12899: "KH_AJH"."DEPT_COPY"."DEPT_ID" 열에 대한 값이 너무 큼(실제: 3, 최대값: 2)
-- CHAR -> 고정길이 문자열, 현재 2바이트임
-- D10은 3바이트
--> DEPT_ID의 데이터 타입이 CHAR(2) 이므로 영어 + 숫자 = 2글자까지 저장 가능
--> D10 는 영어 + 숫자 3글자!!!

--> VARCHAR2(3)으로 변경해보기 (남는 바이트 메모리 반환을 위해)
--> VARCHAR2는 메모리를 알아서 반환하기 때문에 CHAR 대신 VARCHAR2 사용

-- DEPT_ID 컬럼 데이터 타입 수정

ALTER TABLE DEPT_COPY MODIFY DEPT_ID VARCHAR2(3);

SELECT * FROM DEPT_COPY;
--> 컬럼의 데이터 타입 변경 후 위 INSERT 수행 -> 삽입 성공 확인

-- LNAME의 기본값을 'KOREA'로 수정
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT 'KOREA';
VALUES('D10', '개발1팀', 'L1', DEFAULT, DEFAULT);

SELECT * FROM DEPT_COPY;
--> 기본값을 변경했다고 해서 기존 데이터가 변하지는 않음!!! 
--> 새로 삽입될 행에서부터 변경된 기본값 적용

-- LNAME '한국' -> 'KOREA' 변경

UPDATE DEPT_COPY SET 
--LNAME = 'KOREA';
LNAME = DEFAULT
WHERE LNAME = '한국';

SELECT * FROM DEPT_COPY;

COMMIT;

-- DEPT_COPY 모든 컬럼 삭제
ALTER TABLE DEPT_COPY DROP(LNAME);
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID; -- 삭제 안됨!
-- ORA-12983: 테이블에 모든 열들을 삭제할 수 없습니다
-- 마지막 남은 열은 삭제할 수 없다 => 테이블이라고 부를 수 없음

SELECT * FROM DEPT_COPY;


-- 테이블 삭제
DROP TABLE DEPT_COPY;

SELECT * FROM DEPT_COPY;
-- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다

-- DEPARTMENT 테이블 복사해서 DEPT_COPY 생성
CREATE TABLE DEPT_COPY AS (SELECT * FROM DEPARTMENT);

SELECT * FROM DEPT_COPY;
--> 컬러명, 타입, NOT NULL 제약조건 여부만 복사

-- DEPT_COPY 테이블에 PK 추가 ✔✔
ALTER TABLE DEPT_COPY ADD CONSTRAINT D_COPY_PK PRIMARY KEY(DEPT_ID);

SELECT * FROM DEPT_COPY;

-- 3. 이름 변경(컬럼, 테이블, 제약조건명)
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

SELECT * FROM DEPT_COPY;

-- 2) 제약조건명 변경 (D_COPY_PK -> DEPT_COPY_PK)

ALTER TABLE DEPT_COPY RENAME CONSTRAINT D_COPY_PK TO DEPT_COPY_PK;

SELECT * FROM DEPT_COPY;

-- 3) 테이블명 변경 (DEPT_COPY -> DCOPY)
ALTER TABLE DEPT_COPY RENAME TO DCOPY;


SELECT * FROM DEPT_COPY; -- 조회 불가능(테이블명 변경함)
-- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다

SELECT * FROM DCOPY; -- 조회가능


-- 4. 테이블 삭제
-- DROP TABLE 테이블명 [CASCADE CONSTRAINTS]

-- 1) 관계가 형성되지 않은 테이블 삭제
-- 2) 관계가 형성된 테이블 삭제
CREATE TABLE TB1(
	TB1_PK NUMBER PRIMARY KEY,
	TB1_COL NUMBER
); -- 부모 테이블

CREATE TABLE TB2(
	TB2_PK NUMBER PRIMARY KEY,
	TB2_COL NUMBER REFERENCES TB1
); -- 자식 테이블

-- TB1에 샘플 데이터 삽입
INSERT INTO TB1 VALUES(1, 100);
INSERT INTO TB1 VALUES(2, 200);
INSERT INTO TB1 VALUES(3, 300);

-- TB2에 샘플 데이터 삽입
INSERT INTO TB2 VALUES(11, 1);
INSERT INTO TB2 VALUES(12, 2);
INSERT INTO TB2 VALUES(13, 3);

COMMIT;ALTER 

-- TB1과 TB2는 부모-자식 테이블 관계 형성

-- 부모인 TB1 테이블 삭제하려고 할 때

DROP TABLE TB1;
-- ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다
--> 해결 방법
-- 1) 자식, 부모테이블 순서로 삭제
-- 2) ALTER를 이용해서 FK 제약조건 삭제 후 TB1 삭제
-- 3) DROP TABLE 삭제옵션 CASCADE CONSTRAINTS
--> CASCADE CONSTRAINS : 삭제핳려는 테이블과 연결된 FK 제약조건을 모두 삭제

DROP TABLE TB1 CASCADE CONSTRAINTS;

SELECT * FROM TB1; -- 삭제확인됨
-- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다

SELECT * FROM TB2; -- TB2 테이블은 독립적인 혼자 남게됨(아무 관계 없음)

-----------------------------------------------------
-- DDL 주의 사항
-- 1) DDL은 COMMIT/ROLLBACK 의 대상이 아님.
--> DML(INSERT/UPDATE/DELETE)만 해당
--> TCL(COMMIT/ROLLBACK)
-- 2) DDL과 DML 구문 섞어서 수행하면 안된다!
--> DDL은 수행 시 존재하고 있는 트랜잭션을 모두 DB에 강제 COMMIT 시킴!
--> DDL이 종료된 후 DML 구문을 수행할 수 있돌고 하자! (권장)
-- DDL(CREATE, ALTER, DROP) : 객체 생성/수정/삭제
-- DML(INSERT/UPDATE/DELETE/SELECT) : 데이터(행) 추가/갱신/삭제

SELECT * FROM TB2;

COMMIT;

-- DML
INSERT INTO TB2 VALUES(14, 4);
INSERT INTO TB2 VALUES(15, 5);

SELECT * FROM TB2;

-- DDL (컬럼명 변경)
ALTER TABLE TB2 RENAME COLUMN TB2_COL TO TB2_COLUMN;

ROLLBACK;

SELECT * FROM TB2; 
-- 14, 15번이 없어야 하는데, COMMIT이 된것! 
-- 롤백 안된다.
-- 위에서 DDL 구문 중 ALTER를 사용하여 그 시점에 COMMIT됨












