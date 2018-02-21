<?php

/**
 * Class AliquotMasterCustom
 */
class AliquotMasterCustom extends AliquotMaster
{
    var $useTable = 'aliquot_masters';
    
    var $name = "AliquotMaster";
    
//     /**
//      * @param array $options
//      * @return bool
//      */
//     public function beforeSave($options = array())
//     {
//         $retVal = parent::beforeSave($options);
//         if (!isset($this->id)) {
//             if (!isset($this->data['AliquotMaster']['collection_id'])) {
//                 AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);  
//             } else {
//                 $this->ViewCollection = AppModel::getInstance('InventoryManagement', 'ViewCollection', true);
//                 $collectionData = $this->ViewCollection->find('first', array(
//                     'conditions' => array(
//                         'ViewCollection.collection_id' => $this->data['AliquotMaster']['collection_id']
//                     ),
//                     'recursive' => 0
//                 ));
//                 if(!$collectionData) {
//                     AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
//                 }
//                 $this->data['AliquotMaster']['study_summary_id'] = $collectionData['Participant']['cusm_cim_study_summary_id'];
//                 $this->addWritableField(array('study_summary_id'));
//             }
//         }
//         return $retVal;
//     }

}