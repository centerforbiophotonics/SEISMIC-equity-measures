WITH selc_instructors AS (SELECT c.subj, c.crse, COUNT (DISTINCT ci.pidm) AS n_instructors
    FROM course_instructors ci
    LEFT JOIN courses c ON c.term=ci.term AND c.crn=ci.crn
WHERE c.TERM >= 201810
    AND c.TERM < 202310
    AND REG_STATUS_CODE IN ('RE', 'W3', 'W4', 'W5', 'W6', 'W7', 'W8', 'W9', 'WA', 
                            'D3', 'D4', 'D5', 'D6', 'D7', 'D8', 'D9', 'DA', 
                            'P3', 'P4', 'P5', 'P6', 'P7', 'P8', 'P9', 'PA', 
                            'N3', 'N4', 'N5', 'N6', 'N7', 'N8', 'N9', 'NA', '3P', 'DP')
--update the below part of the file using list generated from rmarkdown
AND ((c.SUBJ||c.CRSE = 'BIT171')
OR (c.SUBJ||c.CRSE = 'CHE002C')
OR (c.SUBJ||c.CRSE = 'NUT010')
OR (c.SUBJ||c.CRSE = 'NUT010V')
OR (c.SUBJ||c.CRSE = 'MAT016A')
OR (c.SUBJ||c.CRSE = 'MAT021A')
OR (c.SUBJ||c.CRSE = 'LIN001')
)
GROUP BY c.subj, c.crse)
SELECT ID.RAND_ID AS "st_id",     
    CASE WHEN s.GENDER='F' THEN 1
        WHEN s.GENDER='M' THEN 0
        ELSE NULL
        END "female",
    CASE WHEN ETH_WHI = 1 AND ETH_ASI = 0 AND ETH_AFR = 0 AND ETH_LAT = 0 AND ETH_NAT = 0 AND ETH_PAC = 0 THEN 0
        WHEN ETH_AFR = 1 THEN 1
        WHEN ETH_LAT = 1 THEN 1
        WHEN ETH_NAT = 1 THEN 1
        WHEN ETH_PAC = 1 THEN 1
        WHEN ETH_WHI = 1 AND ETH_ASI = 1 THEN 2
        WHEN ETH_ASI = 1 THEN 2
        WHEN ETH_ASI = 0 AND ETH_AFR = 0 AND ETH_WHI = 0 AND ETH_LAT = 0 AND ETH_NAT = 0 AND ETH_PAC = 0 AND ETHN_CODE = 'WH' THEN 0
        WHEN ETH_ASI = 0 AND ETH_AFR = 0 AND ETH_WHI = 0 AND ETH_LAT = 0 AND ETH_NAT = 0 AND ETH_PAC = 0 AND ETHN_CODE = 'VT' THEN 2
        ELSE NULL
        END "ethniccode_cat",
    s.FIRST_GENERATION AS "firstgen",
    s.LOW_INCOME AS "lowincomeflag",
    CASE WHEN a.APP_LEVEL = 'H' THEN 0
        WHEN a.APP_LEVEL = 'A' THEN 1
        END "transfer",
    s.STARTED_INTERNATIONAL AS "international",
    ETH_WHI AS "white", ETH_ASI AS "asian", ETH_AFR AS "black_afram", ETH_LAT AS "hispanic_latinx", ETH_NAT AS "indigenous_am_indian", ETH_PAC AS "pacific_islander",
    t.major_1_desc AS "major", t.major_1_is_stem AS "stem_major",
    CASE WHEN c.TIME_TAKEN > 1 THEN 1
        WHEN c.TIME_TAKEN <= 1 THEN 0 
        ELSE NULL
        END "crs_retake",
    c.SUBJ||c.CRSE AS "crs_name", c.TERM as "crs_term", SUBSTR(c.TERM, 1, 4) AS "crs_year",
    CASE WHEN TO_CHAR(SUBSTR(c.TERM, 5, 2))=01 THEN 1 
        WHEN TO_CHAR(SUBSTR(c.TERM, 5, 2))=03 THEN 2
        WHEN TO_CHAR(SUBSTR(c.TERM, 5, 2))=05 THEN 3
        WHEN TO_CHAR(SUBSTR(c.TERM, 5, 2))=07 THEN 4
        WHEN TO_CHAR(SUBSTR(c.TERM, 5, 2))=10 THEN 5
        END "crs_semq", 
    c.SECTN as "crs_section",
    si.n_instructors as "crs_instructors",
    CASE WHEN c.reg_status_code IN ('W3', 'W4', 'W5', 'W6', 'W7', 'W8', 'W9', 'WA', 
                                    'D3', 'D4', 'D5', 'D6', 'D7', 'D8', 'D9', 'DA', 
                                    'P3', 'P4', 'P5', 'P6', 'P7', 'P8', 'P9', 'PA', 
                                    'N3', 'N4', 'N5', 'N6', 'N7', 'N8', 'N9', 'NA', '3P', 'DP')
                                THEN 'W'
        WHEN c.grade = 'D^' THEN 'D'
        WHEN c.grade = 'D-^' THEN 'D-'
        WHEN c.grade = 'D+^' THEN 'D+'
        WHEN c.grade = 'C-^' THEN 'C-'
        WHEN c.grade = 'C+^' THEN 'C+'
        ELSE c.grade
        END AS "lettergrade",
    CASE WHEN c.reg_status_code IN ('W3', 'W4', 'W5', 'W6', 'W7', 'W8', 'W9', 'WA', 
                                    'D3', 'D4', 'D5', 'D6', 'D7', 'D8', 'D9', 'DA', 
                                    'P3', 'P4', 'P5', 'P6', 'P7', 'P8', 'P9', 'PA', 
                                    'N3', 'N4', 'N5', 'N6', 'N7', 'N8', 'N9', 'NA', '3P', 'DP')
                                THEN NULL
        ELSE c.grade_pt
        END AS "numgrade",
    g.GPAO_CUMULATIVE AS "gpao"
