<?php
	$structure_links = array(
		'index'=>array( 
			'detail'=>'/clinicalannotation/event_masters/detail/'.$atim_menu_variables['Menu.id'].'/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/%%EventMaster.id%%'
		)
	); 
	
	$structures->build( $atim_structure, array('links'=>$structure_links));
	
	/*
	// EXPANDED add action, based on CONTROL->MASTER->DETAIL datatable setup
	$expanded_add = array();
			
	// loop through related CONTROL table rows 
	foreach ( $event_controls as $option ) {
		if ( $option['EventControl']['form_alias'] && $option['EventControl']['detail_tablename'] ) {
			$expanded_add [ $option['EventControl']['id'] ] = ($option['EventControl']['disease_site'].' - '.$option['EventControl']['event_type']);
		}
	}
	
	if ( !empty( $expanded_add ) ) {
		echo('
				<fieldset>
					<select name="event_control_id">
		');
			foreach ( $expanded_add as $key=>$value ) {
				echo('
					<option value="'.$key.'">'.$value.'</option>
				');
			}
		echo('
				</select>
				<input type="submit" class="submit add" value="'.add.'" />
				</fieldset>
			</form>
		');
	} // end IF
	*/
?>