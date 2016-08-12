


DROP VIEW APPS.XX_EBS_USER_HIERARCHY;

/* Formatted on 6/20/2016 12:22:48 PM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW APPS.XX_EBS_USER_HIERARCHY
(
   PARENT_PERSON_ID,
   USER_NAME,
   CHILD_PERSON_ID
)
AS
   SELECT DISTINCT
          NVL (EOC.PARENT_PERSON_ID, -1) PARENT_PERSON_ID -- distinct because i have no primary key in this view. distinct will allow me to treat these 3 columns as one key
                                                         ,
          NVL (FU.USER_NAME, 'NAN') USER_NAME,
          EOC.CHILD_PERSON_ID
     FROM XX_EMPLOYEE_ORG_CHART_V EOC, FND_USER FU
    WHERE EOC.PARENT_PERSON_ID = FU.EMPLOYEE_ID(+);
