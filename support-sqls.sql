/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000       A.[LocationKey],B.[OrderKey]
      ,A.[ShipZipcode], B.[PlannedArrivedDate],B.[PlannedDepartedDate],b.[PlannedTimeDriven],B.[RouteID], C.[ResourceKey]
      , B.[StopNumber]
	  ,A.[ModifiedBy]
      ,A.[ModifyDate]
      ,A.[CreatedBy]
      ,A.[CreatedDate]
      ,A.[Latitude]
      ,A.[Longitude]
      ,A.[GeocodeLatitude]
      ,A.[GeocodeLongitude]
      --,A.[GeocodeSource]
      --,A.[GeocodeType]
      --,A.[Type]
  FROM [LNOSFW_JL].[dbo].[FWLocation] A, [LNOSFW_JL].[dbo].[FWStop] B , [LNOSFW_JL].[dbo].[FWRoute] C where 
  --B.[OrderKey] like '34842623%' and 
  C.[ResourceKey] like 'R31PM20131204T4%' and 
  --A.geocodeflags = 'WRONGPOSTALCODE' and 
  B.locationkey = A.locationkey and 
  -- (a.LocationKey != a.GeocodeLatitude or a.Longitude != a.GeocodeLongitude) and 
  --LEN(shipzipcode) < 6
  B.[RouteID] = C.[RouteID] 
  order by B.[StopNumber] asc


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
FROM   ldba.tdeserv A, 
       ldba.tdespts D, 
       ldba.tdespar E, 
       ldba.tdespro F, 
       ldba.tdesass G 
WHERE  A.id = D.del_ex_serv_id 
       AND D.prod_type_id IN ( select PROD_TYPE_ASG_ID from ldba.VAXL_CDS_PROD where PROD_CODE = '88931214' ) 
       AND A.id = E.del_ex_serv_id 
       AND E.del_ex_serv_prov_id = F.provider_id 
       AND F.provider_type IN ( 'G' ) 
       AND E.pair_id = G.del_ex_serv_pair_id 
       AND G.branch_num IN ( 12 ) 
       AND G.start_date <= CURRENT_DATE 
       AND ( G.end_date >= CURRENT_DATE ) 
WITH UR 


SELECT distinct A.id, h.GREEN_VAN_CODE, G.start_date,G.end_date,
       A.des_serv_grp_id, 
       A.name, 
       A.description, 
       A.volume, 
       A.charge, 
       A.product_association, 
       A.time_to_deliver 
FROM   ldba.tdeserv A, 
       ldba.tdespts D, 
       ldba.tdespar E, 
       ldba.tdespro F, 
       ldba.tdesass G,
       ldba.tdesgrp h 
WHERE  A.id = D.del_ex_serv_id 
        and a.DES_SERV_GRP_ID = h.GRP_ID
        and h.GREEN_VAN_CODE in ('HIT', 'INT')
       --AND D.prod_type_id IN ( select PROD_TYPE_ASG_ID from ldba.VAXL_CDS_PROD where PROD_CODE = '81701220' ) 
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
       C.rsrc_id    AS resourceId , c.del_centre
FROM   tcapbty A, 
       trscass B ,
       tresrce C
WHERE  B.rsrc_id = c.rsrc_id 
       and c.del_centre IN ( 3822, 3821, 31 ) 
       AND A.cap_id = B.cap_id 
       AND a.short_code in ('DEL', 'DELHIT', 'DELWET') 
order by 4 asc, 3 asc , 2 asc
WITH UR 

SELECT A.cap_id     AS capabilityId, 
       A.short_code AS shortCode, 
       B.rsrc_id    AS resourceId 
FROM   tcapbty A, 
       trscass B, 
       tresrce c 
WHERE  c.del_centre = 43 
       AND B.rsrc_id = c.rsrc_id 
       AND A.cap_id = B.cap_id order by RESOURCEID
WITH UR 

--- DEL CENTRES with PARTICULAR CAPABILITY
SELECT * 
FROM   tcapbty A, 
       trscass B, 
       tresrce C 
WHERE  A.short_code = 'COR' 
       AND a.cap_id = b.cap_id 
       AND b.rsrc_id = c.rsrc_id 
WITH UR 

---- Find route information for deliveries on a particular order
SELECT B.resource_key, 
       B.route_num, 
       A.delivery_id, 
       C.del_date 
FROM   scds.tdrops0 A, 
       scds.troutes B, 
       scds.tdelvry C 
WHERE  A.delivery_id IN (SELECT delivery_id 
                         FROM   scds.tdelgoo 
                         WHERE  order_id = 'HHTTRN01') 
       AND A.route_uid = B.route_uid 
       AND A.delivery_id = C.delivery_id 
WITH UR 


SELECT a.locadd_uid, 
       a.location_uid, 
       a.bus_unit_id, 
       b.* 
FROM   tactpt0 a, 
       tlocat0 b 
WHERE  a.busact_num = 34 
       AND a.bus_unit_id IN ( 518, 517, 84 ) 
       AND a.locadd_uid = b.loc_address_uid 
WITH UR 
