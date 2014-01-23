<?php

class ParticipantCustom extends Participant {
	
	var $useTable = 'participants';
	var $name = 'Participant';
	
	function summary($variables=array()){
		$return = false;
	
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));	

			$MiscIdentifier = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
			$MiscIdentifier->unbindModel(array('belongsTo' => array('Participant')));
			$qcroc_nbrs = $MiscIdentifier->find('all', array('conditions' => array('MiscIdentifier.participant_id' => $variables['Participant.id'], "MiscIdentifierControl.misc_identifier_name LIKE 'Q-CROC-%'")));
			$qcroc_titles = array();
			foreach($qcroc_nbrs as $new_nbr) {
				$qcroc_titles[] = substr($new_nbr['MiscIdentifierControl']['misc_identifier_name'], 7).'-'.$new_nbr['MiscIdentifier']['identifier_value'];
			}
			$qcroc_titles = implode(', ', $qcroc_titles);
			
			$title = $result['Participant']['qcroc_initials'].' ['.($qcroc_titles? $qcroc_titles : '-').']'; 
			$return = array(
					'menu'				=>	array( NULL, $title),
					'title'				=>	array( NULL, $title),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);
		}
	
		return $return;
	}
	
	function beforeSave($options = array()){
		$ret_val = parent::beforeSave();
		if(isset($this->data['Participant']['qcroc_initials'])) $this->data['Participant']['qcroc_initials'] = strtoupper($this->data['Participant']['qcroc_initials']); 
		return $ret_val; 
	}
}
