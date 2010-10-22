<?php 
/* SVN FILE: $Id$ */
/* Group Test cases generated on: 2009-02-18 12:02:42 : 1234982202*/
App::import('Model', 'Group');

class GroupTestCase extends CakeTestCase {
	var $Group = null;
	var $fixtures = array('app.group');

	function startTest() {
		$this->Group =& ClassRegistry::init('Group');
	}

	function testGroupInstance() {
		$this->assertTrue(is_a($this->Group, 'Group'));
	}

	function testGroupFind() {
		$this->Group->recursive = -1;
		$results = $this->Group->find('first');
		$this->assertTrue(!empty($results));

		$expected = array('Group' => array(
			'id'  => 1,
			'name'  => 'Lorem ipsum dolor sit amet',
			'created'  => '2009-02-18 12:36:42',
			'modified'  => '2009-02-18 12:36:42'
			));
		$this->assertEqual($results, $expected);
	}
}
?>