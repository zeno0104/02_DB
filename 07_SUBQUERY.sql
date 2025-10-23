/*
 * SUBQUERY(서브쿼리 == 내부쿼리)
 * - 하나의 SQL문 안에 포함된 또다른 SQL문
 * - 메인쿼리(== 외부쿼리, 기존쿼리)를 위해 보조 역할을 하는 쿼리문
 * 
 * - 메인쿼리가 SELECT 문일 때
 * SELECT, FROM, WHERE, HAVING 절에서 사용 가능
 * */

-- 서브쿼리 예시 1.

-- 1번. 부서코드가 노옹철 사원과 같은 소속의 직원의 이름, 부서코드 조회

-- 1) 노옹철의 부서코드 조회 (서브쿼리)
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'; -- D9

-- 2) 부서코드가 D9인 직원의 이름, 부서코드 조회 (메인쿼리)
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9'

-- 3) 부서코드가 노옹철 사원과 같은 소속 직원 조회
--> 위의 2개 단계를 하나의 쿼리로!
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
				   FROM EMPLOYEE
				   WHERE EMP_NAME = '노옹철');
-- MY_SOLUTION



-- 서브쿼리 예시 2.

-- 2번. 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의
-- 사번, 이름, 직급코드, 급여 조회

-- 1) 전 직원의 평균 급여 조회하기 (서브쿼리)
SELECT CEIL(AVG(SALARY))
FROM EMPLOYEE; -- 3,047,663

-- 2) 직원 중 급여가 3,047,663원 이상인 사원들의
-- 사번, 이름, 직급코드, 급여 조회 (메인쿼리)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3047663;

-- 3) 위의 2단계를 하나의 쿼리로!
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (
	SELECT CEIL(AVG(SALARY))
	FROM EMPLOYEE
);

-- MY_SOL
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (
	SELECT CEIL(AVG(SALARY))
	FROM EMPLOYEE
);

------------------------------------------------------
/* 서브쿼리 유형
 * 
 * - 단일행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개일 때 -> 행, 열이 하나일 때
 * 
 * - 다중행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개일 때 -> 행이 여러개
 * 
 * - 다중열 서브쿼리 : 서브쿼리의 SELECT 절에 나열된 항목수가 여러개일 때 -> 열이 여러개
 * 
 * - 다중행 다중열 서브쿼리 : 조회 결과 행 수와 열 수가 여러개일 때
 * 
 * - 상(호연)관 서브쿼리 : 서브쿼리가 만든 결과 값을 메인쿼리가 비교 연산할 때
 * 						메인쿼리 테이블의 값이 변경되면 
 * 						서브쿼리의 결과값도 바뀌는 서브쿼리
 * 
 * - 스칼라 서브쿼리 : 상관 쿼리이면서 결과 값이 하나인 서브쿼리
 * 
 * ** 서브쿼리 유형에 따라 서브쿼리 앞에 붙는 연산자가 다름 ** 
 * 
 * */			
			
			
-- 1. 단일행 서브쿼리 (SINGLE ROW SUBQUERY)
--    서브쿼리의 조회 결과 값의 개수가 1개인 서브쿼리
--    단일행 서브쿼리 앞에는 비교 연산자 사용
--    < , >, <= , >= , = , != / <> / ^=			

-- 3번. 전 직원의 급여 평균보다 초과하여 급여를 받는 직원의
-- 이름, 직급명, 부서명, 급여를 직급 순으로 정렬하여 조회

-- 서브쿼리 ✔✔
SELECT CEIL(AVG(SALARY)) FROM EMPLOYEE;

SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (
	SELECT CEIL(AVG(SALARY)) 
	FROM EMPLOYEE
)
ORDER BY JOB_CODE;


