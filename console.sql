select ROW_ID, SUBJECT_ID, count(distinct (GENDER)), count(*)
from PATIENTS
group by ROW_ID, SUBJECT_ID
order by count(distinct (GENDER)) DESC;

select count(distinct(SUBJECT_ID))
from PATIENTS;

select ROW_ID, CGID, count(*)
from CARE_GIVERS
group by ROW_ID, CGID
order by count(*) DESC;

select ITEMID, count(*)
from LABS
group by ITEMID
order by count(*) DESC;

SELECT COUNT(DISTINCT pts.SUBJECT_ID)
from PATIENTS pts;

SELECT LABS.SUBJECT_ID, CHARTTIME, VALUENUM, VALUEUOM, LABEL FROM LABS
                   INNER JOIN ICD_LABS ON LABS.ITEMID = ICD_LABS.ITEMID AND ICD_LABS.LOINC_CODE in ('33762-6','33762-6')
                   WHERE SUBJECT_ID = SUBJECT_ID


SELECT DISTINCT pts.SUBJECT_ID
FROM (SELECT DISTINCT SUBJECT_ID, HADM_ID
      FROM TRANSFERS T
      WHERE T.EVENTTYPE = 'admit'
        AND INTIME BETWEEN '2000-06-01' AND '2000-07-01') pts
 INNER JOIN
     (SELECT *
      FROM LABS
               INNER JOIN ICD_LABS ON LABS.ITEMID = ICD_LABS.ITEMID AND lower(ICD_LABS.label) like 'tropo%') tropo
     ON pts.SUBJECT_ID = tropo.SUBJECT_ID
         AND pts.HADM_ID = tropo.HADM_ID
INNER JOIN
    (SELECT * from DIAGNOSES
     WHERE (SUBSTR(DIAGNOSES.ICD9_CODE, 1, 3) in
    ('390', '391', '392', --acute rheumatic
     '393', '394', '395', '396', '397', '398', --chrONic rheumatic
     '410', '411', '412', '413', '414', -- ischemic hd
     '415', '416', '417', -- pulmONary circulatiON
     '420', '421', '422', '423', '424', '425', '426', '427', '428', '429'))-- other hd
        ) dx
    ON pts.SUBJECT_ID = dx.SUBJECT_ID AND pts.HADM_ID = dx.HADM_ID;
;

select distinct label, DESCRIPTION, count(*) from CARE_GIVERS
GROUP BY label, DESCRIPTION;

select distinct CG.CGID, CG.DESCRIPTION, adm.HADM_ID
FROM
(select DISTINCT HADM_ID from TRANSFERS t
where t.CURR_CAREUNIT = 'NICU' and t.INTIME >= '2000-06-01 07:00:00'
                                and t."INTIME" < '2000-06-01 19:00:00') adm
inner join TREATMENT_TEAM tt on tt.HADM_ID = adm.HADM_ID
                                    and tt.STARTTIME >= '2000-06-01 07:00:00'
                                    and tt.STARTTIME < '2000-06-01 19:00:00'
inner join CARE_GIVERS CG on tt.CGID = CG.CGID and lower(CG.LABEL) like 'rn%'
;

SELECT * from ICD_DIAGNOSES
where SUBSTR(ICD9_CODE, 1, 3) in
    ('390', '391', '392', --acute rheumatic
     '393', '394', '395', '396', '397', '398', --chronic rheumatic
     '410', '411', '412', '413', '414', -- ischemic hd
     '415', '416', '417', -- pulmonary circulation
     '420', '421', '422', '423', '424', '425', '426', '427', '428', '429') -- other hd


SELECT PREV_CAREUNIT, count(distinct(SUBJECT_ID)) as DISCHARGE_COUNT
    FROM TRANSFERS t
where t.EVENTTYPE = 'discharge'
GROUP BY PREV_CAREUNIT
