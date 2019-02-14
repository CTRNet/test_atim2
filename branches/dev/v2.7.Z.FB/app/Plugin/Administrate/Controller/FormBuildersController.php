<?php

App::uses('StructuresComponent', 'Controller/Component');

/**
 * Class FormBuildersController
 */
class FormBuildersController extends AdministrateAppController
{
    public $uses = array(
        'ClinicalAnnotation.ConsentControl',
        'Administrate.FormBuilder',
        'StructureField',
        'StructureFormat',
        'StructureValueDomain'
    );
    
    public $components = array(
        "Structures"
    );
        
    public function beforeFilter()
    {
        parent::beforeFilter();
        //Check permissions if need: for example the user have access to FB but not consent
    }

    public function index()
    {
        $this->Structures->set('form_builder_index');
        $this->request->data = $this->FormBuilder->find('all', array(
            'conditions' => array(
                'flag_active' => '1'
            ),
            'order' => array(
                'display_order'
            )
        ));
        if (!empty($this->request->data)) {
            foreach ($this->request->data as &$data) {
                $data['FormBuilder']['note'] = __($data['FormBuilder']['note']);
            }
        }
    }

    public function detail($formBuilderId)
    {
        $formBuilderItems = $this->FormBuilder->getOrRedirect($formBuilderId);
        if (!empty($formBuilderItems)) {
            $model = $formBuilderItems['FormBuilder']['model'];
            $plugin = $formBuilderItems['FormBuilder']['plugin'];
            $master = (isset($formBuilderItems['FormBuilder']['master']))?$formBuilderItems['FormBuilder']['master']:"";
            $alias = $formBuilderItems['FormBuilder']['alias'];
            $modelInstance = AppModel::getInstance($plugin, $model);
            $indexData = array();

            if (!empty($master)) {
                $indexData = $modelInstance->find('all', array(
                    'conditions' => array(
                        'flag_active' => '1'
                    ),
                    'order' => array(
                        'display_order'
                    )
                ));
            }
            $data = array(
                'indexData' => $indexData,
                'model' => $model,
                'plugin' => $plugin,
                'master' => $master,
                'formBuilderId' => $formBuilderId
            );
            $this->set ('formData', $data);
            $this->Structures->set($alias);
        }
    }
    
    public function detailControl($formBuilderId, $controlId) 
    {
        
        $formBuilderItems = $this->FormBuilder->getOrRedirect($formBuilderId);
        $model = $formBuilderItems['FormBuilder']['model'];
        $plugin = $formBuilderItems['FormBuilder']['plugin'];
        $master = (isset($formBuilderItems['FormBuilder']['master']))?$formBuilderItems['FormBuilder']['master']:"";
        $alias = $formBuilderItems['FormBuilder']['alias'];

        $modelInstance = AppModel::getInstance($plugin, $model);
        
        $controlItem = $modelInstance->getOrRedirect($controlId);
        $detailFormAliases = explode(",", $controlItem[$model]["detail_form_alias"]);
        $masterFormAliases = explode(",", $controlItem[$model]["form_alias"]);
        $masterFormAliases = array_diff($masterFormAliases, $detailFormAliases);

        $result = array(
            "master" =>array(), 
            "detail" =>array()
        );
        
        foreach ($masterFormAliases as $aliasName){
            $result["master"][] = $this->Structures->getSingleStructure($aliasName);
        }
        
        foreach ($detailFormAliases as $aliasName){
            $result["detail"][] = $this->Structures->getSingleStructure($aliasName);
        }

        $this->request->data = $this->FormBuilder->getDataFromAlias($result, $master);
        $this->request->data['control'] = $controlItem;
        
        $this->Structures->set("form_builder_structure", "atimStructureForControl");
        
        $this->Structures->set($alias, "atimStructureForDetailControl");
        
        $data = array(
            'data' => $this->request->data,
            'model' => $model,
            'plugin' => $plugin,
            'master' => $master,
            'controlId' => $controlId,
            'formBuilderId' => $formBuilderId
        );

        $this->set("formData", $data);
        

    }

