<?php

class CodingIcd10sController extends AppController {

	var $name = 'CodingIcd10s';
	var $othAuthRestrictions = null;
	
	/* 
		Forms Helper appends a "tool" link to the "add" and "edit" form types
		Clicking that link reveals a DIV tag with this Action/View that should have functionality to affect the indicated form field.
	*/
	
	function tool ( $field_id=NULL, $category='NULL', $icd_group='NULL', $site='NULL', $subsite='NULL' ) {
		$this->layout = 'none';
		if ( $field_id!=NULL ) {
			$this->set( 'field_id', $field_id );
			
			// ICD10 Coding Tool 
			$criteria = array();
			$this->params['data'] = array();
			$conditions = array();
			if ( $category!='NULL' ) {
				$this->data['CodingIcd10/category'] = $category;
				$conditions['CodingIcd10.category'] = $category;
			}
			
			if ( $icd_group!='NULL' ) {
				$this->data['CodingIcd10/icd_group'] = $icd_group;
				$conditions['CodingIcd10.icd_group'] = $icd_group;
			}
			
			if ( $site!='NULL' ) {
				$this->data['CodingIcd10/site'] = $site;
				$conditions['CodingIcd10.site'] = $site;
			}
			
			if ( $subsite!='NULL' ) {
				$this->data['CodingIcd10/subsite'] = $subsite;
				$conditions['CodingIcd10.subsite'] = $subsite;
			}
			
			$criteria = implode( ' AND ', $criteria );
			$order = 'CodingIcd10.id ASC';
			$this->set( 'icd10_listall', $this->CodingIcd10->find('all', array('conditions' => $conditions)));
			
			$this->render('tool', 'ajax');
			
		} else {
			
			die('
				<div class="error">
					Error: no field name provided!
				</div>
			');
			
		}
		
	}
	
	function autoComplete(){
		$key = "";
		foreach($this->data as $model){
			foreach($model as $field){
				$key = $field;
			}
		}
		$this->set('posts', $this->CodingIcd10->find('all', array(
			'conditions' => array(
			'CodingIcd10.id LIKE' => $key.'%'
			),
			'fields' => array('id'),
			'limit' => 10
		)));
		$this->layout = 'ajax';
	}
	
}

?>