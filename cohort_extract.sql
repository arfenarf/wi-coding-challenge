SELECT DISTINCT june_admits.SUBJECT_ID,
                june_admits.DOB,
                june_admits.GENDER -- 381 rows
        FROM (SELECT DISTINCT T.SUBJECT_ID,
                              HADM_ID,
                              INTIME,
                              pts.GENDER,
                              pts.DOB
              FROM TRANSFERS T
                INNER JOIN (
                              SELECT SUBJECT_ID, GENDER, min(DOB) as DOB
                              FROM PATIENTS
                              WHERE EXPIRE_FLAG = 0
                              group by SUBJECT_ID, GENDER
                          ) pts
                                   on T.SUBJECT_ID = pts.SUBJECT_ID
                          WHERE T.EVENTTYPE = 'admit'
                            AND INTIME BETWEEN '2000-06-01' AND '2000-07-01'
                            AND (julianday(T.INTIME) - julianday(pts.DOB)) / 365 >= 18) june_admits -- 2402 pts
        INNER JOIN
             (SELECT distinct SUBJECT_ID, HADM_ID
                  FROM LABS
                           INNER JOIN ICD_LABS ON LABS.ITEMID = ICD_LABS.ITEMID
                      AND ICD_LABS.LOINC_CODE in ('6598-7', '10839-9')
                      and LABS.VALUENUM is not NULL) tropo -- 1784 pts (of any age, any admit)
                 ON june_admits.SUBJECT_ID = tropo.SUBJECT_ID
                     AND june_admits.HADM_ID = tropo.HADM_ID
        INNER JOIN
             (SELECT distinct SUBJECT_ID, HADM_ID
              from DIAGNOSES
              WHERE (SUBSTR(DIAGNOSES.ICD9_CODE, 1, 3) like '42%')) dx -- 20,000 pts (of any age, any admit)
               ON june_admits.SUBJECT_ID = dx.SUBJECT_ID
               AND june_admits.HADM_ID = dx.HADM_ID;