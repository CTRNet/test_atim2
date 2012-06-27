<?php

class DiagnosisMasterCustom extends DiagnosisMaster {
	var $useTable = 'diagnosis_masters';
	var $name = 'DiagnosisMaster';
	
	var $belongsTo = array(
		'Participant' => array(
			'className' => 'ClinicalAnnotation.Participant',
			'foreignKey' => 'participant_id'),
		'DiagnosisControl' => array(
			'className'    => 'ClinicalAnnotation.DiagnosisControl',
			'foreignKey'    => 'diagnosis_control_id'
		)
	);

	var $virtualFields = array(
		'survival_time_years'	=> 'IF(DiagnosisMaster.dx_date IS NULL, NULL,
			IF(DiagnosisMaster.dx_date_accuracy != "c", "Err A",
			IF(Participant.date_of_death IS NOT NULL,
				IF(Participant.date_of_death_accuracy = "c", YEAR(Participant.date_of_death) - YEAR(DiagnosisMaster.dx_date) - (DAYOFYEAR(Participant.date_of_death) < DAYOFYEAR(DiagnosisMaster.dx_date)), "ERR B"),
				IF(Participant.qc_nd_last_contact IS NOT NULL, YEAR(Participant.qc_nd_last_contact) - YEAR(DiagnosisMaster.dx_date) - (DAYOFYEAR(Participant.qc_nd_last_contact) < DAYOFYEAR(DiagnosisMaster.dx_date)), "ERR C")
			)))',
		'survival_time_days'	=> 'IF(DiagnosisMaster.dx_date IS NULL, NULL,
			IF(DiagnosisMaster.dx_date_accuracy != "c", "Err A",
			IF(Participant.date_of_death IS NOT NULL,
				IF(Participant.date_of_death_accuracy = "c", IF(DAYOFYEAR(Participant.date_of_death) < DAYOFYEAR(DiagnosisMaster.dx_date), DATEDIFF(CONCAT("1901", substr(Participant.date_of_death, 5)), CONCAT("1900", substr(DiagnosisMaster.dx_date, 5))), DATEDIFF(CONCAT("1900", substr(Participant.date_of_death, 5)), CONCAT("1900", substr(DiagnosisMaster.dx_date, 5)))), "ERR B"), 
				IF(Participant.qc_nd_last_contact IS NOT NULL, IF(DAYOFYEAR(Participant.qc_nd_last_contact) < DAYOFYEAR(DiagnosisMaster.dx_date), DATEDIFF(CONCAT("1901", substr(Participant.qc_nd_last_contact, 5)), CONCAT("1900", substr(DiagnosisMaster.dx_date, 5))), DATEDIFF(CONCAT("1900", substr(Participant.qc_nd_last_contact, 5)), CONCAT("1900", substr(DiagnosisMaster.dx_date, 5)))), "ERR C")
			)))'
	);
}