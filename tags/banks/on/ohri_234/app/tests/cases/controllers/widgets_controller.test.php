<?php 
/* SVN FILE: $Id$ */
/* WidgetsController Test cases generated on: 2009-02-18 12:02:02 : 1234982342*/
App::import('Controller', 'Widgets');

class TestWidgets extends WidgetsController {
	var $autoRender = false;
}

class WidgetsControllerTest extends CakeTestCase {
	var $Widgets = null;

	function setUp() {
		$this->Widgets = new TestWidgets();
		$this->Widgets->constructClasses();
	}

	function testWidgetsControllerInstance() {
		$this->assertTrue(is_a($this->Widgets, 'WidgetsController'));
	}

	function tearDown() {
		unset($this->Widgets);
	}
}
?>