-- ** DML(Data Manipulation Language) : 데이터 조작 언어 ** 

-- 테이블에 값을 삽입하거나(INSERT), 수정하거나(UPDATE), 삭제하는(DELETE) 구문
-- 윈도우 > 설정 > 연결 > 연결유형 Auto commit by default 체크 해제 확인!

-- 주의 : 혼자서 COMMIT, ROLLBACK 하지 말 것!

-- 테스트용 테이블 생성
CREATE TABLE EMPLOYEE2 AS SELECT * FROM EMPLOYEE;
CREATE TABLE DEPARTMENT2 AS SELECT * FROM DEPARTMENT;

SELECT * FROM EMPLOYEE2;
SELECT * FROM DEPARTMENT2;

-----------------------------------------------------------

-- 1. INSERT

-- 테이블에 새로운 행에 추가하는 구문

-- 1) INSERT INTO 테이블명 VALUES(데이터, 데이터, 데이터, ...)
-- 테이블에 있는 모든 컬럼에 대한 값을 INSERT 할 때 사용.

SELECT * FROM EMPLOYEE2;

INSERT INTO EMPLOYEE2 
VALUES('900', '홍길동', '991215-1234567', 'hong_gd@or.kr', 
'01011111111', 'D1', 'J7', 'S3', 4300000, 0.2,
200, SYSDATE, NULL, 'N');
-- 0이 처음 들어오면 생략되기 떄문에 번호는 문자열로 저장

SELECT * FROM EMPLOYEE2
WHERE EMP_ID = '900';

ROLLBACK; -- 이전에 INSERT한 내용이 사라짐. 이전으로 돌아가게 됌.

-- 2) INSERT INTO 테이블명 (컬럼명1, 컬럼명2, 컬럼명3, ...) 
--    VALUES(데이터1, 데이터2, 데이터3, ...)
-- 테이블에 내가 선택한 컬럼에 대한 값만 INSERT 할 때 사용
-- 내가 선택한 컬럼에 대한 값만 INSERT 할 때 사용
-- 선택 안된 컬럼은 값이 NULL이 들어감
-- (DEFAULT 존재 시 DEFAULT 설정값으로 삽입됨)
-- 원본에 DEFAULT는 복사본으로 반영되지 않음

INSERT INTO EMPLOYEE2 (EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY) 
VALUES ('900', '홍길동', '991215-1234567', 'hong_gd@or.kr', '01011111111', 'D1', 'J7', 'S3', 4300000);

COMMIT; -- 홍길동 데이터 영구저장함

ROLLBACK; -- ROLLBACK 수행해봄

SELECT * FROM EMPLOYEE2
WHERE EMP_ID = '900'; -- 롤백을 해봤자 트랜잭션 바구니에 이미 없고, 영구저장 되었기 때문에 삭제 X
-- 조회 다시 해봄(영구저장 되었기 때문에 롤백한다 하더라도 되돌리기 안됨)

-- INSERT 시 VALUES 대신 서브쿼리 사용 가능

CREATE TABLE EMP_01(
	EMP_ID NUMBER,
	EMP_NAME VARCHAR2(30),
	DEPT_TITLE VARCHAR2(20)
);

SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE2
LEFT JOIN DEPARTMENT2
ON DEPT_CODE = DEPT_ID

-- 서브쿼리(SELECT) 결과(RESULT SET)를 EMP_01 테이블에 INSERT
--> SELECT 조회 결과의 데이터 타입, 컬럼개수가
-- INSERT 하려는 테이블의 컬럼과 일치해야함.

INSERT INTO EMP_01 (
	SELECT EMP_ID, EMP_NAME, DEPT_TITLE
	FROM EMPLOYEE2
	LEFT JOIN DEPARTMENT2 ON (DEPT_CODE = DEPT_ID)
);
-- INSERT에 서브쿼리를 넣으려면 VALUES를 적으면 안됌

-----------------------------------------

-- 2. UPDATE (내용을 바꾸거나 추가해서 최신화)
-- 테이블에 기록된 컬럼값을 수정하는 구문

-- [작성법]
/*
 * UPDATE 테이블명
 * SET 컬럼명 = 바꿀값
 * [WHERE 컬럼명 비교연산자 비교값];
 * --> WHERE 절은 옵션이지만 WHERE 절 조건 중요함!!!
 * 
 * */

-- DEPARTMENT2 테이블에서 DEPT_ID가 'D9'인 부서 정보 조회

SELECT * FROM DEPARTMENT2 WHERE DEPT_ID = 'D9';

-- DEPARTMENT2 테이블에서 DEPT_ID가 'D9'인 부서의
-- DEPT_TITLE을 '전략기획팀'으로 수정

UPDATE DEPARTMENT2
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

-- * 조건절을 설정하지 않고 UPDATE 구문 실행
-- 모든 행의 컬럼값이 수정됨
SELECT * FROM DEPARTMENT2;

UPDATE DEPARTMENT2
SET DEPT_TITLE = '기술연구팀';

SELECT * FROM DEPARTMENT2;

-- EMPLOYEE2 테이블에서 BONUS를 받지 않는 사원의 BONUS를 0.1로 수정

UPDATE EMPLOYEE2
SET BONUS = 0.1
WHERE BONUS IS NULL;

SELECT * FROM EMPLOYEE2;

ROLLBACK;
-----------------------------------------

-- 여러 컬럼을 한번에 수정할 시 콤마로 컬럼을 구분하면 됨
-- D9 / 총무부 --> D0 / 전략기획팀 수정

UPDATE DEPARTMENT2
SET DEPT_ID = 'D0', DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9' AND DEPT_TITLE = '총무부';

SELECT * FROM DEPARTMENT2;

-----------------------------------------

