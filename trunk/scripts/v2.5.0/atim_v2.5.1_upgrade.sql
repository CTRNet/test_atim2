SELECT IF(COUNT(*) > 0, "At least one row of structure_fields table contains a field linked to detail model with no plugin defintion.", "No error") AS 'structure_fields.plugin check msg' FROM structure_fields WHERE model LIKE '%Detail' AND (plugin LIKE '' OR plugin IS NULL);

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND `flag_index`='1';

