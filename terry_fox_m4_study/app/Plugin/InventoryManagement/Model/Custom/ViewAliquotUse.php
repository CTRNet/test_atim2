<?php
/** **********************************************************************
 * TFRI-M4S Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * Class ViewAliquotUseCustom
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-03-16
 */

class ViewAliquotUseCustom extends ViewAliquotUse
{
    
    var $baseModel = "AliquotInternalUse";
    
    var $useTable = 'view_aliquot_uses';
    
    var $name = 'ViewAliquotUse';
    
}