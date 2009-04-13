<?php

class Participant extends ClinicalannotationAppModel {
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, $result['Participant']['first_name'].' '.$result['Participant']['last_name'] ),
					'title'			=>	array( NULL, $result['Participant']['first_name'].' '.$result['Participant']['last_name'] ),
					
					'description'	=>	array(
						'tumour bank number'	=>	$result['Participant']['tb_number'],
						'date of birth'		=>	$result['Participant']['date_of_birth'],
						'marital status'		=>	$result['Participant']['marital_status'],
						'vital status'			=>	$result['Participant']['vital_status'],
						'sex'						=>		$result['Participant']['sex']
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