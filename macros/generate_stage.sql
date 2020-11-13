{% macro generate_stage(source_name, table_name) %}

{%- set source_relation = source(source_name, table_name) -%}

{%- set columns = adapter.get_columns_in_relation(source_relation) -%}

{%- set numeric = [] -%}
{%- set datetime = [] -%}
{%- set bool = [] -%}
{%- set string = [] -%}


{% for column in columns if column.is_numeric() or column.is_number() %}{% do numeric.append(column) %}{%endfor%}
{% for column in columns if column.dtype.startswith('DATE') or column.dtype.startswith('TIME') %}{% do datetime.append(column) %}{%endfor%}
{% for column in columns if column.dtype == 'BOOLEAN' %}{% do bool.append(column) %}{%endfor%}
{% for column in columns if column.is_string() %}{% do string.append(column) %}{%endfor%}

{%- set column_names=columns | map(attribute='name') -%}
{%- set column_types=columns | map(attribute='data_type') -%}
{%- set base_model_sql -%}
with

source as (

    select * from {% raw %}{{ source({% endraw %}'{{ source_name }}', '{{ table_name }}'{% raw %}) }}{% endraw %}

),

renamed as (

    select

        -- ids
        {%- for column in numeric -%}
        {{ column.column | lower }}
        {% if not loop.last %},{% endif%}
        {%- endfor %}

        {%- for column in datetime -%}
        {{ column.column | lower }}
        {% if not loop.last %},{% endif%}
        {%- endfor %}

        {%- for column in bool -%}
        {{ column.column | lower }}
        {% if not loop.last %},{% endif%}
        {%- endfor %}

        {%- for column in string -%}
        {{ column.column | lower }}
        {% if not loop.last %},{% endif%}
        {%- endfor %}

    from source
)

select * from renamed
{% endset %}

{% if execute %}

{{ log(base_model_sql, info=True) }}
{# {% do return(column_names | lower ) %} #}
{# {% do return(column_types) %} #}

{% endif %}
{% endmacro %}