-- MY_SOL
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE E
JOIN JOB J
ON E.JOB_CODE = J.JOB_CODE
LEFT JOIN DEPARTMENT D
ON E.DEPT_CODE = D.DEPT_ID 
WHERE SALARY > ( 
	SELECT CEIL(AVG(SALARY))
	FROM EMPLOYEE
)
ORDER BY J.JOB_CODE;
-- SELECT 절에 명시되지 않은 컬럼이라도
-- FROM, JOIN으로 인해 테이블상 존재하는 컬럼이면
-- ORDER BY 절 사용 가능!

-- 4번. 가장 적은 급여를 받는 직원의 
-- 사번, 이름, 직급명, 부서코드, 급여, 입사일 조회
SELECT * FROM EMPLOYEE;

-- 서브쿼리
SELECT MIN(SALARY) FROM EMPLOYEE; -- 1,380,000

SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);

-- MY_SOL
SELECT EMP_NO, EMP_NAME, JOB_NAME, DEPT_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE E
JOIN JOB J
ON E.JOB_CODE = J.JOB_CODE
WHERE SALARY = (
	SELECT MIN(SALARY)
	FROM EMPLOYEE
); 

-- 5번. 노옹철 사원의 급여보다 초과하여 받는 직원의
-- 사번, 이름, 부서명, 직급명, 급여 조회

SELECT SALARY FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

SELECT EMP_NO, EMP_NAME, DEPT_TITLE, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE SALARY > (
	SELECT SALARY FROM EMPLOYEE
	WHERE EMP_NAME = '노옹철'
);

-- MY_SOL
SELECT * FROM DEPARTMENT;
SELECT * FROM JOB;
SELECT EMP_NO, EMP_NAME, DEPT_TITLE, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN DEPARTMENT D
ON E.DEPT_CODE = D.DEPT_ID
JOIN JOB USING(JOB_CODE)
WHERE SALARY > (
	SELECT SALARY
	FROM EMPLOYEE
	WHERE EMP_NAME = '노옹철'
);

-- 6번. 부서별(부서가 없는 사람 포함) 급여의 합계 중 
-- 가장 큰 부서의 부서명, 급여 합계를 조회

-- 1) 부서별 급여 합 중 가장 큰 값 조회(서브)
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- 17,700,000

-- 2) 부서별 급여합이 17,000,000인 부서의 부서명과 급여합 조회(메인)
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = 17700000;

-- 3) 위의 두 쿼리를 합쳐 하나의 쿼리로! ✔✔
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = (
	SELECT MAX(SUM(SALARY))
	FROM EMPLOYEE
	GROUP BY DEPT_CODE
);

-------------------------------------------------------
-- 2. 다중행 서브쿼리 (MULTI ROW SUBQUERY)
--    서브쿼리의 조회 결과 값의 개수가 여러행일 때

/* 
 * >> 다중행 서브쿼리 앞에는 일반 비교연산자 사용 X ⭐
 * => < , >, <= , >= , = , != / <> / ^= 이런거 사용 안된다는 것⭐
 * 
 * - IN / NOT IN : 여러 개의 결과값 중에서 한 개라도 일치하는 값이 있다면
 * 								 혹은 없다면 이라는 의미 (가장 많이 사용!)
 * 
 * - > ANY, < ANY : 여러개의 결과값 중에서 한 개라도 큰 / 작은 경우
 * 									가장 작은 값 보다 큰가? / 가장 큰 값 보다 작은가?
 * 
 * - > ALL, < ALL : 여러개의 결과값의 모든 값 보다 큰 / 작은 경우
 * 									가장 큰 값 보다 큰가? / 가장 작은 값 보다 작은가?
 * 
 * - EXISTS / NOT EXISTS : 값이 존재하는가? / 존재하지 않는가?
 * 
 * 
 * */					

-- 7번. 부서별 최고 급여를 받는 직원의
-- 이름, 직급, 부서, 급여를
-- 부서 순으로 정렬하여 조회

-- 부서별 최고 급여 조회(서브쿼리) ✔✔


SELECT * FROM JOB;

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN  (
	SELECT MAX(SALARY)
	FROM EMPLOYEE
	GROUP BY DEPT_CODE
)
ORDER BY DEPT_CODE;

