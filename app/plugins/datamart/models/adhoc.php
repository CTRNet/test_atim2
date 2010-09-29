<?php

class Adhoc extends DatamartAppModel {
	
	var $useTable = 'datamart_adhoc';
	
	function summary( $variables=array() ) {
			
		$return = array(
			'Summary' => array(
				'menu' => array(null)));
			
		if(isset($variables['Param.Type_Of_List']) && empty($variables['Adhoc.id'])) {

			switch($variables['Param.Type_Of_List']) {
				case 'all':
					$return['Summary']['menu'] = array('all');
					break;
				case 'favourites':
					$return['Summary']['menu'] = array('my favourites');
					break;
				case 'saved':
					$return['Summary']['menu'] = array('my saved searches');
					break;
				default:	
			}	
		}
			
		if ( isset($variables['Adhoc.id']) && (!empty($variables['Adhoc.id'])) ) {
			$adhoc_data = $this->find('first', array('conditions'=>array('Adhoc.id' => $variables['Adhoc.id']), 'recursive' => '-1'));
			if(!empty($adhoc_data)) {
				$return['Summary']['title'] = array(null, __('query information', null));
				$return['Summary']['description'] = array(
					__('model', true) => $adhoc_data['Adhoc']['model'],
					__('description', true) => $adhoc_data['Adhoc']['description']);	
			}
		}
		
		return $return;
	}
	
}

?>