    public function add($formBuilderId) 
    {
        $formBuilderItems = $this->FormBuilder->getOrRedirect($formBuilderId);
        
        $model = $formBuilderItems['FormBuilder']['model'];
        $plugin = $formBuilderItems['FormBuilder']['plugin'];
        $master = (isset($formBuilderItems['FormBuilder']['master']))?$formBuilderItems['FormBuilder']['master']:"";
        $alias = $formBuilderItems['FormBuilder']['alias'];
        $defaultAlias = $formBuilderItems['FormBuilder']['default_alias'];

        $this->Structures->set("form_builder_structure", "atimStructureForControl");

        
        $modelInstance = AppModel::getInstance($plugin, $model);
        $this->Structures->set($alias);

        $data = $this->request->data;

        $formData = array(
            'indexData' => $data,
            'model' => $model,
            'plugin' => $plugin,
            'master' => $master,
            'formBuilderId' => $formBuilderId
        );
        $options = array(
            'prefix-common' =>'common'
        );
        $this->set('formData', $formData);
        $this->set('options', $options);

        $modelInstance->data = $data;
        $this->StructureField->data = $data;

        
//$modelInstance->validates(); --> OK
//$this->StructureField->validatesFormBuilder($options); --> Should work on is_structure_value_domain
//$this->StructureFormat->validates();
        
//        if (!empty($data) && $modelInstance->validates()){
             //&& $this->StructureField->validates() /*&& $this->StructureFormat->validates()*/){
//        }
//            $modelInstance->setDataBeforeSave($data);
//            $modelInstance->valiateLabels($data);
            
//            if ($modelInstance->save($data)){
//                $this->atimFlashConfirm("the control add successfully", "/Administrate/FormBuilders/detail/".$formBuilderId);
//            }
    }

    public function edit($formBuilderId, $controlId) 
    {
        
    }

    public function cloneControl($formBuilderId, $controlId) 
    {
        
    }

    public function disable($formBuilderId, $controlId) 
    {
        
    }

    public function delete($formBuilderId, $controlId) 
    {
        
    }

    /*
    public function getI18n()
    {
        if ($this->request->is('ajax')){
            $i18nModel = new Model(array(
                'table' => 'i18n',
                'name' => 0
            ));
            $i18n = $i18nModel->find('all');
            $this->set('i18n', json_encode($i18n));
        }else{
            $this->atimFlashError(__("You are not authorized to access that location."), '/Menus');
        }
    }
    */
    
    public function AutocompleteDropDownList()
    {
        $term = $_GET['term'];
        $result = $this->StructureValueDomain->find('all', array(
            'conditions' => array(
                "StructureValueDomain.domain_name like" => "%$term%"
            ),
            'fields' => array(
                "StructureValueDomain.domain_name",
                "StructureValueDomain.id"
            )
        ));
        $result = $this->StructureValueDomain->normalized($result);
        $this->set("result", $result);
    }
    
    public function valueDomain()
    {
        if ($this->request->is('ajax') || true){
            $this->Structures->set("form_builder_value_domain", "formBuilderValueDomain");
        }else{
            $this->atimFlashError(__('You are not authorized to access that location.'), "/Menus");
        }
    }
    
    public function addValidation($type)
    {
        if ($this->request->is('ajax')){
            $activeValidations = $this->FormBuilder->checkValidation($type);
            $this->Structures->set("form_builder_validation", "formBuilderValidationStructure");
            $this->set("activeValidations", $activeValidations);
            $this->set("type", $type);
        }else{
            $this->atimFlashError(__('You are not authorized to access that location.'), "/Menus");
        }
    }
    
    public function normalised($type)
    {
        $this->autoRender = false ;
        return $this->FormBuilder->normalised($this->request->data, $type);
    }
}