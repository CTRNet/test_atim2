<?php

class Participant extends DataMartAppModel
{
    var $name = 'Participant';
	var $useTable = 'participants';
	
  var $hasMany = array(
					'Diagnosis' => array(
						'className'   => 'Diagnosis',
						'conditions'  => '',
						'order'       => '',
						'limit'       => '',
						'foreignKey'  => 'participant_id',
						'dependent'   => true,
						'exclusive'   => false,
						'finderSql'   => ''
					 )
				);
        
        
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
	
	var $validate = array();
	
}

?>
