<?php

class CodingIcd10sController extends AppController {

	var $name = 'CodingIcd10s';
	var $othAuthRestrictions = null;
	
//	function autocomplete ( $model=NULL, $field=NULL ) {
//	    
//		$this->set( 'codes',
//	        $this->CodingIcd10->findAll(
//	            'id LIKE "%'.$this->data[ $model ][ $field ].'%"',
//				NULL,
//				'id ASC',
//				12
//			)
//		);
//		
//		$this->render('autocomplete', 'ajax');
//		
//	}
	
	/* 
		Forms Helper appends a "tool" link to the "add" and "edit" form types
		Clicking that link reveals a DIV tag with this Action/View that should have functionality to affect the indicated form field.
	*/
	
//	function tool ( $field_name=NULL, $category='NULL', $group='NULL', $site='NULL', $subsite='NULL' ) {
//		
//		$this->layout = 'none';
//		
//		if ( $field_name!=NULL ) {
//			
//			$this->set( 'field_name', $field_name );
//			
//			// ICD10 Coding Tool 
//			$criteria = array();
//			$this->params['data'] = array();
//			
//			if ( $category!='NULL' ) {
//				$criteria[] = 'CodingIcd10.category="'.$category.'"';
//				$this->params['data']['CodingIcd10']['category'] = $category;
//			}
//			
//			if ( $group!='NULL' ) {
//				$criteria[] = 'CodingIcd10.group="'.$group.'"';
//				$this->params['data']['CodingIcd10']['group'] = $group;
//			}
//			
//			if ( $site!='NULL' ) {
//				$criteria[] = 'CodingIcd10.site="'.$site.'"';
//				$this->params['data']['CodingIcd10']['site'] = $site;
//			}
//			
//			if ( $subsite!='NULL' ) {
//				$criteria[] = 'CodingIcd10.subsite="'.$subsite.'"';
//				$this->params['data']['CodingIcd10']['subsite'] = $subsite;
//			}
//			
//			$criteria = implode( ' AND ', $criteria );
//			$order = 'CodingIcd10.id ASC';
//			$this->set( 'icd10_listall', $this->CodingIcd10->findAll( $criteria, NULL, $order ) );
//			
//			$this->render('tool', 'ajax');
//			
//		} else {
//			
//			die('
//				<div class="error">
//					Error: no field name provided!
//				</div>
//			');
//			
//		}
//		
//	}
//	
//	/* 
//		Forms Helper will add result of "append" Action/View to "listall"and "detail" form types.
//	*/
//	
//	function append ( $icd10_id_value=NULL ) {
//		
//		$return_string = '';
//		
//		if ( $icd10_id_value ) {
//			$icd10_result = $this->CodingIcd10->read( NULL, $icd10_id_value );
//			$return_string = $icd10_result['CodingIcd10']['description'] ? '- '.$icd10_result['CodingIcd10']['description'].' ' : '';
//		}
//		
//		return $return_string;
//		exit;
//	}
//
//	function ParticipantIcd10Id(){
//		$this->set('posts', $this->CodingIcd10s->find('all', array(
//			'conditions' => array(
//			'CodingIcd10s.id LIKE' => $this->data['CodingIcd10s']['id'].'%'
//			),
//			'fields' => array('id')
//		)));
//		$this->layout = 'ajax';
//	}
//	
//	function FamilyHistoryIcd10Id(){
//		
//	}
//	
//	function DiagnosisIcd10Id(){
//		
//	}
	
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
			'fields' => array('id')
		)));
		$this->layout = 'ajax';
	}
	
}

?>