-- 8번. 사수에 해당하는 직원에 대해 조회
-- 사번, 이름, 부서명, 직급명, 구분(사수/사원)

-- * 사수 == MANAGER_ID 컬럼에 작성된 사번

-- 1) 사수에 해당하는 사원 번호 조회
SELECT DISTINCT MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;


-- 2) 직원의 사번, 이름, 부서명, 직급명 조회
SELECT EMP_NO, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID

-- 3) 사수에 해당하는 직원에 대한 정보 조회 (구분 '사수')

SELECT EMP_NO, EMP_NAME, DEPT_TITLE, JOB_NAME, '사수' 구분
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
WHERE EMP_ID IN (
	SELECT DISTINCT MANAGER_ID
	FROM EMPLOYEE
	WHERE MANAGER_ID IS NOT NULL
);

-- 4) 사원에 해당하는 직원에 대한 정보 조회 (구분 '사원')

SELECT EMP_NO, EMP_NAME, DEPT_TITLE, JOB_NAME, '사원' 구분
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
WHERE EMP_ID NOT IN (
	SELECT DISTINCT MANAGER_ID
	FROM EMPLOYEE
	WHERE MANAGER_ID IS NOT NULL
);

-- 5) 3, 4의 조회 결과를 하나로 조회

-- 1. 집합 연산자 사용방법 (UNION : 합집합)
SELECT EMP_NO, EMP_NAME, DEPT_TITLE, JOB_NAME, '사수' 구분
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
WHERE EMP_ID IN (
	SELECT DISTINCT MANAGER_ID
	FROM EMPLOYEE
	WHERE MANAGER_ID IS NOT NULL
)
UNION
SELECT EMP_NO, EMP_NAME, DEPT_TITLE, JOB_NAME, '사원' 구분
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
WHERE EMP_ID NOT IN (
	SELECT DISTINCT MANAGER_ID
	FROM EMPLOYEE
	WHERE MANAGER_ID IS NOT NULL
);

-- 2. 선택 함수 사용 ✔✔
--> DECODE(컬럼명, 값1, 1인경우, 값2, 2인경우..., 일치하지 않는 경우);
--> CASE WHEN 조건1 THEN 값1
-- 		 WHEN 조건2 THEN 값2
-- 		 ELSE 값3
--  END 별칭
SELECT EMP_NO, EMP_NAME, DEPT_TITLE, JOB_NAME,
	CASE WHEN EMP_ID IN (
		SELECT DISTINCT MANAGER_ID
		FROM EMPLOYEE
		WHERE MANAGER_ID IS NOT NULL)
		THEN '사수'
		ELSE '사원'
	END 구분
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID;

-- 9번. 대리 직급의 직원들 중에서
-- 과장 직급의 최소 급여보다
-- 많이 받는 직원의 사번, 이름, 직급명, 급여 조회 ✔✔

SELECT * FROM JOB;

-- 1) 직급이 과장인 직원들의 급여 조회(서브쿼리)
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE) 
WHERE JOB_NAME = '과장';

-- 2) 직급이 대리인 직원들의 사번, 이름, 직급, 급여 조회(메인쿼리)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리';

-- 3) 하나의 쿼리로!
-- 방법1) ANY 를 이용하기 (다중행 이용)

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > ANY (
	SELECT SALARY
	FROM EMPLOYEE
	JOIN JOB USING(JOB_CODE) 
	WHERE JOB_NAME = '과장'
);

-- 방법2) MIN을 이용해서 단일행 서브쿼리
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > (
	SELECT MIN(SALARY)
	FROM EMPLOYEE
	JOIN JOB USING(JOB_CODE) 
	WHERE JOB_NAME = '과장'
)

-- 10번. 차장 직급의 급여 중 가장 큰 값보다 많이 받는 과장 직급의 직원
-- 사번, 이름, 직급, 급여 조회

-- > ALL : 가장 큰 값 보다 크냐? 