-- * UPDATE 시에도 서브쿼리 사용 가능

-- 작성법
-- UPDATE 테이블명 SET
-- 컬럼명 = (서브쿼리)

-- EMPLOYEE2 테이블에서
-- 방명수 사원의 급여와 보너스율을
-- 유재식 사원과 동일하게 변경해주기로 했다
-- 이를 반영하는 UPDATE문

-- 유재식 보너스 조회
SELECT SALARY, BONUS
FROM EMPLOYEE
WHERE EMP_NAME = '유재식'

UPDATE EMPLOYEE2
SET SALARY = (SELECT SALARY
			  FROM EMPLOYEE
              WHERE EMP_NAME = '유재식'), 
    BONUS = (SELECT BONUS
			  FROM EMPLOYEE
              WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE2
WHERE EMP_NAME IN ('유재식', '방명수');

-------------------------------------------------

-- 3. MERGE(병합) - 참고만 하기

-- 구조가 같은 두 개의 테이블을 하나로 합치는 기능
-- 테이블에서 지정하는 조건의 값이 존재하면 UPDATE
-- 없으면 INSERT

CREATE TABLE EMP_M01 AS SELECT * FROM EMPLOYEE;

CREATE TABLE EMP_M02 AS SELECT * FROM EMPLOYEE 
WHERE JOB_CODE = 'J4';

INSERT INTO EMP_M02
VALUES(999, '곽두원', '561016-1234567', 'kwack_dw@or.kr',
'01011112222', 'D9', 'J4', 'S1', 9000000, 0.5, NULL, SYSDATE, NULL, NULL);


SELECT * FROM EMP_M01; -- 23명
SELECT * FROM EMP_M02; -- 5명(기존4 + 신규1)

UPDATE EMP_M02
SET SALARY = 0;

MERGE INTO EMP_M01 USING EMP_M02 ON(EMP_M01.EMP_ID = EMP_M02.EMP_ID)
WHEN MATCHED THEN
UPDATE SET
	EMP_M01.EMP_NAME = EMP_M02.EMP_NAME,
	EMP_M01.EMP_NO = EMP_M02.EMP_NO,
	EMP_M01.EMAIL = EMP_M02.EMAIL,
	EMP_M01.PHONE = EMP_M02.PHONE,
	EMP_M01.DEPT_CODE = EMP_M02.DEPT_CODE,
	EMP_M01.JOB_CODE = EMP_M02.JOB_CODE,
	EMP_M01.SAL_LEVEL = EMP_M02.SAL_LEVEL,
	EMP_M01.SALARY = EMP_M02.SALARY,
	EMP_M01.BONUS = EMP_M02.BONUS,
	EMP_M01.MANAGER_ID = EMP_M02.MANAGER_ID,
	EMP_M01.HIRE_DATE = EMP_M02.HIRE_DATE,
	EMP_M01.ENT_DATE = EMP_M02.ENT_DATE,
	EMP_M01.ENT_YN = EMP_M02.ENT_YN
WHEN NOT MATCHED THEN
INSERT VALUES(EMP_M02.EMP_ID, EMP_M02.EMP_NAME, EMP_M02.EMP_NO, EMP_M02.EMAIL, 
	         EMP_M02.PHONE, EMP_M02.DEPT_CODE, EMP_M02.JOB_CODE, EMP_M02.SAL_LEVEL, 	  	         EMP_M02.SALARY, EMP_M02.BONUS, EMP_M02.MANAGER_ID, EMP_M02.HIRE_DATE, 
	         EMP_M02.ENT_DATE, EMP_M02.ENT_YN);

SELECT * FROM EMP_M02; 

-- M01로 테이블이 합쳐짐 -> M02에 있던 곽두원이 추가됌

-- 송은희, 임시환, 이중석, 유하진은 M02에서 SALARY가 0이였기 때문에 M01에 덮어쓰게 되는 것

-------------------------------------------------------------------

-- 4. DELETE
-- 테이블의 행을 삭제하는 구문

-- 작성법
-- DELETE FROM 테이블명 [WHERE 조건설정];
-- 만약에 WHERE 조건을 설정하지 않으면 모든 행이 다 삭제됨!!!

COMMIT;

SELECT * FROM EMPLOYEE2
WHERE EMP_NAME = '홍길동';

ROLLBACK; -- 마지막 커밋시점까지 되돌아감

-- 홍길동 삭제해보기
DELETE FROM EMPLOYEE2 
WHERE EMP_NAME = '홍길동';
--> 조회 결과 있음

-- EMPLOYEE2 테이블 행 전체 삭제
DELETE FROM EMPLOYEE2;

ROLLBACK;

-------------------------------------------------

-- ✔️

-- 5. TRUNCATE(DML 아님, DDL 입니다)
-- 테이블의 전체 행을 삭제하는 DDL
-- DELETE 보다 수행속도 더 빠름
-- DML은 트랜잭션에 담기지만, DDL은 트랜잭션 바구니에 안담김
-- 즉, ROLLBACK을 통해 복구할 수 없다.

-- 테스트용 테이블 생성
CREATE TABLE EMPLOYEE3
AS SELECT * FROM EMPLOYEE2;

SELECT * FROM EMPLOYEE3;

-- TRUNCATE 로 삭제
TRUNCATE TABLE EMPLOYEE3; -- 테이블 안에 행을 삭제

-- 삭제 확인
SELECT * FROM EMPLOYEE3; -- 행이 전부 삭제됨을 확인

ROLLBACK;

-- 롤백 후 복구 확인 (복구 안됨을 확인!)
SELECT * FROM EMPLOYEE3;

-- DELETE : 휴지통 버리기(복구 가능)
-- TRUNCATE : 완전 삭제(복구 불가능)






