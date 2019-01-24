<?php

App::uses('StructuresComponent', 'Controller/Component');

/**
 * Class FormBuildersController
 */
class FormBuildersController extends AdministrateAppController
{
    public $uses = array(
        'ClinicalAnnotation.ConsentControl',
        'Administrate.FormBuilder'
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
        //$alias = $formBuilderItems['FormBuilder']['default_alias'];
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
        
        $this->request->data = $this->FormBuilder->getDataFromAlias($result);
        
        $this->set("data", $this->request->data);
        
        $aliases = "form_builder_structure";
        
        $this->Structures->set($aliases, "atimStructureForControl");
        

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

    public function add($formBuilderId) 
    {
        $formBuilderItems = $this->FormBuilder->getOrRedirect($formBuilderId);
        
        $model = $formBuilderItems['FormBuilder']['model'];
        $plugin = $formBuilderItems['FormBuilder']['plugin'];
        $master = (isset($formBuilderItems['FormBuilder']['master']))?$formBuilderItems['FormBuilder']['master']:"";
        $alias = $formBuilderItems['FormBuilder']['alias'];
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
        $this->set('formData', $formData);
        $modelInstance->data = $data;
        if (!empty($data) && $modelInstance->validates()){
            $modelInstance->setDataBeforeSave($data);
            $modelInstance->valiateLabels($data);
            if ($modelInstance->save($data)){
                $this->atimFlashConfirm("the control add successfully", "/Administrate/FormBuilders/detail/".$formBuilderId);
            }
        }
    }

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
    
    public function AutocompleteDropDownList()
    {
        //Todo
        //To be completed to return the list of value/domain

    }
}