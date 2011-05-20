<?php

class Adhoc extends DatamartAppModel {
	
	var $useTable = 'datamart_adhoc';
	
	function summary( $variables=array() ) {
			
		$return = array();
			
		if ( isset($variables['Adhoc.id']) && (!empty($variables['Adhoc.id'])) ) {
			$adhoc_data = $this->find('first', array('conditions'=>array('Adhoc.id' => $variables['Adhoc.id']), 'recursive' => '-1'));
			
			if(!empty($adhoc_data)) {
				$return['menu'] = array(__($adhoc_data['Adhoc']['title'], true));
				$return['title'] = array(null, __($adhoc_data['Adhoc']['title'], true));
				$return['structure alias'] = 'querytool_adhoc';
				$return['data'] = $adhoc_data;
			}
		
		} else if(isset($variables['Param.Type_Of_List'])) {

			switch($variables['Param.Type_Of_List']) {
				case 'all':
					$return['menu'] = array(__('all', true));
					break;
				case 'favourites':
					$return['menu'] = array(__('my favourites',true));
					break;
				case 'saved':
					$return['menu'] = array(__('my saved searches',true));
					break;
				default:	
			}	
		}
		
		return $return;
	}
	
}

?>