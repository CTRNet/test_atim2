<?php

class EventMaster extends DataMartAppModel
{
    var $name = 'EventMaster';
	var $useTable = 'event_masters';
	
    var $belongsTo = array('Diagnosis' =>
                           array('className'  => 'Diagnosis',
                                 'conditions' => '',
                                 'order'      => '',
                                 'foreignKey' => 'diagnosis_id'
                           ),
													 'Participant' =>
                           array('className'  => 'Participant',
                                 'conditions' => '',
                                 'order'      => '',
                                 'foreignKey' => 'participant_id'
                           )
                     );
	
	var $hasOne = array(
    				'EventDetail' =>
                        array(
                        	'className'    => 'EventDetail',
                            'conditions'   => '',
                            'order'        => '',
                            'dependent'    =>  true,
                            'foreignKey'   => 'event_master_id'
                        )
  );
	
	var $validate = array();
	
}

?>
