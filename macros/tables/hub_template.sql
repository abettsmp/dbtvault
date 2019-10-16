{#- Copyright 2019 Business Thinking LTD. trading as Datavault

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-#}
{%- macro hub_template(src_pk, src_nk, src_ldts, src_source,
                       tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                       source) -%}
-- Generated by dbtvault. Copyright 2019 Business Thinking LTD. trading as Datavault
{% set is_union = true if source|length > 1 else false %}
SELECT DISTINCT {{ dbtvault.cast([tgt_pk, tgt_nk, tgt_ldts, tgt_source], 'stg') }}
FROM (
    {{ dbtvault.create_source(src_pk, src_nk, src_ldts, src_source,
                              tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                              source, is_union) }}
) AS stg
{% if is_incremental() or is_union -%}
LEFT JOIN {{ this }} AS tgt
ON {{ dbtvault.prefix([tgt_pk|first], 'stg') }} = {{ dbtvault.prefix([tgt_pk|last], 'tgt') }}
WHERE {{ dbtvault.prefix([tgt_pk|last], 'tgt') }} IS NULL
{%- if is_union %}
AND stg.FIRST_SOURCE IS NULL
{%- endif -%}
{%- endif -%}
{%- endmacro -%}