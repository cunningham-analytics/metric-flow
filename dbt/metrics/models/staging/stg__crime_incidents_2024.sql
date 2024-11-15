{{
    config(
        materialized = 'table'
    )
}}

select
    cast("OBJECTID" as text) as id,
	cast("CCN" as text) as ccn,
	TO_CHAR(TO_TIMESTAMP("REPORT_DAT", 'YYYY/MM/DD HH24:MI:SS+00'), 'YYYY-MM-DD HH24:MI:SS') AS report_dtm,
	"SHIFT" as shift,
	"METHOD" as method,
	"OFFENSE" as offense,
	"BLOCK" as block,
	"WARD" as ward,
	"ANC" as anc,
	"DISTRICT" as district,
	"PSA" as psa,
	"VOTING_PRECINCT" as voting_precint,
	TO_CHAR(TO_TIMESTAMP("START_DATE", 'YYYY/MM/DD HH24:MI:SS+00'), 'YYYY-MM-DD HH24:MI:SS') as start_dtm,
	TO_CHAR(TO_TIMESTAMP("END_DATE", 'YYYY/MM/DD HH24:MI:SS+00'), 'YYYY-MM-DD HH24:MI:SS') as end_dtm
from
    {{ source('raw_db', 'crime_incidents_2024') }}