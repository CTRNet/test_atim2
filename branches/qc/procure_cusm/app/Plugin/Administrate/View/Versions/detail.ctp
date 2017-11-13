<?php 
	$structure_links = array();
	$this->Structures->build( $atim_structure, array('type' => 'detail', 'data' => $this->request->data[0], 'settings' => array('actions' => false)));

/*** PROCURE CUSM ******************************************************************************************/
?>        
<?php 
    if(isset($showDoanloadLink) && $showDoanloadLink==true){
?>        
        <div class="div_download_data">
            <a href="?state=downloadData"><?php echo __('Download data');?></a>
        </div>
<?php 
    }
?>        
<?php 
/*** END PROCURE CUSM ******************************************************************************************/
	
	unset($this->request->data[0]);
	$this->Structures->build( $atim_structure, array('type' => 'index', 'data' => $this->request->data, 'settings' => array('header' => __('previous versions'), 'pagination' => false)));
        
?>