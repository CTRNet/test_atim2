<?php
/** **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Inventory Management plugin custom code
 * 
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */

 class ViewAliquotUseCustom extends ViewAliquotUse
{

    var $baseModel = "AliquotInternalUse";

    var $useTable = 'view_aliquot_uses';

    var $name = 'ViewAliquotUse';


}