-- 서브쿼리 (차장 직급의 급여 조회)
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장';

-- 메인쿼리 + 서브쿼리
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
AND SALARY > ALL (
	SELECT SALARY
	FROM EMPLOYEE
	JOIN JOB USING(JOB_CODE)
	WHERE JOB_NAME = '차장'
);


SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장' 
AND SALARY > ALL(
	SELECT SALARY
	FROM EMPLOYEE
	JOIN JOB USING(JOB_CODE)
	WHERE JOB_NAME = '차장'
)

-- 서브쿼리 중첩 사용 (응용!)
-- LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE와
-- DEPARTMENT 테이블의 LOCATION_ID와 동일한 DEPT_ID가
-- EMPLOYEE 테이블의 DEPT_CODE와 동일한 사원을 구하시오
-- 사원의 이름, 부서코드 조회

-- T_SOL
-- 1) LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE
SELECT LOCAL_CODE
FROM LOCATION
WHERE NATIONAL_CODE = 'KO'; --'L1'
--> 단일행 서브쿼리

-- 2) DEPARTMENT 테이블의 위의 결과(L1)와 동일한
-- LOCATION_ID와 가지고 있는 DEPT_ID 조회

SELECT DEPT_ID
FROM DEPARTMENT
WHERE LOCATION_ID = (
	SELECT LOCAL_CODE
	FROM LOCATION
	WHERE NATIONAL_CODE = 'KO'
);

-- 3) EMPLOYEE 테이블의 위의 결과와 동일한 DEPT_CODE를 가진
-- 사원의 이름, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IN (
	SELECT DEPT_ID
	FROM DEPARTMENT
	WHERE LOCATION_ID = (
		SELECT LOCAL_CODE
		FROM LOCATION
		WHERE NATIONAL_CODE = 'KO'
	)
)

-- 다중행일 땐 =는 안됌, IN OR NOT IN으로 비교!

-- MY_SOL
SELECT * FROM LOCATION;


SELECT LOCAL_CODE
FROM LOCATION
WHERE NATIONAL_CODE = 'KO';



SELECT * FROM DEPARTMENT;

SELECT DEPT_ID
FROM DEPARTMENT
WHERE LOCATION_ID IN (
	SELECT LOCAL_CODE
	FROM LOCATION
	WHERE NATIONAL_CODE = 'KO'
);
SELECT * FROM EMPLOYEE;

SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IN (
	SELECT DEPT_ID
	FROM DEPARTMENT
	WHERE LOCATION_ID IN (
		SELECT LOCAL_CODE
		FROM LOCATION
		WHERE NATIONAL_CODE = 'KO'
	)
)

-- 2025-10-22
--------------------------------------------------------------
-- 2025-10-23


-- 3. (단일행) 다중열 서브쿼리
-- 서브쿼리 SELECT 절에 나열된 컬럼수가 여러개 일 때
-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는
-- 사원의 이름, 직급코드, 부서코드, 입사일 조회

-- 1) 퇴사한 여직원 조회
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y'
AND SUBSTR(EMP_NO, 8, 1) = '2';

-- 2) 퇴사한 여직원과 같은 부서, 같은 직급 사원 조회

-- 방법 1) 단일행 서브쿼리 2개 사용해서 조회
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (
	SELECT DEPT_CODE
	FROM EMPLOYEE
	WHERE ENT_YN = 'Y'
	AND SUBSTR(EMP_NO, 8, 1) = '2'
) AND JOB_CODE = (
	SELECT JOB_CODE
	FROM EMPLOYEE
	WHERE ENT_YN = 'Y'
	AND SUBSTR(EMP_NO, 8, 1) = '2'
)

-- 방법 2) 다중열 서브쿼리 사용
--> WHERE 절에 작성된 컬럼 순서에 맞게
-- 서브쿼리의 조회된 컬럼과 비교하여 일치하는 행만 조회
-- 컬럼 순서 중요!!

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) IN (
	SELECT DEPT_CODE, JOB_CODE
	FROM EMPLOYEE
	WHERE ENT_YN = 'Y'
	AND SUBSTR(EMP_NO, 8, 1) = '2'
);

