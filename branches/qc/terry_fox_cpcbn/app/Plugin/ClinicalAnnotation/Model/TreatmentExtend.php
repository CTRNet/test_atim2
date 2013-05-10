<?php

class TreatmentExtend extends ClinicalAnnotationAppModel {
    var $name = 'TreatmentExtend';
	var $useTable = false;
	
	var $belongsTo = array(
		'TreatmentMaster' => array(
			'className'    => 'ClinicalAnnotation.TreatmentMaster',
			'foreignKey'    => 'treatment_master_id'
		)
	);
	
}

?>