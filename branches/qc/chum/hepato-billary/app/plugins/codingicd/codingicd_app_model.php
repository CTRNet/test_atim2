<?php
class CodingicdAppModel extends AppModel {	
	
	/**
	 * @param unknown_type $id The id of the code to get the description of
	 * @return the description of an icd code
	 * @note: This is CodingicdAppModel, thus this function must work for all coding
	 */
	function getDescription($id){
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
		$data = $this->find('first', array('conditions' => array('id' => $id), 'fields' => array($lang."_description")));
		if(is_array($data)){//useless if, but php generates a bogus warning without it
			$data = array_values($data);
			$data = array_values($data[0]);
		}
		return $data[0];
	}
	
	function globalValidateId($id){
		if(is_array($id)){
			$id = array_values($id);
			$id = $id[0];
		}
		return strlen($id) > 0 ? strlen($this->getDescription($id)) > 0 : true;
	}
}