-------------------연습 문제-------------------
-- 1. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회 (단, 노옹철 제외)
-- 사번, 이름, 부서코드, 직급코드, 부서명, 직급명 조회

-- T_SOL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE (DEPT_CODE, JOB_CODE) = (
	SELECT DEPT_CODE, JOB_CODE
	FROM EMPLOYEE
	WHERE EMP_NAME = '노옹철'
)
AND EMP_NAME != '노옹철';

-- MY_SOL
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, E.JOB_CODE, D.DEPT_TITLE, J.JOB_NAME
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE (E.DEPT_CODE, E.JOB_CODE) IN (
	SELECT DEPT_CODE, JOB_CODE
	FROM EMPLOYEE
	WHERE EMP_NAME = '노옹철'
)
AND EMP_NAME != '노옹철';

-- 2. 2000년도에 입사한 사원의 부서와 직급이 같은 사원을 조회
-- 사번, 이름, 부서코드, 직급코드, 입사일 조회

-- T_SOL
SELECT DEPT_CODE, JOB_CODE 
FROM EMPLOYEE 
WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) IN (
	SELECT DEPT_CODE, JOB_CODE 
	FROM EMPLOYEE 
	WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2000
);

-- MY_SOL
SELECT * FROM EMPLOYEE;

SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY-MM-DD'), 1, 4) >= 2000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) IN (
	SELECT DEPT_CODE, JOB_CODE
	FROM EMPLOYEE
	WHERE SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY-MM-DD'), 1, 4) = '2000'
);

-- 3. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원 조회
-- 사번, 이름, 부서코드, 사수번호, 주민번호, 입사일 조회

-- T_SOL
SELECT DEPT_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NO LIKE '77%'
AND SUBSTR(EMP_NO, 8, 1) = '2';

SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) IN (
	SELECT DEPT_CODE, MANAGER_ID
	FROM EMPLOYEE
	WHERE EMP_NO LIKE '77%'
	AND SUBSTR(EMP_NO, 8, 1) = '2'
);

-- MY_SOL
SELECT DEPT_CODE
FROM EMPLOYEE 
WHERE SUBSTR(EMP_NO, 1, 2) = '77' AND SUBSTR(EMP_NO, 8, 1) = '2';


SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) IN (
	SELECT DEPT_CODE, MANAGER_ID
	FROM EMPLOYEE 
	WHERE SUBSTR(EMP_NO, 1, 2) = '77' AND SUBSTR(EMP_NO, 8, 1) = '2'
);

----------------------------------------------------------------------
-- 4. 다중행 다중열 서브쿼리
-- 서브쿼리 조회 결과 행 수와 열 수가 여러개 일 때

-- 본인이 소속된 직급의 평균 급여를 받고있는 직원의
-- 사번, 이름, 직급코드, 급여 조회
-- 단, 급여와 급여 평균은 만원 단위로 계산 TRUNC(컬럼명, 단위)

-- 1) 직급의 평균 급여 (서브쿼리)
SELECT JOB_CODE, TRUNC(AVG(SALARY), -4)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 2) 사번, 이름, 직급코드, 급여 조회 (메인 + 서브)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (
	SELECT JOB_CODE, TRUNC(AVG(SALARY), -4)
	FROM EMPLOYEE
	GROUP BY JOB_CODE
);


----------------------------------------------------------

-- 5. 상[호연]관 서브쿼리                        
-- 상관 쿼리는 메인쿼리가 사용하는 테이블값을 서브쿼리가 이용해서 결과를 만듦
-- 메인쿼리의 테이블값이 변경되면 서브쿼리의 결과값도 바뀌게 되는 구조


-- 상관쿼리는 먼저 메인쿼리 한 행을 조회하고
-- 해당 행이 서브쿼리의 조건을 충족하는지 확인하여 SELECT를 진행함


