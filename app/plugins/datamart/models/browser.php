<?php
class Browser extends DatamartAppModel {
	var $useTable = false;
	
	function getDropdownOptions(){
		global $getDropdownOptions;
		$result = array();
		if(is_array($getDropdownOptions)){
			$data = $this->query("SELECT * FROM datamart_browsing_controls AS c "
				."LEFT JOIN datamart_browsing_structures AS s1 ON c.id1=s1.id " 
				."LEFT JOIN datamart_browsing_structures AS s2 ON c.id2=s2.id "
				."WHERE id1=".$getDropdownOptions[0]." OR id2=".$getDropdownOptions[0]);
			foreach($data as $data_unit){
				if($data_unit['c']['id1'] == $getDropdownOptions[0]){
					//use 2
					$result[] = array('value' => $data_unit['s2']['id'], 'default' => __($data_unit['s2']['display_name'], true));
				}else{
					//use 1
					$result[] = array('value' => $data_unit['s1']['id'], 'default' => __($data_unit['s1']['display_name'], true));
				}
			}
		}else{
			$data = $this->query("SELECT * FROM datamart_browsing_structures");
			foreach($data as $data_unit){
				$result[] = array('value' => $data_unit['datamart_browsing_structures']['id'], 'default' => __($data_unit['datamart_browsing_structures']['display_name'], true));
			}
		}
		return $result;
	}
}