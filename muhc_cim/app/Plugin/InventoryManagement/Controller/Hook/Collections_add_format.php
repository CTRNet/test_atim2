<?php
/** **********************************************************************
 * CUSM-CIM Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-02-21
 */

// No collection could be created if not linked to a participant
if (! $collectionId && ! $copySource) {
    $this->flash(__('a created collection should be linked to a participant'), "javascript:history.back();", 5);
    return;
}
	