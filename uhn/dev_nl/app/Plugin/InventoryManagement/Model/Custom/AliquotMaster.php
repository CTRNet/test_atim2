<?php
/** **********************************************************************
 * TFRI-M4S Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * Class AliquotMasterCustom
 * 
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-03-16
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
        return 'todefine';
    }

    /**
     * Generate default aliquot barcode.
     */
    public function regenerateAliquotBarcode()
    {
//         $queryToUpdate = "UPDATE aliquot_masters SET barcode = id WHERE barcode IS NULL OR barcode LIKE '';";
//         $this->tryCatchQuery($queryToUpdate);
//         $this->tryCatchQuery(str_replace("aliquot_masters", "aliquot_masters_revs", $queryToUpdate));
    }
    
}