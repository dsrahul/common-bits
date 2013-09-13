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
