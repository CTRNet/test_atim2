<?php

class Rtbform extends RtbFormAppModel {
	var $name = 'Rtbform';
	var $useTable = 'rtbforms';

	function summary($variables = array()) {
		$return = false;

		if (isset($variables['Rtbform.id'])) {

			$result = $this->find('first', array('conditions' => array('Rtbform.id' => $variables['Rtbform.id'])));

			$return = array(
				'menu' => array(null, $result['Rtbform']['frmTitle']),
				'title' => array(null, $result['Rtbform']['frmTitle']),
				'data' => $result,
				'structure alias' => 'rtbforms'
			);
		}

		return $return;
	}
}

?>