-- ** 해석순서가 기존 서브쿼리와 다르게
-- 메인쿼리 1행 -> 1행에 대한 서브쿼리 수행
-- 메인쿼리 2행 -> 2행에 대한 서브쿼리 수행
-- ...
-- 메인쿼리의 행의 수 만큼 서브쿼리가 생성되어 진행됨
--> 한행 한행을 비교하는 방법

-- 직급별 급여 평균보다 급여를 많이 받는 직원의
-- 이름, 직급코드, 급여 조회

-- 메인쿼리
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE;

-- 서브쿼리
SELECT AVG(SALARY)
FROM EMPLOYEE
WHERE JOB_CODE = 'J2';

-- 상관쿼리 
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE MAIN
WHERE SALARY > (
	SELECT AVG(SALARY)
	FROM EMPLOYEE SUB
	WHERE MAIN.JOB_CODE = SUB.JOB_CODE
); -- 기준이 되는 컬럼으로 한행 한행 비교를 진행
-- 서브쿼리를 메인쿼리에서 나오는 값을 기준으로 서브쿼리에서 만들어내서 
-- 해당하는 서브쿼리를 만들어서 메인쿼리와 비교를 진행
-- 메인쿼리가 바뀌면 서브쿼리가 바뀌는데, 상호연관성이 있기 때문에 상관쿼리라고 부른다.


-- 부서별 입사일이 가장 빠른 사원의
-- 사번, 이름, 부서코드, 부서명(NULL 이면 '소속없음'), 직급명, 입사일 조회
-- 입사일 빠른순으로 정렬
-- 단, 퇴사한 직원은 제외할 것

-- T_SOL
-- 메인쿼리 (사번, 이름, 부서코드, 부서명(NULL 이면 '소속없음'), 직급명, 입사일 조회)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID;

-- 서브쿼리 (부서별 입사일이 가장 빠른 사원)
SELECT MIN(HIRE_DATE)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
WHERE HIRE_DATE = (
	SELECT MIN(HIRE_DATE)
	FROM EMPLOYEE S
	WHERE E.DEPT_CODE = S.DEPT_CODE
);
-- MY_SOL

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
WHERE HIRE_DATE = (
	SELECT MIN(HIRE_DATE)
	FROM EMPLOYEE S
	WHERE ENT_YN = 'N' AND E.DEPT_CODE = S.DEPT_CODE
)
-- AND E.ENT_YN = 'N' 
-- 이렇게 되면 D8부서 이태림이 속한 부서가 다 날아감
ORDER BY HIRE_DATE;

---------------------------------------------------------

-- 6. 스칼라 서브쿼리
-- SELECT 절에 사용되는 서브쿼리로 결과를 1행만 반환함
-- SQL에서 단일 값을 '스칼라' 라고 함.
-- 즉, SELECT 절에 작성되는 단일행 단일열 서브쿼리를 스칼라 서브쿼리라고 함.

-- 모든 직원의 이름, 직급, 급여, 전체 사원 중 가장 높은 급여와의 차
SELECT EMP_NAME, JOB_CODE, SALARY, 
(SELECT MAX(SALARY) FROM EMPLOYEE) - SALARY "급여 차"
FROM EMPLOYEE;

-- 모든 사원의 이름, 직급코드, 급여,
-- 각 지원들이 속한 직급의 급여 평균을 조회
-- 스칼라 + 상관쿼리
SELECT EMP_NAME, JOB_CODE, SALARY, 
( SELECT CEIL(AVG(SALARY))
FROM EMPLOYEE SUB
WHERE MAIN.JOB_CODE = SUB.JOB_CODE
) "평균"
FROM EMPLOYEE MAIN
ORDER BY JOB_CODE;

----------------------------------------------------------------------
-- 7. 인라인 뷰 (INLINE-VIEW)
-- FROM 절에 서브쿼리를 사용하는 경우로
-- 서브쿼리가 만든 결과의 집합(RESULT SET)를 테이블 대신 사용

