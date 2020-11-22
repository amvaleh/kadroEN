function WaitingPopup(props) {

  return(
		<section id="waiting" className={(props.wait)?'open':''}>
			
       
				<div className="inner ">
					<img src="/img/finalkadrogif.gif" alt="Please Wait" className='waiting-style'/>
					
				</div>
		</section>
	);
}

