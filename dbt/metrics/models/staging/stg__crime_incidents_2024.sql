{{
    config(
        materialized = 'table'
    )
}}

{% set target_database = target.database %}

{% if target_database == 'dev' %}
    {% set source_database = 'dev_db' %}
{% elif target_database == 'prod' %}
    {% set source_database = 'prod_db' %}
{% else %}
    {% set source_database = 'dev_db' %}
    {% do log("Warning: Using default 'dev_db' as target is not set.", info=True) %}
{% endif %}

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
    {{ source(target_database, 'crime_incidents_2024') }}