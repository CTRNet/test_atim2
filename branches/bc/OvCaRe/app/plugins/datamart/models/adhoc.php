<?php

class Adhoc extends DatamartAppModel {
	
	var $useTable = 'datamart_adhoc';
	
	private $bindingApplied = false;
	
	function beforeFind($queryData){
		if(!$this->bindingApplied){
			$this->applyBinding();
		}
		return true;
	}
	
	private function applyBinding(){
		AppModel::getInstance('Datamart', 'AdhocFavourite', true);
		AppModel::getInstance('Datamart', 'AdhocSaved', true);
		AppModel::getInstance('Datamart', 'AdhocPermission', true);
		$this->bindModel(array('hasMany' => array(
		'AdhocFavourite'	=> array(
			'className'  	=> 'AdhocFavourite',
			'conditions'	=> 'AdhocFavourite.user_id="'.$_SESSION['Auth']['User']['id'].'"',
			'foreignKey'	=> 'adhoc_id',
			'dependent'		=> true
		),'AdhocSaved'	=> array(
			'className'  	=> 'AdhocSaved',
			'conditions'	=> 'AdhocSaved.user_id="'.$_SESSION['Auth']['User']['id'].'"',
			'foreignKey'	=> 'adhoc_id',
			'dependent'		=> true
		), 'AdhocPermission' => array(
			'className'  	=> 'AdhocPermission',
			'conditions'	=> 'AdhocPermission.group_id="'.$_SESSION['Auth']['User']['group_id'].'"',
			'foreignKey'	=> 'datamart_adhoc_id',
			'dependent'		=> true
		)
		)), false);
		
		$this->bindingApplied = true;
	}
	
	function summary( $variables=array() ) {
			
		$return = array();
			
		if ( isset($variables['Adhoc.id']) && (!empty($variables['Adhoc.id'])) ) {
			$adhoc_data = $this->find('first', array('conditions'=>array('Adhoc.id' => $variables['Adhoc.id']), 'recursive' => '-1'));
			if(isset($adhoc_data['Adhoc']['description'])) $adhoc_data['Adhoc']['description'] = __($adhoc_data['Adhoc']['description'], true);
			
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