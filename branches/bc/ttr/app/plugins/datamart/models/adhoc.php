<?php

class Adhoc extends DatamartAppModel {
	
	var $useTable = 'datamart_adhoc';
	
	function summary( $variables=array() ) {
			
		$return = array();
			
		if ( isset($variables['Adhoc.id']) && (!empty($variables['Adhoc.id'])) ) {
			$adhoc_data = $this->find('first', array('conditions'=>array('Adhoc.id' => $variables['Adhoc.id']), 'recursive' => '-1'));
			if(!empty($adhoc_data)) {
				$return['menu'] = array($adhoc_data['Adhoc']['title']);
				$return['title'] = array(null, $adhoc_data['Adhoc']['title']);
			}
		
		} else if(isset($variables['Param.Type_Of_List'])) {

			switch($variables['Param.Type_Of_List']) {
				case 'all':
					$return['menu'] = array('all');
					break;
				case 'favourites':
					$return['menu'] = array('my favourites');
					break;
				case 'saved':
					$return['menu'] = array('my saved searches');
					break;
				default:	
			}	
		}
		
		return $return;
	}
	
}

?>