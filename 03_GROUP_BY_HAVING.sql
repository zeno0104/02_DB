/* SELECT문 해석 순서
 *
 * 5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
 * 1 : FROM 테이블명
 * 2 : WHERE 컬럼명 | 함수식 비교연산자 비교값
 * 3 : GROUP BY 그룹을 묶을 컬럼명
 * 4 : HAVING 그룹함수식 비교연산자 비교값
 * 6 : ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식(ASC/DESC) [NULLS FIRST | LAST];
 * 
 * */

--------------------------------------------------------------------------------

-- * GROUP BY절 : 같은 값들이 여러개 기록된 컬럼을 가지고 
--				같은 값들을 하나의 그룹으로 묶음


-- GROUP BY 컬럼명 | 함수식, ..

-- 여러개의 값을 묶어서 하나로 처리할 목적으로 사용함
-- 그룹으로 묶은 값에 대해서 SELECT절에서 그룹함수를 사용함

-- 그룹함수는 단 한개의 결과값만 산출하기 때문에 그룹이 여러개일 경우 오류 발생
-- 여러 개의 결과값을 산출하기 위해 그룹함수가 적용된 그룹의 기준을 ORDER BY절에 기술하여 사용

-- EMPLOYEE 테이블에서 부서코드, 부서별 급여 합 조회

-- 1) 부서코드만 조회
SELECT DEPT_CODE FROM EMPLOYEE; -- 23행

-- 2) 급여 합 조회
SELECT SUM(SALARY) FROM EMPLOYEE; -- 1행

SELECT DEPT_CODE, SUM(SALARY) FROM EMPLOYEE;
-- SQL Error [937] [42000]: ORA-00937: 단일 그룹의 그룹 함수가 아닙니다

-- 이렇게 해결
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
-- DEPT_CODE 컬럼을 그룹으로 묶어, 그 그룹의 급여 합계(SUM(SALARY))를 구함

-- EMPLOYEE 테이블에서 (FROM 절)
-- 직급코드가 같은 사람의 (GROUP BY : 직급을 그룹으로 묶기 -> JOB_CODE)
-- 직급코드, 급여 평균, 인원수를
-- 직급코드 오름차순으로 조회해라

SELECT JOB_CODE, ROUND(AVG(SALARY)), COUNT(*)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- EMPLOYEE 테이블에서
-- 성별(남/여)과 각 성별 별 인원수, 급여 합을
-- 인원 수 오름차순으로 조회

SELECT * FROM EMPLOYEE;

SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별,  COUNT(*) "인원 수", SUM(SALARY) 급여
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') -- 별칭 사용 X (SELECT 해석 X)
ORDER BY "인원 수"; -- 별칭 사용 O (SELECT 절 해석 완료된 후이기 때문)
-- GROUP BY에 SELECT 별칭을 쓸 수 없다

---------------------------------------------------------------------------
-- * WHERE 절 GROUP BY 절 혼합하여 사용하기 *
-- ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐
--> WHERE 절은 각 컬럼값에 대한 조건
--> HAVING 절은 그룹에 대한 조건

-- EMPLOYEE 테이블에서 (FROM절)
-- 부서코드가 D5, D6인 부서의 (WHERE절 -> GROUP BY절)
-- 부서코드, 평균급여, 인원 수 조회 (SELECT 절)

SELECT DEPT_CODE, ROUND(AVG(SALARY)) AS "평균급여", COUNT(*) "인원 수"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6')
GROUP BY DEPT_CODE

-- EMPLOYEE 테이블에서
-- 2000년도 이후 입사자들의
-- 직급별 급여합을 조회
-- 직급코드, 급여합 



SELECT * FROM EMPLOYEE;
SELECT JOB_CODE, SUM(SALARY) AS "급여합"
FROM EMPLOYEE
WHERE SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY'), 1, 4) >= '2000'
-- HIRE_DATE >= TO_DATE('2000-01-01')
-- EXTRACT(YEAR FROM HIRE_DATE) >= 2000
-- SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY'), 1, 4) >= '2000'
GROUP BY JOB_CODE

---------------------------------------------------------------------------
-- * 여러 컬럼을 묶어서 그룹으로 지정 가능 --> 그룹 내 그룹이 가능하다! *
-- 부서별로 같은 직급인 사원의 인원수를 조회
-- 부서코드 오름차순, 직급코드 내림차순으로 정렬
-- 부서코드, 직급코드, 인원수

