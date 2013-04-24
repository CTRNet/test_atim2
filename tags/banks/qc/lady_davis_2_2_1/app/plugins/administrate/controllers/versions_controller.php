<?php

class VersionsController extends AdministrateAppController {
	
	var $uses = array('Version');
	var $paginate = array('Version'=>array('limit' => pagination_amount,'order'=>'Version.version_number'));

	function detail () {
		// MANAGE DATA
		$version_data = $this->Version->find('all', array('order' => array('date_installed DESC')));
		if(empty($version_data)) {
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		$this->data = $version_data;		
	}
	
	function test(){
		//tests all master details models, this is no a user function
		$this->layout = "ajax";
		$to_test = array(
			"Sop.Sop",
			"Storagelayout.Storage",
			"Protocol.Protocol",
			"Inventorymanagement.Aliquot",
		 	"Inventorymanagement.AliquotReview",
			"Inventorymanagement.Sample",
			"Inventorymanagement.SpecimenReview",
			"Clinicalannotation.Consent",
			"Clinicalannotation.Diagnosis",
			"Clinicalannotation.Event",
			"Clinicalannotation.Treatment");

		$error = false;
		echo("<ul>");
		foreach($to_test as $unit){
			list($plugin, $model) = explode(".", $unit);
			if(!App::import("model", $unit."Master")){
				echo("Import failed for: ".$unit."Master");
				$error = true;
				continue;
			}
			if(!App::import("model", $unit."Control")){
				echo("Import failed for: ".$unit."Control");
				$error = true;
				continue;
			}
			$master_name = $model."Master";
			$control_name = $model."Control";
			$master = new $master_name;
			$control = new $control_name();
			$control_data = $control->find('all');
			echo("<li>".$master_name."<ul>");
			foreach($control_data as $data){
				echo("<li>".$data[$control_name]["detail_tablename"]);
				$master->find("all", array('conditions' => array($master_name.".".$master->belongsTo[$control_name]["foreignKey"] => $data[$control_name]['id'])));
				echo("</li>");
			}
			echo("</ul></li>");
		}
		echo("</ul>");
		e("test completed");
		if($error){
			e(" with error(s)");
		}
		exit;
	}
}
?>