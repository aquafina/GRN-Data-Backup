CREATE OR REPLACE FORCE VIEW APPS.XX_GRN_ENTITY
(
   ENTITY,
   ENTITY_ID,
   APPROVERS
)
AS
   SELECT DISTINCT description entity, flex_value_id entity_id, ' ' approvers
     FROM FND_FLEX_VALUES_VL
    WHERE flex_value_set_id = 1014232
   UNION
   SELECT name entity, TO_NUMBER (organization_id) entity_id, ' '
     FROM hr_operating_units
   UNION
   SELECT organization_name entity,
          TO_NUMBER (organization_id) entity_id,
          ' '
     FROM org_organization_definitions;