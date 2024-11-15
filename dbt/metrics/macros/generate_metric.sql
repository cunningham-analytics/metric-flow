{% macro generate_metric(metric_file, metric) %}

    {% set metrics_yaml_path = metric_file %}
    {% set metric = load_yaml(metrics_yaml_path)['metrics'][metric] %}

    {% set metric_name = metric['name'] %}
    {% set calculation = metric['calculation'] %}
    {% set base_table = metric['base_table'] %}
    {% set fields_to_aggregate = metric['fields_to_aggregate'] %}
    {% set filters = metric['filters'] %}
    {% set date_field = metric['date_field'] %}
    {% set date_grains = metric['date_grain'] %}

    {% for agg_field in fields_to_aggregate %}
        {% for fltr in filters %}
            {% for date_grain in date_grains %}
            
                select
                    '{{ date_grain }}' as date_grain,
                    date_trunc('{{ date_grain }}', {{ date_field }}) as date_value,
                    '{{ metric_name }}' as metric_name,
                    '{{ agg_field }}' as aggregate_field,
                    {{ agg_field }} as aggregate_field_value,
                    '{{ fltr }}' as row_level_filter,
                    '{{ calculation }}' as metric_calculation,
                    {{ calculation }} as metric_value
                from
                    {{ ref(base_table) }}
                where {{ fltr }}
                
                {% if not loop.last %} 
                    union all 
                {% endif %}
                
            {% endfor %}
            
            {% if not loop.last %} 
                union all 
            {% endif %}
            
        {% endfor %}
        
        {% if not loop.last %} 
            union all 
        {% endif %}
        
    {% endfor %}

{% endmacro %}