FROM COURSES c
    LEFT JOIN IDENTIFIERS ID ON c.PIDM = ID.PIDM
    LEFT JOIN STUDENTS s ON s.PIDM = ID.PIDM
    LEFT JOIN ADMISSIONS_NEW a ON a.PIDM = s.PIDM AND a.TERM = s.ADMIT_TERM
    LEFT JOIN GPA_OTHERS g ON g.PIDM = s.PIDM AND c.SUBJ||c.CRSE = g.SUBJ||g.CRSE AND c.TERM = g.TERM AND c.CLASS_ID = g.CLASS_ID
    LEFT JOIN TERMS t ON s.PIDM = t.PIDM AND t.term=c.term
    LEFT JOIN SELC_INSTRUCTORS si ON si.SUBJ||si.CRSE=c.SUBJ||c.CRSE
WHERE c.TERM >= 201810
    AND c.TERM < 202310
    AND REG_STATUS_CODE IN ('RE', 'W3', 'W4', 'W5', 'W6', 'W7', 'W8', 'W9', 'WA', 
                            'D3', 'D4', 'D5', 'D6', 'D7', 'D8', 'D9', 'DA', 
                            'P3', 'P4', 'P5', 'P6', 'P7', 'P8', 'P9', 'PA', 
                            'N3', 'N4', 'N5', 'N6', 'N7', 'N8', 'N9', 'NA', '3P', 'DP')
--update the below part of the file using list generated from rmarkdown
AND ((c.SUBJ||c.CRSE = 'BIT171')
OR (c.SUBJ||c.CRSE = 'CHE002C')
OR (c.SUBJ||c.CRSE = 'NUT010')
OR (c.SUBJ||c.CRSE = 'NUT010V')
OR (c.SUBJ||c.CRSE = 'MAT016A')
OR (c.SUBJ||c.CRSE = 'MAT021A')
OR (c.SUBJ||c.CRSE = 'LIN001')
)
;


SELECT c.subj, c.crse, COUNT (DISTINCT ci.pidm) AS n_instructors
    FROM course_instructors ci
    LEFT JOIN courses c ON c.term=ci.term AND c.crn=ci.crn
WHERE c.TERM >= 201810
    AND c.TERM < 202310
    AND REG_STATUS_CODE IN ('RE', 'W3', 'W4', 'W5', 'W6', 'W7', 'W8', 'W9', 'WA', 
                            'D3', 'D4', 'D5', 'D6', 'D7', 'D8', 'D9', 'DA', 
                            'P3', 'P4', 'P5', 'P6', 'P7', 'P8', 'P9', 'PA', 
                            'N3', 'N4', 'N5', 'N6', 'N7', 'N8', 'N9', 'NA', '3P', 'DP')
--update the below part of the file using list generated from rmarkdown
AND ((c.SUBJ||c.CRSE = 'BIT171')
OR (c.SUBJ||c.CRSE = 'CHE002C')
OR (c.SUBJ||c.CRSE = 'NUT010')
OR (c.SUBJ||c.CRSE = 'NUT010V')
OR (c.SUBJ||c.CRSE = 'MAT016A')
OR (c.SUBJ||c.CRSE = 'MAT021A')
OR (c.SUBJ||c.CRSE = 'LIN001')
)
GROUP BY c.subj, c.crse
;