-- 서브쿼리
SELECT EMP_NAME 이름, DEPT_TITLE 부서
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID; 

-- 부서가 기술지원부인 모든 값 조회
SELECT * 
FROM (SELECT EMP_NAME 이름, DEPT_TITLE 부서
	  FROM EMPLOYEE
	  JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID)
WHERE 부서 = '기술지원부';
-- 컬럼명은 인라인 뷰로 사용된 별칭으로 지정해주면 된다.

-- 인라인뷰를 활용한 TOP-N 분석

-- 전 직원 중 급여가 높은 상위 5명의
-- 순위, 이름, 급여 조회

-- ROWNUM 컬럼 : 행 번호를 나타내는 가상 컬럼

/*3*/SELECT ROWNUM, EMP_NAME, SALARY
/*1*/FROM EMPLOYEE
/*2*/WHERE ROWNUM <= 5
/*4*/ORDER BY SALARY DESC;
--> SELECT 문의 해석 순서 때문에, 급여 사원이 5명이 아니라
-- 조회 순서 상위 5명끼리의 순위 정렬되어 조회


SELECT ROWNUM 순위, EMP_NAME 이름, SALARY 급여
FROM (
	SELECT EMP_NAME, SALARY
	FROM EMPLOYEE
	ORDER BY SALARY DESC 
)
WHERE ROWNUM <= 5
--ORDER BY SALARY DESC;

--> 인라인 뷰를 이용해서 해결 가능
-- 1) 이름, 급여를 급여 내림차순으로 조회한 결과를 인라인뷰 사용
--> FROM 절에 작성되기 때문에 해석 1순위

SELECT EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;

-- 2) 메인쿼리 조회 시 인라인뷰를 이용하여 급여 상위 5명까지 조회
SELECT ROWNUM, EMP_NAME, SALARY
FROM (
	SELECT EMP_NAME, SALARY
	FROM EMPLOYEE
	ORDER BY SALARY DESC -- 해석순위 1위이기 때문에 FROM절에서 전체 직원의 SALARY를 내림차순을 정렬해둠
)
WHERE ROWNUM <= 5; -- 해석순위 2위 WHERE절에서 이제 가상컬럼의 1~5행까지만 조회

-- 급여 평균이 3위 안에 드는 부서의
-- 부서코드, 부서명, 평균급여 조회

SELECT *
FROM (SELECT DEPT_CODE, DEPT_TITLE, CEIL(AVG(SALARY)) 평균급여
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_CODE, DEPT_TITLE
ORDER BY 평균급여 DESC)
WHERE ROWNUM <= 3;

-------------------------------------------------------------------

-- 8. WITH
-- 서브쿼리에 이름을 붙여주고 사용 시 이름을 사용하게 함
-- 인라인 뷰로 사용될 서브쿼리에 주로 사용됨
-- 실행속도가 빨라진다는 장점이 있음

-- 전직원의 급여 순위
-- 순위, 이름, 급여 조회 (10위까지만)

WITH TOP_SAL AS (SELECT EMP_NAME, SALARY 
FROM EMPLOYEE
ORDER BY SALARY DESC)
SELECT ROWNUM, EMP_NAME, SALARY
FROM TOP_SAL
WHERE ROWNUM <= 10;

-------------------------------------------------------------------------

-- 9. RANK() OVER / DENSE_RANK() OVER

-- RANK() OVER : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너 뛰고 순위를 계산하는 방식
-- EX) 공동 1위가 2명이면 다음 순위는 2위가 아니라 3위로 조회됨

-- 사원별 급여 순위
SELECT RANK() OVER(ORDER BY SALARY DESC) 순위, EMP_NAME, SALARY
FROM EMPLOYEE;

-- DENSE_RANK() OVER : 동일한 순위 이후의 등수를 이후 순위로 계산
-- EX) 공동 1위가 2명이어도 다음 순위는 2위
SELECT DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위, EMP_NAME, SALARY
FROM EMPLOYEE;	









