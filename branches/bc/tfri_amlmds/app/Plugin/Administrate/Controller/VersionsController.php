<?php

class VersionsController extends AdministrateAppController {
	
	var $uses = array('Version');
	var $paginate = array('Version'=>array('limit' => pagination_amount,'order'=>'Version.version_number'));

	function detail () {
		// MANAGE DATA
		$version_data = $this->Version->find('all', array('order' => array('date_installed DESC', "id DESC")));
		if(empty($version_data)) {
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		$this->request->data = $version_data;

		if(isset($this->passedArgs['newVersionSetup'])){
			$this->Version->data = $this->Version->find('first', array('order' => array('Version.id DESC')));
			$this->Version->id = $this->Version->data['Version']['id'];
			AppController::newVersionSetup();
		}
	}
	
	function test(){
		//tests all master details models, this is not a user function
		$to_test = array(
			"Sop.Sop",
			"StorageLayout.Storage",
			"Protocol.Protocol",
			"InventoryManagement.Aliquot",
		 	"InventoryManagement.AliquotReview",
			"InventoryManagement.Sample",
			"InventoryManagement.SpecimenReview",
			"ClinicalAnnotation.Consent",
			"ClinicalAnnotation.Diagnosis",
			"ClinicalAnnotation.Event",
			"ClinicalAnnotation.Treatment"
		);

		$error = false;
		echo("<ul>");
		foreach($to_test as $unit){
			list($plugin, $model) = explode(".", $unit);
			$master_name = $model."Master";
			$control_name = $model."Control";
			$master = AppModel::getInstance($plugin, $master_name, false);
			$control = AppModel::getInstance($plugin, $control_name, false);
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
		echo "Master models test completed";
		if($error){
			echo " with error(s)";
		}
		
		echo "<br/><br/>";
		
		//test all datarowser links
		$datamart_structure_model = AppModel::getInstance('Datamart', 'DatamartStructure');
		$datamart_structures = $datamart_structure_model->find('all');
		foreach($datamart_structures as $datamart_structure){
			if(AppController::checkLinkPermission($datamart_structure['DatamartStructure']['index_link'])){
				echo '<span style="color: green;">',$datamart_structure['DatamartStructure']['index_link'],'</span><br/>';
			}else{
				echo '<span style="color: red;">',$datamart_structure['DatamartStructure']['index_link'],' ---- INVALID LINK</span><br/>';
			}
		}
		$this->layout = false;
		$this->render(false);
	}
	
	function latencyTest(){
		
	}
}
?>