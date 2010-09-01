<?php

class CodingIcd10sController extends Codingicd10AppController{

	var $uses = array("Codingicd10.CodingIcd10"); 
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
			$this->Structures->set("codingicd10_".$lang);
			$limit = 25;
			$term = mysql_real_escape_string($this->data[0]['term']);
			if(isset($this->data['exact_search'])){
				$term = '"'.$term.'"';
			}else{
				$term = str_replace(" ", "* ", trim($term))."*";
			}
			$this->data = $this->CodingIcd10->find('all', array(
				'conditions' => array(
				"MATCH(CodingIcd10.".$lang."_title) AGAINST ('".$term."' IN BOOLEAN MODE) OR "
				."MATCH(CodingIcd10.`".$lang."_sub_title`) AGAINST ('".$term."' IN BOOLEAN MODE) OR "
				."MATCH(CodingIcd10.".$lang."_description) AGAINST ('".$term."' IN BOOLEAN MODE)"
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
}

?>