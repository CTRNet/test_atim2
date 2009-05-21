<?php

class Diagnosis extends DataMartAppModel
{
  var $name = 'Diagnosis';
	var $useTable = 'diagnoses';
	
	var $belongsTo = array(
		'Participant' => array(
			'className'  => 'Participant',
			'foreignKey' => 'participant_id'
		)
	);
	
	var $hasOne = array(
    				'ClinicalCollectionLink' =>
                        array(
                        	'className'    => 'ClinicalCollectionLink',
                            'conditions'   => '',
                            'order'        => '',
                            'dependent'    =>  true,
                            'foreignKey'   => 'diagnosis_id'
                        )
  );
	var $validate = array();
	
}

?>
