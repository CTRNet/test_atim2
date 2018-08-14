<?php

/**
 * Class Template
 */
class Template extends ToolsAppModel
{

    public $useTable = 'templates';

    public $tree = null;

    /**
     * Build array to display the template nodes tree view.
     *
     * @return array
     */
    public function init()
    {
        $templateNodeModel = AppModel::getInstance("Tools", "TemplateNode", true);
        $tree = $templateNodeModel->find('all', array(
            'conditions' => array(
                'TemplateNode.Template_id' => $this->id
            )
        ));
        $result[''] = array(
            'id' => 0,
            'parent_id' => null,
            'control_id' => '0',
            'datamart_structure_id' => 2,
            'quantity' => 1,
            'children' => array()
        );
        foreach ($tree as &$node) {
            $node = $node['TemplateNode'];
            unset($node['default_values']);
            $result[$node['id']] = $node;
            $result[$node['parent_id']]['children'][] = &$result[$node['id']];
        }
        
        return $result;
    }

    /**
     * Get code for 'Add From Template' button to build collection content from template.
     *
     * @param $collectionId
     *       
     * @return array Template name and url
     */
    public function getAddFromTemplateMenu($collectionId, $collectionTempalteId = null)
    {
        $visibleNodes = $this->getTools('use');
        $options['empty template'] = array(
            'icon' => 'add',
            'link' => '/InventoryManagement/Collections/template/' . $collectionId . '/0'
        );
        $collectionTemplateMenu = array();
        foreach ($visibleNodes as $template) {
            $options[$template['Template']['name']] = array(
                'icon' => 'template',
                'link' => '/InventoryManagement/Collections/template/' . $collectionId . '/' . $template['Template']['id']
            );
            if ($collectionTempalteId === $template['Template']['id']) {
                return array(
                    $template['Template']['name'] => $options[$template['Template']['name']]
                );
            }
        }
        if ($collectionTempalteId) {
            AppController::addWarningMsg(__("you don't have permissions to use the template defined by the protocol"));
        }
        return $options;
    }

    /**
     * Get list of collection templates that can be used by the user.
     *
     * @return array List of template
     */
    public function getTemplatesList($useDefinition = 'use')
    {
        if (empty($useDefinition)) {
            $useDefinition = 'use';
        }
        $visibleNodes = $this->getTools($useDefinition);
        $templatesList = array();
        foreach ($visibleNodes as $template) {
            $templatesList[$template['Template']['name']] = $template['Template']['id'];
        }
        uksort($templatesList, "strnatcasecmp");
        $templatesList = array_flip($templatesList);
        return $templatesList;
    }

    /**
     * Check if template can be deleted.
     *
     * @param integer $templateId Id of the template
     *       
     * @return array Results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     */
    public function allowDeletion($templateId)
    {
        $tmpModel = AppModel::getInstance("InventoryManagement", "Collection", true);
        $returnedNbr = $tmpModel->find('count', array(
            'conditions' => array(
                'Collection.template_id' => $templateId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'template is linked to a collection - data can not be deleted'
            );
        }
        
        $tmpModel = AppModel::getInstance("Tools", "CollectionProtocolVisit", true);
        $returnedNbr = $tmpModel->find('count', array(
            'conditions' => array(
                'CollectionProtocolVisit.template_id' => $templateId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'template is part of a collection protocol visit - data can not be deleted'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}