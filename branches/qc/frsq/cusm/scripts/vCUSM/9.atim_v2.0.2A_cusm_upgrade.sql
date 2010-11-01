
DELETE FROM structure_formats 
WHERE structure_id = (SELECT id FROM structures WHERE alias = 'qc_cusm_dxd_procure') 
AND structure_field_id = (SELECT id FROM structure_fields WHERE field = 'morphology');
