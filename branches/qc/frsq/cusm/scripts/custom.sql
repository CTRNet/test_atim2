UPDATE structure_formats sfo, structure_fields sfi, structures st
SET flag_edit='1', flag_edit_readonly = '0'
WHERE st.id = sfo.structure_id AND sfi.id = sfo.structure_field_id
AND sfi.field = 'aliquot_label' AND st.alias = 'aliquot_masters';