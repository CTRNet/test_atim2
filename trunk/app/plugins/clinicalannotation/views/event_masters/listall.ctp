<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/clinicalannotation/event_masters/detail/'.$atim_menu_variables['Participant.id'].'/%%EventMasters.id%%',
		'bottom'=>array(
			'add'=>'/clinicalannotation/event_masters/add/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	/* EXPANDED add action, based on CONTROL->MASTER->DETAIL datatable setup */
	$expanded_add = array();
			
	// loop through related CONTROL table rows 
	foreach ( $event_controls as $option ) {
		if ( $option['EventControl']['form_alias'] && $option['EventControl']['detail_tablename'] ) {
			$expanded_add [ $option['EventControl']['id'] ] = $translations->t( $option['EventControl']['disease_site'], $lang ).' - '.$translations->t( $option['EventControl']['event_type'], $lang );
		}
	}
			
	if ( !empty( $expanded_add ) ) {
			
		echo( 
			$html->formTag( '/clinicalannotation/event_masters/add/'.$menu_id.'/'.$event_group.'/'.$participant_id.'/', 'post', array( 'id'=>'expanded_add' ) ).'
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
				<input type="submit" class="submit add" value="'.$translations->t( 'add', $lang, 0 ).'" />
				</fieldset>
			</form>
		');
	} // end IF !empty
			
	/* END expanded add */	
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>