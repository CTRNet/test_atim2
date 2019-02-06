<?php
/**
 * **********************************************************************
 * iCord
 * ***********************************************************************
 *
 * Iventory Management plugin custom code
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2019-02-05
 */

// Remove any object that can not be linked to a study by user through the customized ATiM interface.
// (To simpfly the view.)
unset($linkedRecordsProperties['participants']);
unset($linkedRecordsProperties['consents']);
unset($linkedRecordsProperties['aliquots']);
unset($linkedRecordsProperties['tma slide uses']);