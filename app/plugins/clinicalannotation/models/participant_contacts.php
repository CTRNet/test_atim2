<?php

class ParticipantContact extends ClinicalAnnotationAppModel
{
    var $name = 'ParticipantContact';
	var $useTable = 'participant_contacts';
	
    /*
	var $belongsTo = array('Participant' =>
                           array('className'  => 'Participant',
                                 'conditions' => '',
                                 'order'      => '',
                                 'foreignKey' => 'participant_id'
                           )
                     );
	*/
	
	var $validate = array();
	
}

?>