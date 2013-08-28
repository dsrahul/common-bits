-- Hirrerarchy sql from prodcodes
WITH RPL (LEVEL, ASG_ID, PARENT_ASG_ID, NAME) 
     AS (SELECT 1, 
                ASG_ID, PARENT_ASG_ID,
                NAME 
         FROM   TAXLAGL 
         WHERE  ASG_ID = (SELECT PROD_TYPE_ASG_ID FROM VAXL_CDS_PROD WHERE PROD_CODE = '81060401')
         UNION ALL 
         SELECT O.LEVEL + 1, 
                NEXT_LAYER.ASG_ID, NEXT_LAYER.PARENT_ASG_ID,
                NEXT_LAYER.NAME 
         FROM   TAXLAGL AS NEXT_LAYER, 
                RPL O 
         WHERE  O.PARENT_ASG_ID = NEXT_LAYER.ASG_ID) 
SELECT LEVEL, 
       ASG_ID,PARENT_ASG_ID , NAME
FROM   RPL WITH UR
