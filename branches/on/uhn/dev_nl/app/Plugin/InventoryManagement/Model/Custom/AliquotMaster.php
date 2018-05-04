<?php
/** **********************************************************************
 * UHN Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 * 
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-05-04
 */
 
class AliquotMasterCustom extends AliquotMaster
{
    var $useTable = 'aliquot_masters';
    
    var $name = "AliquotMaster";
    
    /**
     * Generate default aliquot label.
     *
     * @param array $viewSample
     *            View data of the sample of the created aliquot.
     * @param array $aliquotControlData
     *            Control data of the created aliquot
     * @return string Default aliquot label.
     */
    public function generateDefaultAliquotLabel($viewSample, $aliquotControlData)
    {
        return 'Alq#'.rand(1000000,9000000);
    }

    /**
     * Update barcode
     * 
     * Bee sure you run following query build by form builder
     * 
     * UPDATE structure_formats 
     * SET `flag_add`='0', `flag_add_grid`='0'
     * WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'); 
     * 
     */
    public function regenerateAliquotBarcode()
    {
        $queryToUpdate = "UPDATE aliquot_masters SET barcode = id WHERE barcode IS NULL OR barcode LIKE '';";
        $this->tryCatchQuery($queryToUpdate);
        $this->tryCatchQuery(str_replace("aliquot_masters", "aliquot_masters_revs", $queryToUpdate));
    }
    
}