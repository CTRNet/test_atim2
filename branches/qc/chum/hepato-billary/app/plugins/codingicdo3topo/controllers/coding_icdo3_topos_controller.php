<?php

class CodingIcdo3ToposController extends Codingicdo3topoAppController{

	var $uses = array("Codingicdo3topo.CodingIcdo3Topo"); 
	/* 
		Forms Helper appends a "tool" link to the "add" and "edit" form types
		Clicking that link reveals a DIV tag with this Action/View that should have functionality to affect the indicated form field.
	*/
	
	function tool(){
		$this->layout = 'ajax';
		$this->Structures->set('simple_search');
		$this->Structures->set('empty', "empty");
	}
	
	function search($is_tool = true){
		if($is_tool){
			$this->layout = 'ajax';
			$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
			$this->Structures->set("codingicdo3topo_".$lang);
			$limit = 25;
			$term = mysql_real_escape_string($this->data[0]['term']);
			if(isset($this->data['exact_search'])){
				$term = '"'.$term.'"';
			}else{
				$term = str_replace(" ", "* ", trim($term))."*";
			}
			
			$this->data = $this->CodingIcdo3Topo->find('all', array(
				'conditions' => array(
				"MATCH(CodingIcdo3Topo.".$lang."_title) AGAINST ('".$term."' IN BOOLEAN MODE) OR "
				."MATCH(CodingIcdo3Topo.`".$lang."_sub_title`) AGAINST ('".$term."' IN BOOLEAN MODE) OR "
				."MATCH(CodingIcdo3Topo.".$lang."_description) AGAINST ('".$term."' IN BOOLEAN MODE)"
				),
				'limit' => $limit + 1));
			if(count($this->data) > $limit){
				unset($this->data[$limit]);
				$this->set("overflow", true);
			}			
		}else{
			die("not implemented");
		}
	}
	
	function autocomplete(){
		//layout = ajax to avoid printing layout
		$this->layout = 'ajax';
		//debug = 0 to avoid printing debug queries that would break the javascript array
		Configure::write('debug', 0);
		
		//query the database
		$term = str_replace('_', '\_', str_replace('%', '\%', $_GET['term']));
		$data = $this->CodingIcdo3Topo->find('all', array(
			'conditions' => array(
				'CodingIcdo3Topo.id LIKE' => $term.'%'),
			'fields' => array('CodingIcdo3Topo.id'), 
			'limit' => 10,
			'recursive' => -1));
		
		//build javascript textual array
		$result = "";
		foreach($data as $data_unit){
			$result .= '"'.$data_unit['CodingIcdo3Topo']['id'].'", ';
		}
		if(sizeof($result) > 0){
			$result = substr($result, 0, -2);
		}
		$this->set('result', "[".$result."]");
	}

	
}

?>