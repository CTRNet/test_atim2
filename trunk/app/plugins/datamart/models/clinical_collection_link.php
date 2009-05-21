<?php

class ClinicalCollectionLink extends DataMartAppModel
{
    var $name = 'ClinicalCollectionLink';
	var $useTable = 'clinical_collection_links';
	
    var $belongsTo = array(
						'Collection' =>
                           array('className'  => 'Collection',
                                 'conditions' => '',
                                 'order'      => '',
                                 'foreignKey' => 'collection_id'
                           ),
                        'Participant' =>
                           array('className'  => 'Participant',
                                 'conditions' => '',
                                 'order'      => '',
                                 'foreignKey' => 'participant_id'
                           )
                     );
	
	var $validate = array();
	
}

?>