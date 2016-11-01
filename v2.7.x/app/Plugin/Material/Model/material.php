<?php

class Material extends AppModel {
	var $name = 'Material';
	var $useTable = 'materials';

	function summary($variables = array()) {
		$return = false;

		if (isset($variables['Material.id'])) {

			$result = $this->find('first', array('conditions' => array('Material.id' => $variables['Material.id'])));

			$return = array(
				'menu' => array(null, $result['Material']['item_name']),
				'title' => array(null, $result['Material']['item_name']),
				'data' => $result,
				'structure alias' => 'materials'
			);
		}

		return $return;
	}

}

?>