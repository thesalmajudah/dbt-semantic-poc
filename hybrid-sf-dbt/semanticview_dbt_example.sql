{% materialization semantic_view, default %}

  {%- set identifier = model['name'] -%}

  {%- set old_relation = adapter.get_relation(database=database, schema=schema, identifier=identifier) -%}
  {%- set target_relation = api.Relation.create(
      database=database,
      schema=schema,
      identifier=identifier,
      type='view') -%}

  {{ run_hooks(pre_hooks, inside_transaction=False) }}

  -- `BEGIN` happens here:
  {{ run_hooks(pre_hooks, inside_transaction=True) }}

  -- build model
  {% call statement('main') -%}
    create or replace semantic view {{ target_relation }}

    {{ sql }}

  {%- endcall %}

  {{ run_hooks(post_hooks, inside_transaction=True) }}

  -- `COMMIT` happens here
  {{ adapter.commit() }}

  {{ run_hooks(post_hooks, inside_transaction=False) }}

  {{ return({'relations': [target_relation]}) }}

{% endmaterialization %} 

models/projects/semantic_views/semantic_view.sql
{{ config(materialized='semantic_view') }}

TABLES (
  users AS {{ ref('a__user') }} PRIMARY KEY (id)
)

FACTS (
  users.id as users.id
)

DIMENSIONS (
  users.username AS users.username
    WITH SYNONYMS = ('customer name')
    COMMENT = 'Name of the customer',

  users.can_go_live AS users.can_go_live
    WITH SYNONYMS = ('can go live')
    COMMENT = 'livestream status',

  users.created_week AS date_trunc('week', users.created_at)
    COMMENT = 'created week'
)

METRICS (
  users.user_count AS COUNT(users.id)
    COMMENT = 'Count of number of users'
) 
models/projects/semantic_views/semantic_view_test.sql
{{ config(materialized='table') }}

select * from semantic_view(
    {{ ref('semantic_view') }}
    METRICS
        users.user_count
    DIMENSIONS
        users.can_go_live
        , users.created_week
)
