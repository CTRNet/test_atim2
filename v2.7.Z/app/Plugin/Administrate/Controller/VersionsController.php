<?php

class VersionsController extends AdministrateAppController
{

    public $uses = array(
        'Version'
    );

    public $paginate = array(
        'Version' => array(
            'order' => 'Version.version_number'
        )
    );

    function detail()
    {
        // MANAGE DATA
        $versionData = $this->Version->find('all', array(
            'order' => array(
                'date_installed DESC',
                "id DESC"
            )
        ));
        if (empty($versionData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $versionData;
        
        if (isset($this->passedArgs['newVersionSetup'])) {
            $this->Version->data = $this->Version->find('first', array(
                'order' => array(
                    'Version.id DESC'
                )
            ));
            $this->Version->id = $this->Version->data['Version']['id'];
            AppController::newVersionSetup();
        }
    }

    function test()
    {
        // tests all master details models, this is not a user function
        $toTest = array(
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
        echo ("<ul>");
        foreach ($toTest as $unit) {
            list ($plugin, $model) = explode(".", $unit);
            $masterName = $model . "Master";
            $controlName = $model . "Control";
            $master = AppModel::getInstance($plugin, $masterName, false);
            $control = AppModel::getInstance($plugin, $controlName, false);
            $controlData = $control->find('all');
            echo ("<li>" . $masterName . "<ul>");
            foreach ($controlData as $data) {
                echo ("<li>" . $data[$controlName]["detail_tablename"]);
                $master->find("all", array(
                    'conditions' => array(
                        $masterName . "." . $master->belongsTo[$controlName]["foreignKey"] => $data[$controlName]['id']
                    )
                ));
                echo ("</li>");
            }
            echo ("</ul></li>");
        }
        echo ("</ul>");
        echo "Master models test completed";
        if ($error) {
            echo "<span class='err'>with error(s)</span>";
        }
        
        echo "<br/><br/>";
        
        // test all datarowser links
        $datamartStructureModel = AppModel::getInstance('Datamart', 'DatamartStructure');
        $datamartStructures = $datamartStructureModel->find('all');
        foreach ($datamartStructures as $datamartStructure) {
            if (AppController::checkLinkPermission($datamartStructure['DatamartStructure']['index_link'])) {
                echo '<span style="color: green;">', $datamartStructure['DatamartStructure']['index_link'], '</span><br/>';
            } else {
                echo '<span class="err" style="color: red;">', $datamartStructure['DatamartStructure']['index_link'], ' ---- INVALID LINK</span><br/>';
            }
        }
        echo '<span id="done"></span>';
        $this->layout = false;
        $this->render(false);
    }

    function latencyTest()
    {}
}