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

// Hide delete button. 
// Collection is deleted automatically by participant to collection link deletion.
unset($finalOptions['links']['bottom']['delete']);
unset($structureLinks['bottom']['delete']);