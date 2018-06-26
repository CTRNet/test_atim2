<?php
/** **********************************************************************
 * NBI Project..
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-04-06
 */

// Collection should be linked to a participant. 
// No collection could be created from main form.
if(isset($finalOptions2)) {
	unset($finalOptions2['links']['bottom']['add collection']);		
}
