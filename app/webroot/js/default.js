function checkAll( $div ) {
	
	// check compatibility
	if ( !document.getElementsByTagName ) return false;
	if ( !document.getElementById ) return false;
	
	// check existing IDs and attributes
	if ( !document.getElementById( $div ) ) return false;
	
	allInputs = document.getElementById( $div ).getElementsByTagName( 'input' );
	for ( var i=0; i<allInputs.length; i++ ) {
		if ( allInputs[i].getAttribute('type')=='checkbox' ) {
			// allInputs[i].setAttribute('checked', 'checked');
			allInputs[i].checked = true;
		}
		
	}
	
}

function uncheckAll( $div ) {
	
	// check compatibility
	if ( !document.getElementsByTagName ) return false;
	if ( !document.getElementById ) return false;
	
	// check existing IDs and attributes
	if ( !document.getElementById( $div ) ) return false;
	
	allInputs = document.getElementById( $div ).getElementsByTagName( 'input' );
	for ( var i=0; i<allInputs.length; i++ ) {
		if ( allInputs[i].getAttribute('type')=='checkbox' ) {
			allInputs[i].checked = false;
		}
		
	}
	
}
	
/*
	admin editors, expandable list of elements
	individual elements should be wrapped in p tags, and those p tags wrapped in a containing div
	fields (input, etc) should obviously have array names as they will be exact clones
*/

	function clone_fields(containing_div) {
		
		div = document.getElementById(containing_div); // div containing add artist selects/inputs
		ps = div.getElementsByTagName("p"); // ps is array of p tags in div
		
		new_p = ps[ps.length-1].cloneNode(true); // make copy of last p tag and all elements it contains
		
		div.appendChild(new_p); // append newly copied p tag inside div
		
	}
	
	function remove_fields(p) {
	
		a = p.parentNode; // a tag is parent of onclick attribute
		div = a.parentNode; // div is parent of a tag
		
		ps = div.getElementsByTagName("p"); // ps is array of p tags in div
		
		if ( ps.length>1 ) { // if more than one p tag in div...
			div.removeChild(a); // remove p tag that a tag is in
		} else {
			alert('Sorry, you cannot remove all of these field sets.'); // alert message
		}
		
	}
	
	
	/*
		Start observing filter menus to auto-scroll them if they are too long to show in the available 250px window.
	*/
	Event.observe(window, 'load', function() {
		var menus = $$('.filter_menu');
		for(var i=0; i< menus.length; i++){
			var el = menus[i];
			Event.observe(el, 'mousemove',function(ev){
				var ul = el.getElementsByTagName('ul');
				var H = el.getHeight();
				
				if(ul.length > 0){
						var h = ul[0].getHeight();
					
					if(h > H){
						Position.absolutize(ul[0]);
						
						var el_pos = Position.cumulativeOffset(el);
						var ul_pos = Position.cumulativeOffset(ul[0]);
						
						var y = ( ev.pointerY() - el_pos[1] ) / H;
						var yh = Math.floor(y * h);
						var yH = Math.floor(y * H)
						var y_offset = yH - yh;
						
						new Effect.Move( ul[0], { x:0, y: y_offset, mode:'absolute' } );
					}
				}
			});
		}
	});