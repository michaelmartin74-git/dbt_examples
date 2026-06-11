{% macro grant_select(project = target.project, dataset = target.dataset) %}

    {% set sql %}
        grant "roles/bigquery.dataViewer" on dataset {{ dataset }} to group {{ target.name }}
    {% endset %}

    {{ log('Granting  "roles/bigquery.dataViewer" on dataset ' ~ dataset, info=True) }}
    {{ log(sql, info=True) }}
    {{ log('Finished granting "roles/bigquery.dataViewer" on dataset ' ~ dataset, info=True) }}

{% endmacro %}