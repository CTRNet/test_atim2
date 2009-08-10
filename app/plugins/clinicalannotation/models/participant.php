<?php

class Participant extends ClinicalannotationAppModel {
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			
			$return = array(
				__('Summary', TRUE)	 => array(
					__('menu',TRUE)				=>	array( NULL, __($result['Participant']['first_name'].' '.$result['Participant']['last_name'], TRUE) ),
					__('title',TRUE)			=>	array( NULL, __($result['Participant']['first_name'].' '.$result['Participant']['last_name'], TRUE) ),
					
					__('description',TRUE)		=>	array(
						__('tumour bank number',TRUE)	=>	__($result['Participant']['tb_number'], TRUE),
						__('date of birth', TRUE)		=>	__($result['Participant']['date_of_birth'], TRUE),
						__('marital status', TRUE)		=>	__($result['Participant']['marital_status'], TRUE),
						__('vital status', TRUE)		=>	__($result['Participant']['vital_status'], TRUE),
						__('sex', TRUE)					=>	__($result['Participant']['sex'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}
   
   /*
   var $hasMany = array(
						
						'Diagnosis' =>
						 array('className'   => 'Diagnosis',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'participant_id',
                               'dependent'   => true,
                               'exclusive'   => false,
                               'finderSql'   => ''
                         ),
						 
						 'FamilyHistory' =>
						 array('className'   => 'FamilyHistory',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'participant_id',
                               'dependent'   => true,
                               'exclusive'   => false,
                               'finderSql'   => ''
                         ),
						 
						 'ParticipantContact' =>
						 array('className'   => 'ParticipantContact',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'participant_id',
                               'dependent'   => true,
                               'exclusive'   => false,
                               'finderSql'   => ''
                         ),
						 
						 'ParticipantMessage' =>
						 array('className'   => 'ParticipantMessage',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'participant_id',
                               'dependent'   => true,
                               'exclusive'   => false,
                               'finderSql'   => ''
                         ),
						 
						 'MiscIdentifier' =>
						 array('className'   => 'MiscIdentifier',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'participant_id',
                               'dependent'   => true,
                               'exclusive'   => true,
                               'finderSql'   => ''
                         )
						 
                  );
	*/
	
}

?>