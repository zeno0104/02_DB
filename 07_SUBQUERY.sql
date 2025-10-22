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




