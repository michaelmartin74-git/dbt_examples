{% macro convert_to_decimals(column_name, decimals = 2) %}

   round( ({{ column_name }}*1.0)/100, {{ decimals }} )

{%- endmacro %}