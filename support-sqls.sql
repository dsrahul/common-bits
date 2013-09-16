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


--AVAILABLE SERVICES
SELECT A.id, 
       A.des_serv_grp_id, 
       A.name, 
       A.description, 
       A.volume, 
       A.charge, 
       A.product_association, 
       A.time_to_deliver 
FROM   tdeserv A, 
       tdespts D, 
       tdespar E, 
       tdespro F, 
       tdesass G 
WHERE  A.id = D.del_ex_serv_id 
       AND D.prod_type_id IN ( 'zJ5a6h+w' ) 
       AND A.id = E.del_ex_serv_id 
       AND E.del_ex_serv_prov_id = F.provider_id 
       AND F.provider_type IN ( 'G' ) 
       AND E.pair_id = G.del_ex_serv_pair_id 
       AND G.branch_num IN ( 12 ) 
       AND G.start_date <= CURRENT_DATE 
       AND ( G.end_date >= CURRENT_DATE ) 
WITH UR 


-- Service charges
SELECT chg_id, 
       del_ex_serv_id, 
       branch_num, 
       charge 
FROM   tdeschg 
WHERE  del_ex_serv_id IN ( 'L3vF2P/y' ) 
       AND branch_num IN ( 12 ) 
ORDER  BY del_ex_serv_id asc, 
          branch_num asc 
WITH UR 

-- SERVICE GROUPS
SELECT GRP_ID, NAME, THIRD_PARTY_CODE, EXCATCHMENT_CODE, GREEN_VAN_CODE, PICKUP_FLAG FROM TDESGRP ORDER BY GRP_ID WITH UR

--- RESOURCE AND CAPABILITY

SELECT A.cap_id     AS capabilityId, 
       A.short_code AS shortCode, 
       B.rsrc_id    AS resourceId 
FROM   tcapbty A, 
       trscass B 
WHERE  B.rsrc_id IN (SELECT rsrc_id 
                     FROM   tresrce 
                     WHERE  del_centre IN ( 35 ) 
                     ) 
       AND A.cap_id = B.cap_id 
WITH UR 

--- DEL CENTRES with PARTICULAR RESOURCE
SELECT * 
FROM   tresrce 
WHERE  rsrc_id IN (SELECT DISTINCT B.rsrc_id AS resourceId 
                   FROM   tcapbty A, 
                          trscass B 
                   WHERE  A.short_code = 'COR') 
ORDER  BY 2 
WITH UR 

