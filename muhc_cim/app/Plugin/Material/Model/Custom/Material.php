<?php

/** **********************************************************************
 * CUSM-CIM Project.
 * ***********************************************************************
 * 
 * Class MaterialCustom
 * 
 * Material plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-02-21
 */
 
class MaterialCustom extends Material
{

    public $name = 'Material';

    public $useTable = 'materials';

    /**
     * Control if the bank is linked to an other object before any deletion.
     *
     * @param int $materialId
     *            Id of the material to delete
     * @return array Information about the possibility of deleting the data
     */
    public function allowDeletion($materialId)
    {
        // Check material has not been used
        $SampleMasterModel = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
        $returnedNbr = $SampleMasterModel->find('count', array(
            'conditions' => array(
                'OR' => array(
                    'SampleMaster.cusm_cim_material_id_1' => $materialId,
                    'SampleMaster.cusm_cim_material_id_2' => $materialId,
                    'SampleMaster.cusm_cim_material_id_3' => $materialId,
                    'SampleMaster.cusm_cim_material_id_4' => $materialId,
                    'SampleMaster.cusm_cim_material_id_5' => $materialId
                )
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'material is used'
            );
        }
        
        return parent::allowDeletion($materialId);
    }

    public function getMaterialsList($itemType = null)
    {
        $result = array();
        $conditions = array();
        if ($itemType) {
            $conditions = array(
                'Material.item_type' => $itemType
            );
        }
        foreach ($this->find('all', array(
            'conditions' => $conditions
        )) as $material) {
            $result[$material["Material"]["id"]] = $material["Material"]["item_name"].(is_null($itemType)? ' ['.__($material["Material"]["item_type"]).']' : '');
        }
        return $result;
    }
}