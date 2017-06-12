<?php

class Template extends AppModel
{

    public $useTable = 'templates';

    public $tree = null;

    public static $sharing = array(
        'user' => 0,
        'bank' => 1,
        'all' => 2
    );

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
            $result[$node['id']] = $node;
            $result[$node['parent_id']]['children'][] = &$result[$node['id']];
        }
        
        return $result;
    }

    /*
     * Get tamplate(s) list based on use definition.
     * When $templateId is set, system defined if template properties can be edited or not by the user
     * (Only user who created the template or administrators can change template properties or delete)
     */
    public function getTemplates($useDefintion, $templateId = null)
    {
        $conditions = array();
        $findType = $templateId ? 'first' : 'all';
        switch ($useDefintion) {
            case 'template edition':
                $conditions = array(
                    'OR' => array(
                        array(
                            'Template.owner' => 'user',
                            'Template.owning_entity_id' => AppController::getInstance()->Session->read('Auth.User.id')
                        ),
                        array(
                            'Template.owner' => 'bank',
                            'Template.owning_entity_id' => AppController::getInstance()->Session->read('Auth.User.group_id')
                        ),
                        array(
                            'Template.owner' => 'all'
                        )
                    ),
                    // Both active and inactive template
                    'Template.flag_system' => false
                );
                if (AppController::getInstance()->Session->read('Auth.User.group_id') == '1')
                    unset($conditions['OR']); // Admin can work on all templates
                if ($templateId)
                    $conditions['Template.id'] = $templateId;
                break;
            
            case 'template use':
                $conditions = array(
                    'OR' => array(
                        array(
                            'Template.visibility' => 'user',
                            'Template.visible_entity_id' => AppController::getInstance()->Session->read('Auth.User.id')
                        ),
                        array(
                            'Template.visibility' => 'bank',
                            'Template.visible_entity_id' => AppController::getInstance()->Session->read('Auth.User.group_id')
                        ),
                        array(
                            'Template.visibility' => 'all'
                        ),
                        array(
                            'Template.flag_system' => true
                        )
                    ),
                    'Template.flag_active' => 1
                );
                break;
            
            default:
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $templates = $this->find($findType, array(
            'conditions' => $conditions
        ));
        if ($templates && $findType == 'first') {
            $templates['Template']['allow_properties_edition'] = ((AppController::getInstance()->Session->read('Auth.User.group_id') == 1) || (AppController::getInstance()->Session->read('Auth.User.id') == $templates['Template']['created_by']));
        }
        return $templates;
    }

    /*
     * Get code for 'Add From Template' button to build collection content from template
     */
    public function getAddFromTemplateMenu($collectionId)
    {
        $visibleNodes = $this->getTemplates('template use');
        $options['empty template'] = array(
            'icon' => 'add',
            'link' => '/InventoryManagement/Collections/template/' . $collectionId . '/0'
        );
        foreach ($visibleNodes as $template) {
            $options[$template['Template']['name']] = array(
                'icon' => 'template',
                'link' => '/InventoryManagement/Collections/template/' . $collectionId . '/' . $template['Template']['id']
            );
        }
        
        return $options;
    }

    public function setOwnerAndVisibility(&$tempateData, $createdBy = null)
    {
        if (Template::$sharing[$tempateData['Template']['visibility']] < Template::$sharing[$tempateData['Template']['owner']]) {
            $tempateData['Template']['owner'] = $tempateData['Template']['visibility'];
            AppController::addWarningMsg(__('visibility reduced to owner level'));
        }
        
        // Get template user & group ids--------------
        $templateUserId = AppController::getInstance()->Session->read('Auth.User.id');
        $templateGroupId = AppController::getInstance()->Session->read('Auth.User.group_id');
        if ($createdBy && $createdBy != $templateUserId) {
            // Get real tempalte owner and group in case admiistrator is changing data
            $templateUserId = $createdBy;
            
            $userModel = AppModel::getInstance("", "User", true);
            $templateUserData = $userModel->find('first', array(
                'conditions' => array(
                    'User.id' => $createdBy,
                    'User.deleted' => array(
                        0,
                        1
                    )
                )
            ));
            $templateUserId = $templateUserData['User']['id'];
            $templateGroupId = $templateUserData['Group']['id'];
        }
        
        // update entities----------
        $tempateData['Template']['owning_entity_id'] = null;
        $tempateData['Template']['visible_entity_id'] = null;
        $tmp = array(
            'owner' => array(
                $tempateData['Template']['owner'] => &$tempateData['Template']['owning_entity_id']
            ),
            'visibility' => array(
                $tempateData['Template']['visibility'] => &$tempateData['Template']['visible_entity_id']
            )
        );
        
        foreach ($tmp as $level) {
            foreach ($level as $sharing => &$value) {
                switch ($sharing) {
                    case "user":
                        $value = $templateUserId;
                        break;
                    case "bank":
                        $value = $templateGroupId;
                        break;
                    case "all":
                        $value = '0';
                        break;
                    default:
                        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            }
        }
        
        $this->addWritableField(array(
            'owning_entity_id',
            'visible_entity_id'
        ));
    }
}
