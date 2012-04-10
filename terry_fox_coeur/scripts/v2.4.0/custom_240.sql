UPDATE diagnosis_masters AS dm1
INNER JOIN diagnosis_masters AS dm2 ON dm1.participant_id=dm2.participant_id AND dm1.primary_number=dm2.primary_number AND dm1.qc_tf_dx_origin != 'primary' AND dm2.qc_tf_dx_origin = 'primary'
SET dm1.primary_id=dm2.id;
UPDATE diagnosis_masters SET primary_id=id WHERE qc_tf_dx_origin='primary';

UPDATE diagnosis_masters AS dm1
INNER JOIN diagnosis_masters AS dm2 ON dm1.participant_id=dm2.participant_id AND dm1.primary_number=dm2.primary_number AND dm1.qc_tf_dx_origin != 'primary' AND dm2.qc_tf_dx_origin = 'primary'
SET dm1.primary_id=dm2.id;
UPDATE diagnosis_masters SET primary_id=id WHERE qc_tf_dx_origin='primary';

UPDATE diagnosis_controls
 SET category='secondary' WHERE id=16;
UPDATE diagnosis_controls SET flag_active=0 WHERE id > 18;

ALTER TABLE diagnosis_masters 
	DROP COLUMN dx_identifier,
	DROP COLUMN primary_number,
	DROP COLUMN dx_origin;
ALTER TABLE diagnosis_masters_revs
	DROP COLUMN dx_identifier,
	DROP COLUMN primary_number,
	DROP COLUMN dx_origin;	
