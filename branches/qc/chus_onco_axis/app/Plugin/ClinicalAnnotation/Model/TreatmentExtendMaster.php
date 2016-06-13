<?php

class TreatmentExtendMaster extends ClinicalAnnotationAppModel {
    
	var $belongsTo = array(
		'TreatmentMaster' => array(
			'className'    => 'ClinicalAnnotation.TreatmentMaster',
			'foreignKey'    => 'treatment_master_id'
		),
		'TreatmentExtendControl' => array(
			'className'    => 'ClinicalAnnotation.TreatmentExtendControl',
			'foreignKey'    => 'treatment_extend_control_id'
		)
	);
	
}

?>