SELECT DEPT_CODE, JOB_CODE, COUNT(*) 인원수
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE -- DEPT_CODE로 그룹화,
							 -- 나눠진 그룹 내에서 JOB_CODE로 그룹화
ORDER BY DEPT_CODE, JOB_CODE DESC;
-- GROUP BY 사용 시 주의사항
-- SELECT 문에 GROUP BY절을 사용할 경우
-- SELECT절에 명시한 조회하려는 컬럼 중
-- 그룹함수가 적용되지 않은 컬럼을
-- 모두 GROUP BY절에 작성해야함.

---------------------------------------------------------------------------
/* SELECT문 해석 순서
 *
 * 5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
 * 1 : FROM 테이블명
 * 2 : WHERE 컬럼명 | 함수식 비교연산자 비교값
 * 3 : GROUP BY 그룹을 묶을 컬럼명
 * 4 : HAVING 그룹함수식 비교연산자 비교값
 * 6 : ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식(ASC/DESC) [NULLS FIRST | LAST];
 * */

-- HAVING 절: 그룹함수로 구해 올 그룹에 대한 조건을 설정할 때 사용

-- EMPLOYEE 테이블에서
-- 부서별 평균 급여가 3백만원 이상인 부서의
-- 부서코드, 평균급여 조회
-- 부서코드 오름차순 정렬

SELECT DEPT_CODE, ROUND(AVG(SALARY)) 평균급여
FROM EMPLOYEE
--WHERE SALARY >= 3000000 -- 한 사람의 급여가 3백만원 이상이라는 조건(요구사항 X)
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000 -- DEPT_CODE 그룹 중 급여 평균이 3백만원 이상인 그룹만 조회(요구사항 O)
ORDER BY DEPT_CODE;

-- EMPLOYEE 테이블에서
-- 직급별 인원수가 5명 이하인 직급의
-- 직급코드, 인원수 조회
-- 단, 직급코드 오름차순 정렬

SELECT JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING COUNT(*) <= 5
ORDER BY JOB_CODE;
---------------------------------------------------------------------------
-- 집계 함수(ROLLUP, CUBE)
-- 그룹 별 산출 결과값의 집계를 계산하는 함수
-- (그룹별로 중간 집계 결과를 추가)
-- GROUP BY 절에서만 사용할 수 있는 함수

-- ROLLUP : GROUP BY절에서 가장 먼저 작성된 컬럼의 중간집계를 처리하는 함수
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-- CUBE : GROUP BY절에 작성된 모든 컬럼의 중간집계를 처리하는 함수
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        

---------------------------------------------------------------------------

/* SET OPERATOR (집합 연산자) 

-- 여러 SELECT의 결과(RESULT SET)를 하나의 결과로 만드는 연산자

- UNION (합집합) : 두 SELECT 결과를 하나로 합침
				  단, 중복은 한 번만 작성

- INTERSECT (교집합) : 두 SELECT 결과 중 중복되는 부분만 조회

- UNION ALL : UNION + INTERSECT 
			합집합에서 중복 부분 제거 X
							
- MINUS (차집합) : A에서 A,B 교집합 부분을 제거하고 조회

*/

-- EMPLOYEE 테이블에서
-- 부서코드가 'D5'인 사원의 사번, 이름, 부서코드, 급여 조회
-- UNION
SELECT * FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE ='D5'
-- UNION
-- INTERSECT 
-- UNION ALL
-- MINUS
-- 급여가 300만 초과인 사원의 사번, 이름, 부서코드, 급여조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 주의사항!
-- 집합연산자를 사용하기 위한 SELECT문들은
-- 조회하는 컬럼의 타입, 개수 모두 동일해야한다!!

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE ='D5'
UNION
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, EMAIL
FROM EMPLOYEE
WHERE SALARY > 3000000;
-- SQL Error [928] [42000]: ORA-00928: 누락된 SELECT 키워드
-- 컬럼의 개수가 동일하지 않기 때문에 발생하는 에러

-- 서로 다른 테이블이지만
-- 컬럼의 타입, 개수만 일치하면
-- 집합연산자 사용 가능!
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE
UNION
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;

---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------










