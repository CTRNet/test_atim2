<?php

class Consent extends DataMartAppModel
{
    var $name = 'Consent';
	var $useTable = 'consents';
	
    
	var $belongsTo = array('Participant' =>
                           array('className'  => 'Participant',
                                 'conditions' => '',
                                 'order'      => '',
                                 'foreignKey' => 'participant_id'
                           )
                     );
	
	
	var $validate = array();
	
}

?>
